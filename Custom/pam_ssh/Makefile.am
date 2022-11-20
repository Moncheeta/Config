# Copyright (c) 2002, 2004 Andrew J. Korty
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
# $Id: Makefile.am,v 1.19 2008/05/12 18:57:12 rosenauer Exp $

lib_LTLIBRARIES			= pam_ssh.la
pam_ssh_la_LDFLAGS		= -avoid-version -module
pam_ssh_la_LIBADD		= @LTLIBOBJS@
pam_ssh_la_SOURCES = \
	atomicio.c atomicio.h authfd.c authfd.h \
	authfile.c authfile.h \
	base64.c base64.h \
	bcrypt_pbkdf.c blf.h \
	blocks.c blowfish.c bufaux.c \
	bufec.c bufbn.c buffer.c buffer.h \
	chacha.c chacha.h \
	cipher-aesctr.h \
	cipher-chachapoly.c cipher-chachapoly.h cipher-ctr.c \
	cipher.c cipher.h	\
	cleanup.c crypto_api.h \
	digest.h digest-openssl.c \
	ed25519.c explicit_bzero.c \
	fatal.c fe25519.c fe25519.h ge25519_base.data ge25519.c ge25519.h \
	hash.c kex.h key.c key.h log.c log.h \
	misc.c misc.h \
	poly1305.c poly1305.h \
	rijndael.c rijndael.h rsa.c rsa.h \
	verify.c sc25519.c sc25519.h \
	timingsafe_bcmp.c \
	sshbuf-getput-crypto.c sshbuf-getput-basic.c sshbuf.c sshbuf-misc.c sshbuf.h \
	ssh-ed25519.c ssh-ecdsa.c ssh-dss.c ssh-rsa.c sshkey.c sshkey.h \
	ssherr.c ssherr.h \
	pam_ssh.c xmalloc.c \
	pam_ssh_log.c pam_ssh_log.h xmalloc.h \
	ssh2.h ssh.h defines.h includes.h openssl_compat.h
libdir				= @PAMDIR@
man_MANS			= pam_ssh.8
AM_CFLAGS			= -Wall
AUTOMAKE_OPTIONS		= dist-bzip2 dist-xz
EXTRA_pam_ssh_la_SOURCES	= openpam_cred.h pam_opttab.h pam_option.h \
				  pam_get_pass.h strlcpy.h strnvis.h
EXTRA_DIST			= $(man_MANS) bootstrap.sh pam_ssh.spec pam.conf.example \
				  pam_test.c
LIBTOOL_DEPS			= @LIBTOOL_DEPS@

libtool: $(LIBTOOL_DEPS)
	$(SHELL) ./config.status --recheck
