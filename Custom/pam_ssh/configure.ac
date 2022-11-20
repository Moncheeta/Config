dnl Copyright (c) 2002, 2004, 2007 Andrew J. Korty
dnl           (c) 2006-2015 Wolfgang Rosenauer
dnl All rights reserved.
dnl 
dnl Redistribution and use in source and binary forms, with or without
dnl modification, are permitted provided that the following conditions
dnl are met:
dnl 1. Redistributions of source code must retain the above copyright
dnl    notice, this list of conditions and the following disclaimer.
dnl 2. Redistributions in binary form must reproduce the above copyright
dnl    notice, this list of conditions and the following disclaimer in the
dnl    documentation and/or other materials provided with the distribution.
dnl 
dnl THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
dnl ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
dnl IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
dnl ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
dnl FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
dnl DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
dnl OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
dnl HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
dnl LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
dnl OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
dnl SUCH DAMAGE.
dnl

dnl Process this file with autoconf to produce a configure script.

AC_INIT([pam_ssh],[2.3],[ajk@ajk.name])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_SRCDIR([pam_ssh.c])
AC_CANONICAL_TARGET([])
AM_DISABLE_STATIC
AM_INIT_AUTOMAKE(pam_ssh, 2.3)
AM_PROG_LIBTOOL
AC_SUBST(LIBTOOL_DEPS)

dnl Checks for programs.

AC_PATH_PROG(PATH_SSH_AGENT, ssh-agent, no)
if test x"$PATH_SSH_AGENT" = xno; then
  AC_MSG_ERROR([Could not find ssh-agent, please install or check config.log])
fi
AC_DEFINE_UNQUOTED([PATH_SSH_AGENT], ["$PATH_SSH_AGENT"], [Path to ssh-agent])

dnl Checks for libraries.

AC_ARG_WITH(ssh-agent-group,
	[  --with-ssh-agent-group=GROUP  Specify SGID group of ssh-agent ],
	[
	        if test "x$withval" != "xno" ; then
			AC_DEFINE_UNQUOTED([SSH_AGENT_GROUP_NAME], [ "$withval" ], [ ])
		fi
	]
)

# The big search for OpenSSL (stolen from OpenSSH 3.1's configure.ac)
AC_ARG_WITH(ssl-dir,
	[  --with-ssl-dir=PATH           Specify path to OpenSSL installation ],
	[
		if test "x$withval" != "xno" ; then
			tryssldir=$withval
		fi
	]
)

saved_LIBS="$LIBS"
saved_LDFLAGS="$LDFLAGS"
saved_CPPFLAGS="$CPPFLAGS"
if test "x$prefix" != "xNONE" ; then
	tryssldir="$tryssldir $prefix"
fi
AC_CACHE_CHECK([for OpenSSL directory], ac_cv_openssldir, [
	for ssldir in $tryssldir "" /usr/local/openssl /usr/lib/openssl /usr/local/ssl /usr/lib/ssl /usr/local /usr/pkg /opt /opt/openssl ; do
		CPPFLAGS="$saved_CPPFLAGS"
		LDFLAGS="$saved_LDFLAGS"
		LIBS="$saved_LIBS -lcrypto"

		# Skip directories if they don't exist
		if test ! -z "$ssldir" -a ! -d "$ssldir" ; then
			continue;
		fi
		if test ! -z "$ssldir" -a "x$ssldir" != "x/usr"; then
			# Try to use $ssldir/lib if it exists, otherwise
			# $ssldir
			if test -d "$ssldir/lib" ; then
				LDFLAGS="-L$ssldir/lib $saved_LDFLAGS"
				if test ! -z "$need_dash_r" ; then
					LDFLAGS="-R$ssldir/lib $LDFLAGS"
				fi
			else
				LDFLAGS="-L$ssldir $saved_LDFLAGS"
				if test ! -z "$need_dash_r" ; then
					LDFLAGS="-R$ssldir $LDFLAGS"
				fi
			fi
			# Try to use $ssldir/include if it exists, otherwise
			# $ssldir
			if test -d "$ssldir/include" ; then
				CPPFLAGS="-I$ssldir/include $saved_CPPFLAGS"
			else
				CPPFLAGS="-I$ssldir $saved_CPPFLAGS"
			fi
		fi

		# Basic test to check for compatible version and correct linking
		# *does not* test for RSA - that comes later.
		AC_RUN_IFELSE([AC_LANG_SOURCE([[
#include <string.h>
#include <openssl/rand.h>
int main(void)
{
	char a[2048];
	memset(a, 0, sizeof(a));
	RAND_add(a, sizeof(a), sizeof(a));
	return(RAND_status() <= 0);
}
			]])],[
				found_crypto=1
				break;
			],[
		],[])

		if test ! -z "$found_crypto" ; then
			break;
		fi
	done

	if test -z "$found_crypto" ; then
		AC_MSG_ERROR([Could not find working OpenSSL library, please install or check config.log])
	fi
	if test -z "$ssldir" ; then
		ssldir="(system)"
	fi

	ac_cv_openssldir=$ssldir
])

if (test ! -z "$ac_cv_openssldir" && test "x$ac_cv_openssldir" != "x(system)") ; then
	AC_DEFINE(HAVE_OPENSSL, [], [Define if we have OpenSSL])
	dnl Need to recover ssldir - test above runs in subshell
	ssldir=$ac_cv_openssldir
	if test ! -z "$ssldir" -a "x$ssldir" != "x/usr"; then
		# Try to use $ssldir/lib if it exists, otherwise 
		# $ssldir
		if test -d "$ssldir/lib" ; then
			LDFLAGS="-L$ssldir/lib $saved_LDFLAGS"
			if test ! -z "$need_dash_r" ; then
				LDFLAGS="-R$ssldir/lib $LDFLAGS"
			fi
		else
			LDFLAGS="-L$ssldir $saved_LDFLAGS"
			if test ! -z "$need_dash_r" ; then
				LDFLAGS="-R$ssldir $LDFLAGS"
			fi
		fi
		# Try to use $ssldir/include if it exists, otherwise 
		# $ssldir
		if test -d "$ssldir/include" ; then
			CPPFLAGS="-I$ssldir/include $saved_CPPFLAGS"
		else
			CPPFLAGS="-I$ssldir $saved_CPPFLAGS"
		fi
	fi
fi
LIBS="$saved_LIBS -lcrypto"

# Now test RSA support
saved_LIBS="$LIBS"
AC_MSG_CHECKING([for RSA support])
for WANTS_RSAREF in "" 1 ; do
	if test -z "$WANTS_RSAREF" ; then
		LIBS="$saved_LIBS"
	else
		LIBS="$saved_LIBS -lRSAglue -lrsaref"
	fi
	AC_RUN_IFELSE([AC_LANG_SOURCE([[
#include <string.h>
#include <openssl/rand.h>
#include <openssl/rsa.h>
#include <openssl/bn.h>
#include <openssl/sha.h>
int main(void) 
{
	int num; RSA *key; static unsigned char p_in[] = "blahblah";
	unsigned char c[256], p[256];
	memset(c, 0, sizeof(c)); RAND_add(c, sizeof(c), sizeof(c));
	if ((key=RSA_generate_key(512, 3, NULL, NULL))==NULL) return(1);
	num = RSA_public_encrypt(sizeof(p_in) - 1, p_in, c, key, RSA_PKCS1_PADDING);
	return(-1 == RSA_private_decrypt(num, c, p, key, RSA_PKCS1_PADDING));
}
	]])],[
		rsa_works=1
		break;
	],[],[])
done
LIBS="$saved_LIBS"

if test ! -z "$no_rsa" ; then
	AC_MSG_RESULT(disabled)
	RSA_MSG="disabled"
else
	if test -z "$rsa_works" ; then
		AC_MSG_WARN([*** No RSA support found *** ])
		RSA_MSG="no"
	else
		if test -z "$WANTS_RSAREF" ; then
			AC_MSG_RESULT(yes)
			RSA_MSG="yes"
		else
			RSA_MSG="yes (using RSAref)"
			AC_MSG_RESULT(using RSAref)
			LIBS="$LIBS -lcrypto -lRSAglue -lrsaref"
		fi
	fi
fi


# Imported from OpenSSH 6.7p1's configure.ac
## XXX make --without-openssl work
AC_DEFINE_UNQUOTED([WITH_OPENSSL], [1], [use libcrypto for cryptography])

# Extra OpenSSL stuff (stolen from OpenSSH 6.0p1's configure.ac)
## Sanity check OpenSSL headers
AC_MSG_CHECKING([whether OpenSSL's headers match the library])
AC_RUN_IFELSE([AC_LANG_SOURCE([[
#include <string.h>
#include <openssl/opensslv.h>
#include <openssl/crypto.h>
int main(void) { return(SSLeay() == OPENSSL_VERSION_NUMBER ? 0 : 1); }
	]])],[
		AC_MSG_RESULT(yes)
	],[
		AC_MSG_RESULT(no)
		AC_MSG_ERROR(Your OpenSSL headers do not match your library)
	
],[])

# Check for OpenSSL with EVP_aes_*ctr
AC_MSG_CHECKING([whether OpenSSL has AES CTR via EVP])
AC_LINK_IFELSE(
	[AC_LANG_PROGRAM([[
#include <string.h>
#include <openssl/evp.h>
	]], [[
	exit(EVP_aes_128_ctr() == NULL ||
	    EVP_aes_192_cbc() == NULL ||
	    EVP_aes_256_cbc() == NULL);
	]])],
	[
		AC_MSG_RESULT([yes])
		AC_DEFINE([OPENSSL_HAVE_EVPCTR], [1],
		    [libcrypto has EVP AES CTR])
	],
	[
		AC_MSG_RESULT([no])
	]
)

# Imported from OpenSSH 6.7p1's configure.ac
## Check for OpenSSL with EVP_aes_*gcm
AC_MSG_CHECKING([whether OpenSSL has AES GCM via EVP])
AC_LINK_IFELSE(
	[AC_LANG_PROGRAM([[
#include <string.h>
#include <openssl/evp.h>
	]], [[
	exit(EVP_aes_128_gcm() == NULL ||
	    EVP_aes_256_gcm() == NULL ||
	    EVP_CTRL_GCM_SET_IV_FIXED == 0 ||
	    EVP_CTRL_GCM_IV_GEN == 0 ||
	    EVP_CTRL_GCM_SET_TAG == 0 ||
	    EVP_CTRL_GCM_GET_TAG == 0 ||
	    EVP_CIPHER_CTX_ctrl(NULL, 0, 0, NULL) == 0);
	]])],
	[
		AC_MSG_RESULT([yes])
		AC_DEFINE([OPENSSL_HAVE_EVPGCM], [1],
		    [libcrypto has EVP AES GCM])
	],
	[
		AC_MSG_RESULT([no])
		unsupported_algorithms="$unsupported_cipers \
		   aes128-gcm@openssh.com aes256-gcm@openssh.com"
	]
)

# Imported from OpenSSH 6.7p1's configure.ac
## Check complete ECC support in OpenSSL
AC_MSG_CHECKING([whether OpenSSL has NID_X9_62_prime256v1])
AC_LINK_IFELSE(
	[AC_LANG_PROGRAM([[
#include <openssl/ec.h>
#include <openssl/ecdh.h>
#include <openssl/ecdsa.h>
#include <openssl/evp.h>
#include <openssl/objects.h>
#include <openssl/opensslv.h>
#if OPENSSL_VERSION_NUMBER < 0x0090807f /* 0.9.8g */
# error "OpenSSL < 0.9.8g has unreliable ECC code"
#endif
	]], [[
	EC_KEY *e = EC_KEY_new_by_curve_name(NID_X9_62_prime256v1);
	const EVP_MD *m = EVP_sha256(); /* We need this too */
	]])],
	[ AC_MSG_RESULT([yes])
	  enable_nistp256=1 ],
	[ AC_MSG_RESULT([no]) ]
)

AC_MSG_CHECKING([whether OpenSSL has NID_secp384r1])
AC_LINK_IFELSE(
	[AC_LANG_PROGRAM([[
#include <openssl/ec.h>
#include <openssl/ecdh.h>
#include <openssl/ecdsa.h>
#include <openssl/evp.h>
#include <openssl/objects.h>
#include <openssl/opensslv.h>
#if OPENSSL_VERSION_NUMBER < 0x0090807f /* 0.9.8g */
# error "OpenSSL < 0.9.8g has unreliable ECC code"
#endif
	]], [[
	EC_KEY *e = EC_KEY_new_by_curve_name(NID_secp384r1);
	const EVP_MD *m = EVP_sha384(); /* We need this too */
	]])],
	[ AC_MSG_RESULT([yes])
	  enable_nistp384=1 ],
	[ AC_MSG_RESULT([no]) ]
)

AC_MSG_CHECKING([whether OpenSSL has NID_secp521r1])
AC_LINK_IFELSE(
	[AC_LANG_PROGRAM([[
#include <openssl/ec.h>
#include <openssl/ecdh.h>
#include <openssl/ecdsa.h>
#include <openssl/evp.h>
#include <openssl/objects.h>
#include <openssl/opensslv.h>
#if OPENSSL_VERSION_NUMBER < 0x0090807f /* 0.9.8g */
# error "OpenSSL < 0.9.8g has unreliable ECC code"
#endif
	]], [[
	EC_KEY *e = EC_KEY_new_by_curve_name(NID_secp521r1);
	const EVP_MD *m = EVP_sha512(); /* We need this too */
	]])],
	[ AC_MSG_RESULT([yes])
	  AC_MSG_CHECKING([if OpenSSL's NID_secp521r1 is functional])
	  AC_RUN_IFELSE(
		[AC_LANG_PROGRAM([[
#include <openssl/ec.h>
#include <openssl/ecdh.h>
#include <openssl/ecdsa.h>
#include <openssl/evp.h>
#include <openssl/objects.h>
#include <openssl/opensslv.h>
		]],[[
		EC_KEY *e = EC_KEY_new_by_curve_name(NID_secp521r1);
		const EVP_MD *m = EVP_sha512(); /* We need this too */
		exit(e == NULL || m == NULL);
		]])],
		[ AC_MSG_RESULT([yes])
		  enable_nistp521=1 ],
		[ AC_MSG_RESULT([no]) ],
		[ AC_MSG_WARN([cross-compiling: assuming yes])
		  enable_nistp521=1 ]
	  )],
	AC_MSG_RESULT([no])
)

COMMENT_OUT_ECC="#no ecc#"
TEST_SSH_ECC=no

if test x$enable_nistp256 = x1 || test x$enable_nistp384 = x1 || \
    test x$enable_nistp521 = x1; then
	AC_DEFINE(OPENSSL_HAS_ECC, [1], [OpenSSL has ECC])
fi
if test x$enable_nistp256 = x1; then
	AC_DEFINE([OPENSSL_HAS_NISTP256], [1],
	    [libcrypto has NID_X9_62_prime256v1])
	TEST_SSH_ECC=yes
	COMMENT_OUT_ECC=""
else
	unsupported_algorithms="$unsupported_algorithms ecdsa-sha2-nistp256 \
	    ecdh-sha2-nistp256 ecdsa-sha2-nistp256-cert-v01@openssh.com"
fi
if test x$enable_nistp384 = x1; then
	AC_DEFINE([OPENSSL_HAS_NISTP384], [1], [libcrypto has NID_secp384r1])
	TEST_SSH_ECC=yes
	COMMENT_OUT_ECC=""
else
	unsupported_algorithms="$unsupported_algorithms ecdsa-sha2-nistp384 \
	    ecdh-sha2-nistp384 ecdsa-sha2-nistp384-cert-v01@openssh.com"
fi
if test x$enable_nistp521 = x1; then
	AC_DEFINE([OPENSSL_HAS_NISTP521], [1], [libcrypto has NID_secp521r1])
	TEST_SSH_ECC=yes
	COMMENT_OUT_ECC=""
else
	unsupported_algorithms="$unsupported_algorithms ecdh-sha2-nistp521 \
	    ecdsa-sha2-nistp521 ecdsa-sha2-nistp521-cert-v01@openssh.com"
fi

AC_SUBST([TEST_SSH_ECC])
AC_SUBST([COMMENT_OUT_ECC])

# check for OpenSSL 1.1x API functions
AC_CHECK_FUNCS([ \
	EVP_CIPHER_CTX_iv \
	EVP_CIPHER_CTX_iv_noconst \
	EVP_CIPHER_impl_ctx_size \
	EVP_CIPHER_CTX_get_cipher_data \
	RSA_get0_key \
	RSA_set0_key \
	RSA_get0_factors \
	RSA_set0_factors \
	RSA_get0_crt_params \
	RSA_set0_crt_params \
	ECDSA_SIG_set0 \
	DSA_SIG_set0 \
	DSA_get0_pqg \
	DSA_set0_pqg \
	DSA_get0_key \
	DSA_set0_key \
])


saved_LIBS="$LIBS"
AC_CHECK_LIB([iaf], [ia_openinfo], [
	LIBS="$LIBS -liaf"
	AC_CHECK_FUNCS([set_id], [SSHDLIBS="$SSHDLIBS -liaf"
				AC_DEFINE([HAVE_LIBIAF], [1],
        		[Define if system has libiaf that supports set_id])
				])
])
LIBS="$saved_LIBS"


dnl Checks for header files.

AC_HEADER_STDC
AC_HEADER_SYS_WAIT
AC_CHECK_HEADERS([ \
	stdlib.h \
	string.h \
	poll.h \
	sys/poll.h \
	])

dnl Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST
AC_TYPE_OFF_T
AC_TYPE_PID_T
AC_TYPE_SIZE_T
AC_TYPE_UID_T

dnl Checks for library functions.
AC_CHECK_FUNCS([memmove memset])
AC_CHECK_FUNCS([explicit_bzero memset_s])
AC_CHECK_FUNCS([b64_ntop __b64_ntop b64_pton __b64_pton])
AC_CHECK_FUNCS([timingsafe_bcmp])
AC_CHECK_FUNCS([bcrypt_pbkdf])
AC_REPLACE_FUNCS([strlcpy strnvis])
AC_CHECK_PAM

AC_CONFIG_FILES([Makefile])
AC_SUBST(LTLIBOBJS)
AC_OUTPUT
