/* vim: set expandtab tw=80 sw=8 ts=8: */
/*-
 * Copyright (c) 2006 Wolfgang Rosenauer
 * All rights reserved.
 *
 * Copyright (c) 1999, 2000, 2001, 2002, 2004, 2007 Andrew J. Korty
 * All rights reserved.
 *
 * Copyright (c) 2001, 2002 Networks Associates Technology, Inc.
 * All rights reserved.
 *
 * Portions of this software were developed for the FreeBSD Project by
 * ThinkSec AS and NAI Labs, the Security Research Division of Network
 * Associates, Inc.  under DARPA/SPAWAR contract N66001-01-C-8035
 * ("CBOSS"), as part of the DARPA CHATS research program.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * $Id: pam_ssh.c,v 1.84 2008/05/12 18:57:12 rosenauer Exp $
 */

/* to get the asprintf() prototype from the glibc headers */
#define _GNU_SOURCE

#include <sys/cdefs.h>
#include <sys/param.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <config.h>
#if HAVE_SYS_WAIT_H
# include <sys/wait.h>
#endif
#ifndef WEXITSTATUS
# define WEXITSTATUS(x)	((unsigned)(x) >> 8)
#endif
#ifndef WTERMSIG
# define WTERMSIG(x)	((x) & 0177)
#endif
#ifndef WIFSIGNALED
# define WIFSIGNALED(x)	(WTERMSIG(x) != _WSTOPPED && WTERMSIG(x) != 0)
#endif

#include <errno.h>
#include <dirent.h>
#include <fcntl.h>
#include <fnmatch.h>
#include <pwd.h>
#include <signal.h>
#include <stdio.h>
#include <syslog.h>
#include <stdlib.h>
#include <string.h>
#include <sysexits.h>
#include <unistd.h>
#include <time.h>
#include <grp.h>

#define PAM_SM_AUTH
#define PAM_SM_SESSION
#if !HAVE_OPENPAM
# define PAM_SM_ACCOUNT
# define PAM_SM_PASSWORD
#endif

#include <pam_modules.h>
#if HAVE_PAM_MOD_MISC_H
# include <pam_mod_misc.h>
#endif

#include <openssl/dsa.h>
#include <openssl/evp.h>

#include "log.h"
#include "key.h"
#include "buffer.h"
#include "authfd.h"
#include "authfile.h"
#include "pam_ssh_log.h"
#if !HAVE_DECL_OPENPAM_BORROW_CRED || !HAVE_DECL_OPENPAM_RESTORE_CRED
# include "openpam_cred.h"
#endif
#if !HAVE_PAM_STRUCT_OPTTAB
# include "pam_opttab.h"
#endif
#if !HAVE_PAM_STD_OPTION && !HAVE_OPENPAM
# include "pam_option.h"
#endif
#if !HAVE_PAM_GET_PASS
# include "pam_get_pass.h"
#endif
#include "openssl_compat.h"

#if !defined(__unused)
# define __unused
#endif

#define	MODULE_NAME "pam_ssh"
#define	NEED_PASSPHRASE "SSH passphrase: "
#define ENV_PID_SUFFIX "_AGENT_PID"
#define ENV_SOCKET_SUFFIX "_AUTH_SOCK"
#define PAM_OPT_BLANK_PASSPHRASE_NAME	"allow_blank_passphrase"
#define PAM_OPT_NULLOK_NAME "nullok"
#define SSH_DIR ".ssh"
#define SSH_LOGIN_KEYS_DIR   "login-keys.d"
#define SSH_SESSION_KEYS_DIR "session-keys.d"

enum {
#if HAVE_OPENPAM || HAVE_PAM_STRUCT_OPTIONS || !HAVE_PAM_STD_OPTION
	PAM_OPT_BLANK_PASSPHRASE = PAM_OPT_STD_MAX,
	PAM_OPT_NULLOK
#else
	PAM_OPT_BLANK_PASSPHRASE,
	PAM_OPT_NULLOK
#endif
};

static struct opttab other_options[] = {
	{ PAM_OPT_BLANK_PASSPHRASE_NAME,	PAM_OPT_BLANK_PASSPHRASE },
	{ PAM_OPT_NULLOK_NAME,	                PAM_OPT_NULLOK },
	{ NULL, 0 }
};

/* global variable to enable debug logging */
int log_debug = 0;

char *
opt_arg(const char *arg)
{
	char *retval;

	if (!(retval = strchr(arg, '=')))
		return retval;
	++retval;
	return retval;
}

pid_t
waitpid_intr(pid_t pid, int *status, int options)
{
	pid_t retval;

	do {
		retval = waitpid(pid, status, options);
	} while (retval == -1 && errno == EINTR);
	return retval;
}

/*
 * Generic cleanup function for OpenSSH "Key" type.
 */

static void
key_cleanup(pam_handle_t *pamh __unused, void *data, int err __unused)
{
	if (data)
		key_free(data);
}


/*
 * Generic PAM cleanup function for this module.
 */

static void
ssh_cleanup(pam_handle_t *pamh __unused, void *data, int err __unused)
{
	if (data)
		free(data);
}

/*
 * Reverse comparison function for key names supplied to scandir(3).
 */

static int
keyname_compare(const struct dirent **a, const struct dirent **b)
{
        /* reverse alphasort (scandir(3)) */
        return strcoll((*b)->d_name, (*a)->d_name);
}

/*
 * If the private key's passphrase is blank, only load it if the
 * *supplied* passphrase is blank and if allow_blank_passphrase is
 * set.
 */

static Key *
key_load_private_maybe(const char *path, const char *passphrase,
      char **commentp, int allow_blank)
{
        /* discard any blank passphrase load if not allowed */
        if (*passphrase == '\0' && !allow_blank) return NULL;
        /* otherwise load */
        return key_load_private(path, passphrase, commentp);
}

/*
 * Authenticate a user's key by trying to decrypt it with the password
 * provided.  The key and its name as comment are then stored for later
 * retrieval by the session phase.  An increasing index is embedded in
 * the PAM variable names so this function may be called multiple times
 * for multiple keys.
 */

static int
auth_via_key(pam_handle_t *pamh, const char *path, const char *name,
             const char *pass, int allow_blank)
{
	char *comment;		/* private key comment */
	char *data_name;	/* PAM state */
	static int index = 0;	/* for saved keys */
	Key *key;		/* user's key */
	int retval;		/* from calls */

	/* an int only goes so far */

	if (index < 0)
		return PAM_SERVICE_ERR;

	/* Try to decrypt the private key with the passphrase provided.  If
	   success, the user is authenticated. */

	if (!(key = key_load_private_maybe(path, pass, NULL, allow_blank))) {
		return PAM_AUTH_ERR;
	}
	if (!(comment = strdup(name))) {
		pam_ssh_log(LOG_CRIT, "out of memory");
		return PAM_SERVICE_ERR;
	}

	/* save the key and comment to pass to ssh-agent in the session
           phase */

	if (asprintf(&data_name, "ssh_private_key_%d", index) == -1) {
		free(comment);
		pam_ssh_log(LOG_CRIT, "out of memory");
		return PAM_SERVICE_ERR;
	}
	retval = pam_set_data(pamh, data_name, key, key_cleanup);
	free(data_name);
	if (retval != PAM_SUCCESS) {
		key_free(key);
		free(comment);
		return retval;
	}
	if (asprintf(&data_name, "ssh_key_comment_%d", index) == -1) {
		pam_ssh_log(LOG_CRIT, "out of memory");
		free(comment);
		return PAM_SERVICE_ERR;
	}
	retval = pam_set_data(pamh, data_name, comment, ssh_cleanup);
	free(data_name);
	if (retval != PAM_SUCCESS) {
		free(comment);
		return retval;
	}

	++index;
	return PAM_SUCCESS;
}


/*
 * Add the keys stored by auth_via_key() to the agent connected to the
 * socket provided.
 */

static int
add_keys(pam_handle_t *pamh, AuthenticationConnection *ac)
{
	char *comment;			/* private key comment */
	char *data_name;		/* PAM state */
	int final;			/* final return value */
	int index;			/* for saved keys */
	Key *key;			/* user's private key */
	int retval;			/* from calls */

	/* hand off each private key to the agent */

	final = 0;
	for (index = 0; index >= 0; index++) {
		if (asprintf(&data_name, "ssh_private_key_%d", index) == -1) {
			pam_ssh_log(LOG_CRIT, "out of memory");
			ssh_close_authentication_connection(ac);
			return PAM_SERVICE_ERR;
		}
		retval = pam_get_data(pamh, data_name,
		    (const void **)(void *)&key);
		free(data_name);
		if (retval != PAM_SUCCESS)
			break;
		if (asprintf(&data_name, "ssh_key_comment_%d", index) == -1) {
			pam_ssh_log(LOG_CRIT, "out of memory");
			ssh_close_authentication_connection(ac);
			return PAM_SERVICE_ERR;
		}
		retval = pam_get_data(pamh, data_name,
		    (const void **)(void *)&comment);
		free(data_name);
		if (retval != PAM_SUCCESS)
			break;
		retval = ssh_add_identity_constrained(ac, key, comment, 0, 0);
		if (!final)
			final = retval;
	}

	return final ? PAM_SUCCESS : PAM_SESSION_ERR;
}

static int
start_ssh_agent(pam_handle_t *pamh, uid_t uid, gid_t gid, const char * name, FILE **env_read)
{
#ifdef SSH_AGENT_GROUP_NAME
        struct group *ssh_grp;          /* ssh group holder, if any */
#endif
        gid_t rgid;                     /* ssh GID if ssh group exist, gid otherwise */
	pid_t child_pid;		/* child process that spawns agent */
	int child_pipe[2];		/* pipe to child process */
	int child_status;		/* child process status */
	sigset_t sigmask;		/* blocked signal mask */
	char *arg[2], *env[2];		/* to pass to execve() */
        const char *tmpdir;             /* TMPDIR environment variable value */
        char env_tmpdir[8+MAXPATHLEN];  /* TMPDIR=$TMPDIR env equation to pass to execve() */
        int retval;                     /* from calls */

	if (pipe(child_pipe) < 0) {
		pam_ssh_log(LOG_ERR, "pipe: %m");
		return PAM_SERVICE_ERR;
	}
	switch (child_pid = fork()) {
	case -1:	/* error */
		pam_ssh_log(LOG_ERR, "fork: %m");
		close(child_pipe[0]);
		close(child_pipe[1]);
		return PAM_SERVICE_ERR;
		/* NOTREACHED */
	case 0:		/* child */

		/* Permanently drop privileges using setuid(),
			 setregid(), and initgroups()
			 before executing ssh-agent so that root
			 privileges can't possibly be regained (some
			 ssh-agents insist that euid == ruid anyway).
                         Some distributions, as Debian, set'gid ssh-agent
                         wrt to a ssh dedicated group to prevent ptrace()
                         attacks retrieving private key material,
                         so we first check the existence of such a group
                         and assume such a policy if applicable.
                         System V won't let us use setuid() unless
                         euid == 0, so we temporarily regain root
                         privileges first with openpam_restore_cred()
                         (which calls seteuid()). */
#ifdef SSH_AGENT_GROUP_NAME
                if ((ssh_grp = getgrnam(SSH_AGENT_GROUP_NAME)) != NULL)
                        rgid = ssh_grp->gr_gid;
                else
#endif
                        rgid = gid;

		switch (openpam_restore_cred(pamh)) {
		case PAM_SYSTEM_ERR:
			pam_ssh_log(LOG_ERR, "can't restore privileges: %m");
			_exit(EX_OSERR);
			/* NOTREACHED */
		case PAM_SUCCESS:
			if ((initgroups(name, gid) == -1) || (setregid(rgid, gid) == -1) || (setuid(uid) == -1)) {
				pam_ssh_log(LOG_ERR, "can't drop privileges: %m", uid);
				_exit(EX_NOPERM);
			}
			break;
		}

		if (close(child_pipe[0]) == -1) {
			pam_ssh_log(LOG_ERR, "close: %m");
			_exit(EX_OSERR);
		}
		if (child_pipe[1] != STDOUT_FILENO) {
			if (dup2(child_pipe[1], STDOUT_FILENO) == -1) {
				pam_ssh_log(LOG_ERR, "dup: %m");
				_exit(EX_OSERR);
			}
			if (close(child_pipe[1]) == -1) {
				pam_ssh_log(LOG_ERR, "close: %m");
				_exit(EX_OSERR);
			}
		}

		sigemptyset(&sigmask);
		sigprocmask(SIG_SETMASK, &sigmask, NULL);

		arg[0] = "ssh-agent";
		arg[1] = NULL;
		env[0] = NULL;
                env[1] = NULL;

                if ((tmpdir = pam_getenv(pamh, "TMPDIR")) != NULL) {
                        retval = snprintf(env_tmpdir, sizeof(env_tmpdir), "TMPDIR=%s", tmpdir);
                        if (retval > 0 && (size_t)retval < sizeof(env_tmpdir))
                              env[0] = env_tmpdir;
                }

		pam_ssh_log(LOG_DEBUG, "start ssh-agent");
		execve(PATH_SSH_AGENT, arg, env);
		pam_ssh_log(LOG_ERR, "%s: %m", PATH_SSH_AGENT);
		_exit(127);
		/* NOTREACHED */
	}
	if (close(child_pipe[1]) == -1) {
		pam_ssh_log(LOG_ERR, "close: %m");
		return PAM_SESSION_ERR;
	}
	if (!(*env_read = fdopen(child_pipe[0], "r"))) {
		pam_ssh_log(LOG_ERR, "%s: %m", PATH_SSH_AGENT);
		return PAM_SESSION_ERR;
	}

	child_status = 0;
	if (waitpid_intr(child_pid, &child_status, 0) == -1 &&
			errno != ECHILD) {
		pam_ssh_log(LOG_ERR, "%s: %m", PATH_SSH_AGENT);
		return PAM_SESSION_ERR;
	}

	if (child_status != 0) {
		if (WIFSIGNALED(child_status))
			pam_ssh_log(LOG_ERR, "%s exited on signal %d", PATH_SSH_AGENT, WTERMSIG(child_status));
		else
			if (WEXITSTATUS(child_status) == 127)
				pam_ssh_log(LOG_ERR, "cannot execute %s", PATH_SSH_AGENT);
			else
				pam_ssh_log(LOG_ERR, "%s exited with status %d", PATH_SSH_AGENT, WEXITSTATUS(child_status));
		return PAM_SESSION_ERR;
	}

	return PAM_SUCCESS;
}

static int
read_write_agent_env(pam_handle_t *pamh,
                     FILE *env_read,
                     int env_write,
                     char **agent_socket)
{
	char *agent_pid;		/* copy of agent PID */
	char *env_end;			/* end of env */
	char env_string[BUFSIZ];	/* environment string */
	char *env_value;		/* envariable value */
	int retval;			/* from calls */

	while (fgets(env_string, sizeof env_string, env_read)) {

		/* parse environment definitions */

		if (env_write >= 0)
			write(env_write, env_string, strlen(env_string));
		if (!(env_value = strchr(env_string, '=')) ||
		    !(env_end = strchr(env_value, ';')))
			continue;
		*env_end = '\0';

		/* pass to the application */

		if ((retval = pam_putenv(pamh, env_string)) != PAM_SUCCESS)
			return retval;

		*env_value++ = '\0';

		/* save the agent socket so we can connect to it and add
		   the keys as well as the PID so we can kill the agent on
		   session close. */

		agent_pid = NULL;
		if (strcmp(&env_string[strlen(env_string) -
		    strlen(ENV_SOCKET_SUFFIX)], ENV_SOCKET_SUFFIX) == 0 &&
		    !(*agent_socket = strdup(env_value))) {
			pam_ssh_log(LOG_CRIT, "out of memory");
			return PAM_SERVICE_ERR;
		} else if (strcmp(&env_string[strlen(env_string) -
		    strlen(ENV_PID_SUFFIX)], ENV_PID_SUFFIX) == 0 &&
		    (!(agent_pid = strdup(env_value)) ||
		    (retval = pam_set_data(pamh, "ssh_agent_pid",
		    agent_pid, ssh_cleanup)) != PAM_SUCCESS)) {
			if (agent_pid)
				free(agent_pid);
			else {
				pam_ssh_log(LOG_CRIT, "out of memory");
				return PAM_SERVICE_ERR;
			}
			if (*agent_socket) {
				free(*agent_socket); *agent_socket = NULL;
			}
			return retval;
		}

	}

	return PAM_SUCCESS;
}

static int
login_keys_selector(const struct dirent * candidate)
{
	if (candidate) {
		mode_t mode=DTTOIF(candidate->d_type);
		/* Discard non-regular/non-linked files. */
		if (S_ISREG(mode)) {
			/* Ignore disabled/frozen files. */
			const char * suffix=strchrnul(candidate->d_name,'.');
			if (!((!(strcmp(".disabled",suffix))) || (!(strcmp(".frozen",suffix))))) {
				pam_ssh_log(LOG_DEBUG/*2*/, "file '%s' selected.", candidate->d_name);
				return 1;
			}
			else {
				pam_ssh_log(LOG_DEBUG/*2*/, "file '%s' ignored.", candidate->d_name);
				return 0;
			}
		}
		else if (S_ISLNK(mode)) {
			/* Ignore disabled/frozen files. */
			const char * suffix=strchrnul(candidate->d_name,'.');
			if (!((!(strcmp(".disabled",suffix))) || (!(strcmp(".frozen",suffix))))) {
				pam_ssh_log(LOG_DEBUG/*2*/, "link '%s' selected.", candidate->d_name);
				return 1;
			}
			else {
				pam_ssh_log(LOG_DEBUG/*2*/, "link '%s' ignored.", candidate->d_name);
				return 0;
			}
		}
                else if (S_ISDIR(mode)) {
                        /* the current and parent directories are implicitly ignored */
                        if (!((*(candidate->d_name) == '.') && ((*(candidate->d_name+1) == '\0') || ((*(candidate->d_name+1) == '.') && (*(candidate->d_name+2) == '\0'))))) {
                                pam_ssh_log(LOG_DEBUG/*2*/, "directory '%s' ignored.", candidate->d_name);
                        }
                return 0;
                }
                else {
                        pam_ssh_log(LOG_DEBUG/*2*/, "file '%s' discarded.", candidate->d_name);
                        return 0;
                }
        }

	return 0;
}

/* process standard SSH keys */
static void
unlock_standard_keys(pam_handle_t *pamh, const char *pass, const char *dotdir,
                     int allow_blank)
{
        const char *files[] = {"id_ed25519","id_ecdsa", "id_dsa", "id_rsa", NULL};
        char *path = NULL;
        int i;

	if (0 == pass) {
		pam_ssh_log(LOG_DEBUG, "No preceding password.");
		return;
	}

	pam_ssh_log(LOG_DEBUG, "Looking for SSH keys in '%s'.", dotdir);
	for (i = 0; files[i]; ++i) {
		pam_ssh_log(LOG_DEBUG, "SSH key candidate '%s'.", files[i]);
		/* Locate the user's private key file. */
		if (asprintf(&path, "%s/%s", dotdir, files[i]) == -1) {
			pam_ssh_log(LOG_CRIT, "out of memory");
			return;
		}
		if (PAM_SUCCESS == auth_via_key(pamh, path, files[i], pass, allow_blank)) {
			pam_ssh_log(LOG_DEBUG, "SSH key '%s' decrypted.", files[i]);
		} else {
			pam_ssh_log(LOG_DEBUG, "SSH key candidate '%s' failed.", files[i]);
		}
		free(path); path=NULL;
	}
}

/* process SSH keys in session directory */
static void
unlock_session_keys(pam_handle_t *pamh, const char *pass, const char *dotdir,
                     int allow_blank)
{
        char *sessiondir = NULL;
        struct dirent **keylist = NULL;
        int n = 0;
	char *path = NULL;
        const char *file;

	if (0 == pass) {
		pam_ssh_log(LOG_DEBUG, "No preceding password.");
		return;
	}

        if (asprintf(&sessiondir, "%s/%s", dotdir, SSH_SESSION_KEYS_DIR) == -1) {
                pam_ssh_log(LOG_CRIT, "out of memory");
                openpam_restore_cred(pamh);
                return;
        }

        pam_ssh_log(LOG_DEBUG, "Looking for SSH keys in '%s'.", sessiondir);
	n = scandir(sessiondir, &keylist, &login_keys_selector, keyname_compare);
	if (-1 == n) {
		if (ENOMEM == errno) {
			pam_ssh_log(LOG_CRIT, "out of memory");
			openpam_restore_cred(pamh);
			return;
		}
		else {
			pam_ssh_log(LOG_DEBUG, "No SSH session-keys directory.");
                        return;
		}
	}
	while (n--) {
		file = keylist[n]->d_name;
		pam_ssh_log(LOG_DEBUG, "SSH session key candidate '%s'.", file);
		/* Locate the user's private key file. */
		if (asprintf(&path, "%s/%s", sessiondir, file) == -1) {
			pam_ssh_log(LOG_CRIT, "out of memory");
			free(keylist);
                        return;
		}
		if (PAM_SUCCESS == auth_via_key(pamh, path, file, pass, allow_blank)) {
			pam_ssh_log(LOG_DEBUG, "SSH key '%s' decrypted.", file);
		} else {
			pam_ssh_log(LOG_DEBUG, "SSH key candidate '%s' failed.", file);
		}
		free(path); path=NULL;
	}
        free(keylist);
        free(sessiondir);
}

/* process SSH keys in (login) directory */
static int
unlock_at_least_one_key(pam_handle_t *pamh, const char *pass, const char *dotdir,
                        struct dirent **namelist, int n, int allow_blank)
{
	const char * file;
	char *path = NULL;
	int result = PAM_AUTH_ERR;
	if (0 == pass) {
		pam_ssh_log(LOG_DEBUG, "No preceding password.");
		return PAM_AUTH_ERR;
	}
	pam_ssh_log(LOG_DEBUG, "Looking for SSH keys in '%s'.", dotdir);
	/* Any key will authenticate us, but if we can decrypt all of the
	   specified keys, we will do so here so we can cache them in the
	   session phase. */
	while (n--) {
		file = namelist[n]->d_name;
		pam_ssh_log(LOG_DEBUG/*2*/, "SSH login key candidate '%s'.", file);
		/* Locate the user's private key file. */
		if (asprintf(&path, "%s/%s", dotdir, file) == -1) {
			pam_ssh_log(LOG_CRIT, "out of memory");
			return PAM_SERVICE_ERR;
		}
		if (PAM_SUCCESS == auth_via_key(pamh, path, file, pass, allow_blank)) {
			pam_ssh_log(LOG_DEBUG, "SSH key '%s' decrypted.", file);
			result = PAM_SUCCESS;
		} else {
			pam_ssh_log(LOG_DEBUG, "SSH key candidate '%s' failed.", file);
		}
		free(path); path=NULL;
	}
	return result;
}

#define CLEANUP_AND_RETURN(retcode) \
	while (n--) free(namelist[n]); \
	free(namelist); \
	free(dotdir); \
	free(logindir); \
	openpam_restore_cred(pamh); \
	return retcode

PAM_EXTERN int
pam_sm_authenticate(pam_handle_t *pamh, int flags __unused, int argc,
    const char **argv)
{
	int allow_blank_passphrase = 0;	/* allow blank passphrases? */
	char *dotdir;			/* .ssh dir name */
	char *logindir;			/* login-key dir name */
	int n;                          /* count of ssh keys */
	struct dirent **namelist;       /* ssh keys */
#if HAVE_PAM_STRUCT_OPTIONS || !HAVE_PAM_STD_OPTION
	struct options options;		/* options for pam_get_pass() */
#else
	int options;			/* options for pam_get_pass() */
#endif
	const char *pass;		/* passphrase */
	const struct passwd *pwent;	/* user's passwd entry */
	int retval;			/* from calls */
	const char *user;		/* username */

	dotdir = logindir = NULL;
#if HAVE_OPENPAM
	log_init(MODULE_NAME, SYSLOG_LEVEL_ERROR, SYSLOG_FACILITY_AUTHPRIV, 0);
	if ((openpam_get_option(pamh, PAM_OPT_BLANK_PASSPHRASE))
			|| (openpam_get_option(pamh, PAM_OPT_NULLOK)))
		allow_blank_passphrase = 1;
#elif HAVE_PAM_STRUCT_OPTIONS || !HAVE_PAM_STD_OPTION
	memset(&options, 0, sizeof options);
	pam_std_option(&options, other_options, argc, argv);
	if ((log_debug = pam_test_option(&options, PAM_OPT_DEBUG, NULL)))
		log_init(MODULE_NAME, SYSLOG_LEVEL_DEBUG3, SYSLOG_FACILITY_AUTHPRIV, 0);
	else
		log_init(MODULE_NAME, SYSLOG_LEVEL_ERROR, SYSLOG_FACILITY_AUTHPRIV, 0);
	pam_ssh_log(LOG_DEBUG, "init authentication module");
	allow_blank_passphrase =
		pam_test_option(&options, PAM_OPT_BLANK_PASSPHRASE, NULL);
	if(!allow_blank_passphrase)
		allow_blank_passphrase =
			pam_test_option(&options, PAM_OPT_NULLOK, NULL);
#else
	log_init(MODULE_NAME, SYSLOG_LEVEL_ERROR, SYSLOG_FACILITY_AUTHPRIV, 0);
	options = 0;
	for (; argc; argc--, argv++) {
		struct opttab *p;

		for (p = other_options; p->name != NULL; p++) {
			if (strcmp(*argv, p->name) != 0)
				continue;
			switch (p->value) {
				PAM_OPT_BLANK_PASSPHRASE:
      	PAM_OPT_NULLOK:
					allow_blank_passphrase = 1;
					break;
			}
		}
		pam_std_option(&options, *argv);
	}
#endif

	if ((retval = pam_get_user(pamh, &user, NULL)) != PAM_SUCCESS) {
		pam_ssh_log(LOG_ERR, "can't get username (ret=%d)", retval);
		return retval;
	}

	if (!(user && (pwent = getpwnam(user)))) {
		pam_ssh_log(LOG_ERR, "user not known");
		if (! pam_test_option(&options, PAM_OPT_USE_FIRST_PASS, NULL)) {
			/* Asking for passphrase anyway to not leak information. */
			pam_conv_pass(pamh, NEED_PASSPHRASE, &options);
		}
		openpam_restore_cred(pamh);
		return PAM_AUTH_ERR;
	}

	if (!(pwent->pw_dir && *pwent->pw_dir)) {
		pam_ssh_log(LOG_ERR, "cannot get home directory");
		if (! pam_test_option(&options, PAM_OPT_USE_FIRST_PASS, NULL)) {
			/* Asking for passphrase anyway to not leak information. */
			pam_conv_pass(pamh, NEED_PASSPHRASE, &options);
		}
		openpam_restore_cred(pamh);
		return PAM_AUTH_ERR;
	}

	retval = openpam_borrow_cred(pamh, pwent);
	if (retval != PAM_SUCCESS && retval != PAM_PERM_DENIED) {
		pam_ssh_log(LOG_ERR, "can't drop privileges: %m");
		return retval;
	}

	/* Locate SSH directory. */
	if (asprintf(&dotdir, "%s/%s", pwent->pw_dir, SSH_DIR) == -1) {
		pam_ssh_log(LOG_CRIT, "out of memory");
		openpam_restore_cred(pamh);
		return PAM_SERVICE_ERR;
	}

	/* Locate SSH login-keys directory. */
	if (asprintf(&logindir, "%s/%s", dotdir, SSH_LOGIN_KEYS_DIR) == -1) {
		pam_ssh_log(LOG_CRIT, "out of memory");
		openpam_restore_cred(pamh);
		return PAM_SERVICE_ERR;
	}

	namelist = NULL;
	n = scandir(logindir, &namelist, &login_keys_selector, keyname_compare);
	if (-1 == n) {
		if (ENOMEM == errno) {
			pam_ssh_log(LOG_CRIT, "out of memory");
			openpam_restore_cred(pamh);
			return PAM_SERVICE_ERR;
		}
		else {
			pam_ssh_log(LOG_DEBUG, "No SSH login-keys directory.");
			n = 0;
		}
	}

	OpenSSL_add_all_algorithms(); /* required for DSA */

	/* Grab an already-entered password from a previous module if the user
		 wants to use it for the SSH keys. */
	if ((pam_test_option(&options, PAM_OPT_TRY_FIRST_PASS, NULL))
		|| (pam_test_option(&options, PAM_OPT_USE_FIRST_PASS, NULL))) {
		pam_ssh_log(LOG_DEBUG, "Grabbing password from preceding auth module.");
		retval = pam_get_item(pamh, PAM_AUTHTOK, (const void **)&pass);
		if (retval != PAM_SUCCESS) {
			pam_ssh_log(LOG_DEBUG, "Could not grab password from preceding auth module.");
			CLEANUP_AND_RETURN(retval);
		}
	}

	/* If use_first_password option given, then go through all keys and
	   unlock each that matches.  If none matches, fail, otherwise succeed. */
	if (pam_test_option(&options, PAM_OPT_USE_FIRST_PASS, NULL)) {
		pam_ssh_log(LOG_DEBUG, "Using previous password for SSH keys.");
		/* Unlock any of the session SSH keys with the password from the previous PAM module. */
		unlock_session_keys(pamh,pass,dotdir,allow_blank_passphrase);
		if (0 == n) {
        		/* Fail if there are no SSH login keys. */
                        retval = PAM_AUTH_ERR;
		}
                else {
                        /* Unlock the login SSH keys with the password from the previous PAM module. */
		        retval = unlock_at_least_one_key(pamh, pass, logindir, namelist, n, allow_blank_passphrase);
                }
                /* Unlock any of the standard SSH keys with the password from the previous PAM module. */
	        unlock_standard_keys(pamh,pass,dotdir,allow_blank_passphrase);
		CLEANUP_AND_RETURN(retval);
	}

	/* If try_first_password option given, then go through all keys and
	   unlock each that matches. If any matches, then succeed. */
	if (pam_test_option(&options, PAM_OPT_TRY_FIRST_PASS, NULL)) {
		pam_ssh_log(LOG_DEBUG, "Trying previous password for SSH keys.");
		/* Unlock any of the session SSH keys with the password from the previous PAM module. */
		unlock_session_keys(pamh,pass,dotdir,allow_blank_passphrase);
		if (0 == n) {
        		/* Unlock any of the standard SSH keys with the password from the previous PAM module. */
	        	unlock_standard_keys(pamh,pass,dotdir,allow_blank_passphrase);
        		/* Fail if there are no SSH login keys. */
			CLEANUP_AND_RETURN(PAM_AUTH_ERR);
		}
                else {
                        /* Unlock the login SSH keys with the password from the previous PAM module. */
		        retval = unlock_at_least_one_key(pamh, pass, logindir, namelist, n, allow_blank_passphrase);
		        /* Unlock any of the standard SSH keys with the password from the previous PAM module. */
		        unlock_standard_keys(pamh,pass,dotdir,allow_blank_passphrase);
		        if (PAM_SUCCESS == retval) {
			        CLEANUP_AND_RETURN(PAM_SUCCESS);
		        }
                }
	}

#if 0
	/* Fail if there are no SSH login keys. */
        if (0 == n) {
	        CLEANUP_AND_RETURN(PAM_AUTH_ERR);
	}
#endif

	/* Either no option was given, or try_first_password was given but could not
 	   use the previous password, so we need to get a specific SSH key passphrase. */
	pam_ssh_log(LOG_DEBUG, "Asking for SSH key passphrase.");
	retval = pam_conv_pass(pamh, NEED_PASSPHRASE, &options);
	if (retval != PAM_SUCCESS) {
		pam_ssh_log(LOG_DEBUG, "Could not get SSH key passphrase.");
		CLEANUP_AND_RETURN(retval);
	}
	retval = pam_get_item(pamh, PAM_AUTHTOK, (const void **)&pass);
	if (retval != PAM_SUCCESS) {
		pam_ssh_log(LOG_DEBUG, "Could not obtain passphrase.");
		CLEANUP_AND_RETURN(retval);
	}
	/* Unlock any of the session SSH keys with the passphrase. */
	unlock_session_keys(pamh, pass, dotdir, allow_blank_passphrase);
	/* Unlock any of the login SSH keys with the passphrase. */
	retval = unlock_at_least_one_key(pamh, pass, logindir, namelist, n, allow_blank_passphrase);
	/* Unlock any of the standard SSH keys with the passphrase. */
	unlock_standard_keys(pamh, pass, dotdir, allow_blank_passphrase);
	CLEANUP_AND_RETURN(retval);
}


PAM_EXTERN int
pam_sm_setcred(pam_handle_t *pamh __unused, int flags __unused,
    int argc __unused, const char **argv __unused)
{
	return PAM_SUCCESS;
}


PAM_EXTERN int
pam_sm_open_session(pam_handle_t *pamh, int flags,
    int argc, const char **argv)
{
	AuthenticationConnection *ac;	/* connection to ssh-agent */
	char *agent_socket;		/* agent socket */
	char *cp;			/* scratch */
	FILE *env_read;			/* env data source */
	int env_write;			/* env file descriptor */
	char hname[MAXHOSTNAMELEN];	/* local hostname */
	int no_link;      /* link per-agent file? */
	char *dotdir;		        /* .ssh dir name */
	char *per_agent;		/* to store env */
	char *per_session;		/* per-session filename */
	const struct passwd *pwent;	/* user's passwd entry */
	int retval;			/* from calls */
	int start_agent;		/* start agent? */
	const char *tty_raw;		/* raw tty or display name */
	char *tty_nodir;		/* tty without / chars */
	int attempt;      /* No. of attempt to contact agent */
	const char *user;               /* username */
	struct options options;         /* PAM options */

#if HAVE_PAM_STRUCT_OPTIONS || !HAVE_PAM_STD_OPTION
	memset(&options, 0, sizeof options);
	pam_std_option(&options, other_options, argc, argv);
	if ((log_debug = pam_test_option(&options, PAM_OPT_DEBUG, NULL)))
		log_init(MODULE_NAME, SYSLOG_LEVEL_DEBUG3, SYSLOG_FACILITY_AUTHPRIV, 0);
	else
		log_init(MODULE_NAME, SYSLOG_LEVEL_ERROR, SYSLOG_FACILITY_AUTHPRIV, 0);
	pam_ssh_log(LOG_DEBUG, "open session");
#else
	log_init(MODULE_NAME, SYSLOG_LEVEL_ERROR, SYSLOG_FACILITY_AUTHPRIV, 0);
#endif

	if ((retval = pam_get_user(pamh, &user, NULL)) != PAM_SUCCESS) {
		pam_ssh_log(LOG_ERR, "can't get username (ret=%d)", retval);
		return retval;
	}

	if (!(user && (pwent = getpwnam(user)) && pwent->pw_dir && *pwent->pw_dir)) {
		pam_ssh_log(LOG_ERR, "can't get home directory");
		return PAM_SESSION_ERR;
	}

	retval = openpam_borrow_cred(pamh, pwent);
	if (retval != PAM_SUCCESS && retval != PAM_PERM_DENIED) {
		pam_ssh_log(LOG_ERR, "can't drop privileges: %m");
		return retval;
	}

	/*
	 * Use reference counts to limit agents to one per user per host.
	 *
	 * Technique: Create an environment file containing
	 * information about the agent.  Only one file is created, but
	 * it may be given many names.  One name is given for the
	 * agent itself, agent-<host>.  Another name is given for each
	 * session, agent-<host>-<display> or agent-<host>-<tty>.  We
	 * delete the per-session filename on session close, and when
	 * the link count goes to unity on the per-agent file, we
	 * delete the file and kill the agent.
	 */

	/* handle the per-user configuration directory and check its existence */

	if (asprintf(&dotdir, "%s/%s", pwent->pw_dir, SSH_DIR) == -1) {
		pam_ssh_log(LOG_CRIT, "out of memory");
		openpam_restore_cred(pamh);
		return PAM_SERVICE_ERR;
	}
	if ((access(dotdir,F_OK)) == -1) {
		pam_ssh_log(LOG_DEBUG, "inexistent configuration directory");
		free(dotdir);
		openpam_restore_cred(pamh);
		return PAM_SUCCESS;
	}

	/* the per-agent file contains just the hostname */

	gethostname(hname, sizeof hname);
	if ((asprintf(&per_agent, "%s/agent-%s", dotdir, hname)) == -1) {
		pam_ssh_log(LOG_CRIT, "out of memory");
		free(dotdir);
		openpam_restore_cred(pamh);
		return PAM_SERVICE_ERR;
	}

	/* save the per-agent filename in case we want to delete it on
           session close */

	if ((retval = pam_set_data(pamh, "ssh_agent_env_agent", per_agent, ssh_cleanup)) != PAM_SUCCESS) {
            pam_ssh_log(LOG_ERR, "can't save per-agent filename to PAM env");
            free(per_agent);
            free(dotdir);
	    openpam_restore_cred(pamh);
	    return retval;
	}

	/* Try to create the per-agent file or open it for reading if it
           exists.  If we can't do either, we won't try to link a
           per-session filename later.  Start the agent if we can't open
	   the file for reading. */

       for ( attempt = 0; attempt < 2; ++attempt ) {
               env_write = no_link = start_agent = 0;
               env_read = NULL;
               if ((env_write = open(per_agent, O_CREAT | O_EXCL | O_WRONLY, S_IRUSR)) < 0
                               && !(env_read = fopen(per_agent, "r")))
                       no_link = 1;
               if (!env_read) {
                       start_agent = 1;
                       if ((retval = start_ssh_agent(pamh, pwent->pw_uid, pwent->pw_gid, pwent->pw_name, &env_read)) != PAM_SUCCESS) {
			     close(env_write);
                             free(dotdir);
			     openpam_restore_cred(pamh);
			     return retval;
                       }
               }
               agent_socket = NULL;
               retval = read_write_agent_env(pamh, env_read, env_write, &agent_socket);
               close(env_write);
               if (retval != PAM_SUCCESS) {
			if (agent_socket)
				free(agent_socket);
			fclose(env_read);
			free(dotdir);
			openpam_restore_cred(pamh);
			return retval;
		}

               if (fclose(env_read) != 0) {
                        pam_ssh_log(LOG_ERR, "fclose: %m");
			if (agent_socket)
				free(agent_socket);
                        free(dotdir);
			openpam_restore_cred(pamh);
			return PAM_SESSION_ERR;
		}

                if (!agent_socket) {
                        free(dotdir);
			openpam_restore_cred(pamh);
			return PAM_SESSION_ERR;
		}

                ac = ssh_get_authentication_connection_authsocket(agent_socket);
                if (ac) {
                        free(agent_socket);
                        break;
                }
                pam_ssh_log(LOG_ERR, "%s: %m", agent_socket);
                free(agent_socket);
                if (start_agent)
                        break;
                unlink(per_agent);
	}

	if (!ac) {
		free(dotdir);
		return PAM_SESSION_ERR;
	}

	if (start_agent)
                retval = add_keys(pamh, ac);

        ssh_close_authentication_connection(ac);

        if (start_agent && retval != PAM_SUCCESS) {
                free(dotdir);
		openpam_restore_cred(pamh);
		return retval;
	}

	/* the per-session file contains the display name or tty name as
           well as the hostname */

	if ((retval = pam_get_item(pamh, PAM_TTY, (const void **)(void *)&tty_raw)) != PAM_SUCCESS) {
		pam_ssh_log(LOG_DEBUG, "could not start SSH agent");
		free(dotdir);
		openpam_restore_cred(pamh);
		return retval;
	}

        /* if there is no controlling tty, then use the process id */

        if (tty_raw == NULL) {
                pam_ssh_log(LOG_DEBUG, "no controlling tty");
                if (asprintf(&tty_nodir, "pid%ld", (long) getpid()) == -1) {
                        pam_ssh_log(LOG_CRIT, "out of memory");
                        free(dotdir);
                        openpam_restore_cred(pamh);
                        return PAM_SERVICE_ERR;
                }
	}
        /* else set tty_nodir to the tty with / replaced by _ */
        else {
                if (!(tty_nodir = strdup(tty_raw))) {
                        pam_ssh_log(LOG_CRIT, "out of memory");
                        free(dotdir);
                        openpam_restore_cred(pamh);
                        return PAM_SERVICE_ERR;
                }
                for (cp = tty_nodir; (cp = strchr(cp, '/')); )
                        *cp = '_';
        }

	if (asprintf(&per_session, "%s/agent-%s-%s", dotdir, hname, tty_nodir) == -1) {
		pam_ssh_log(LOG_CRIT, "out of memory");
		free(tty_nodir);
		free(dotdir);
		openpam_restore_cred(pamh);
		return PAM_SERVICE_ERR;
	}
	free(tty_nodir);
	free(dotdir);

	/* save the per-session filename so we can delete it on session close */

	if ((retval = pam_set_data(pamh, "ssh_agent_env_session", per_session, ssh_cleanup)) != PAM_SUCCESS) {
		free(per_session);
		openpam_restore_cred(pamh);
		return retval;
	}

	unlink(per_session);	/* remove cruft */
	link(per_agent, per_session);

	openpam_restore_cred(pamh);
	return PAM_SUCCESS;
}


PAM_EXTERN int
pam_sm_close_session(pam_handle_t *pamh, int flags __unused,
    int argc __unused, const char **argv __unused)
{
	const char *env_file;		/* ssh-agent environment */
	pid_t pid;			/* ssh-agent process id */
	int retval;			/* from calls */
	const char *ssh_agent_pid;	/* ssh-agent pid string */
	const struct passwd *pwent;	/* user's passwd entry */
	struct stat sb;			/* to check st_nlink */
	const char *user;               /* username */

	pam_ssh_log(LOG_DEBUG, "close session");

	if ((retval = pam_get_user(pamh, &user, NULL)) != PAM_SUCCESS) {
		pam_ssh_log(LOG_ERR, "can't get username (ret=%d)", retval);
		return retval;
	}

	if (!(user && (pwent = getpwnam(user)) && pwent->pw_dir && *pwent->pw_dir)) {
		pam_ssh_log(LOG_ERR, "can't get home directory");
		return PAM_SESSION_ERR;
	}

	retval = openpam_borrow_cred(pamh, pwent);
	if (retval != PAM_SUCCESS && retval != PAM_PERM_DENIED) {
		pam_ssh_log(LOG_ERR, "can't drop privileges: %m");
		return retval;
	}

	if (pam_get_data(pamh, "ssh_agent_env_session",
	    (const void **)(void *)&env_file) == PAM_SUCCESS && env_file)
		unlink(env_file);

	/* Retrieve per-agent filename and check link count.  If it's
           greater than unity, other sessions are still using this
           agent. */

	if (pam_get_data(pamh, "ssh_agent_env_agent",
	    (const void **)(void *)&env_file)
	    == PAM_SUCCESS && env_file) {
		retval = stat(env_file, &sb);
		if (retval == 0) {
			if (sb.st_nlink > 1) {
				openpam_restore_cred(pamh);
				return PAM_SUCCESS;
			}
			unlink(env_file);
		}
	}

	/* retrieve the agent's process id */

	if ((retval = pam_get_data(pamh, "ssh_agent_pid",
	    (const void **)(void *)&ssh_agent_pid)) != PAM_SUCCESS) {
		openpam_restore_cred(pamh);
		return retval;
	}

	/* Kill the agent.  SSH's ssh-agent does not have a -k option, so
           just call kill(). */

	pam_ssh_log(LOG_DEBUG, "kill ssh-agent (%s)", ssh_agent_pid);

	pid = atoi(ssh_agent_pid);
	if (pid <= 0) {
		openpam_restore_cred(pamh);
		return PAM_SESSION_ERR;
	}
	if (kill(pid, SIGTERM) != 0) {
		pam_ssh_log(LOG_ERR, "%s: %m", ssh_agent_pid);
		openpam_restore_cred(pamh);
		return PAM_SESSION_ERR;
	}

	openpam_restore_cred(pamh);
	return PAM_SUCCESS;
}


#if !HAVE_OPENPAM
PAM_EXTERN int
pam_sm_acct_mgmt(pam_handle_t *pamh __unused, int flags __unused,
    int argc __unused, const char **argv __unused)
{
	return PAM_IGNORE;
}


PAM_EXTERN int
pam_sm_chauthtok(pam_handle_t *pamh __unused, int flags __unused,
    int argc __unused, const char **argv __unused)
{
	return PAM_IGNORE;
}
#endif


#ifdef PAM_MODULE_ENTRY
PAM_MODULE_ENTRY(MODULE_NAME);
#else /* PAM_MODULE_ENTRY */
#ifdef PAM_STATIC
struct pam_module _modstruct = {
	MODULE_NAME,
	pam_sm_authenticate,
	pam_sm_acct_mgmt,
	pam_sm_chauthtok,
	pam_sm_open_session, pam_sm_close_session,
	NULL
};
#endif /* PAM_STATIC */
#endif /* PAM_MODULE_ENTRY */
