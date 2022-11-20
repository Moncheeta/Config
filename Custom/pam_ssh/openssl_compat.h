/* Compatibility header for OpenSSL versions 1.0 and below */

#ifndef OPENSSL_COMPAT_H
#define OPENSSL_COMPAT_H

/* evp.h compat */
#ifdef HEADER_ENVELOPE_H

#ifndef HAVE_EVP_CIPHER_CTX_IV
static inline const unsigned char *
EVP_CIPHER_CTX_iv(const EVP_CIPHER_CTX *ctx) { return ctx->iv; }
#endif

#ifndef HAVE_EVP_CIPHER_CTX_IV_NOCONST
static inline unsigned char *
EVP_CIPHER_CTX_iv_noconst(EVP_CIPHER_CTX *ctx) { return ctx->iv; }
#endif

#ifndef HAVE_EVP_CIPHER_IMPL_CTX_SIZE
static inline int
EVP_CIPHER_impl_ctx_size(const EVP_CIPHER *e) { return e->ctx_size; }
#endif

#ifndef HAVE_EVP_CIPHER_CTX_GET_CIPHER_DATA
static inline void *
EVP_CIPHER_CTX_get_cipher_data(const EVP_CIPHER_CTX *ctx) { return ctx->cipher_data; }
#endif

#endif /* HEADER_ENVELOPE_H */

/* rsa.h compat */
#ifdef HEADER_RSA_H

#ifndef HAVE_RSA_GET0_KEY
static inline void
RSA_get0_key(const RSA *r, const BIGNUM **n, const BIGNUM **e, const BIGNUM **d)
{
	if (n)
		*n = r->n;
	if (e)
		*e = r->e;
	if (d)
		*d = r->d;
}
#endif

#ifndef HAVE_RSA_SET0_KEY
static inline int
RSA_set0_key(RSA *r, BIGNUM *n, BIGNUM *e, BIGNUM *d)
{
	if (n) {
		BN_free(r->n);
		r->n = n;
	}
	if (e) {
		BN_free(r->e);
		r->e = e;
	}
	if (d) {
		BN_free(r->d);
		r->d = d;
	}
	return 1;
}
#endif

#ifndef HAVE_RSA_GET0_FACTORS
static inline void
RSA_get0_factors(const RSA *r, const BIGNUM **p, const BIGNUM **q)
{
	if (p)
		*p = r->p;
	if (q)
		*q = r->q;
}
#endif

#ifndef HAVE_RSA_SET0_FACTORS
static inline int
RSA_set0_factors(RSA *r, BIGNUM *p, BIGNUM *q)
{
	if (p) {
		BN_free(r->p);
		r->p = p;
	}
	if (q) {
		BN_free(r->q);
		r->q = q;
	}
	return 1;
}
#endif

#ifndef HAVE_RSA_GET0_CRT_PARAMS
static inline void
RSA_get0_crt_params(const RSA *r, const BIGNUM **dmp1,
		    const BIGNUM **dmq1, const BIGNUM **iqmp)
{
	if (dmp1)
		*dmp1 = r->dmp1;
	if (dmq1)
		*dmq1 = r->dmq1;
	if (iqmp)
		*iqmp = r->iqmp;
}
#endif

#ifndef HAVE_RSA_SET0_CRT_PARAMS
static inline int
RSA_set0_crt_params(RSA *r, BIGNUM *dmp1, BIGNUM *dmq1, BIGNUM *iqmp)
{
	if (dmp1) {
		BN_free(r->dmp1);
		r->dmp1 = dmp1;
	}
	if (dmq1) {
		BN_free(r->dmq1);
		r->dmq1 = dmq1;
	}
	if (iqmp) {
		BN_free(r->iqmp);
		r->iqmp = iqmp;
	}
	return 1;
}
#endif

#endif /* HEADER_RSA_H */

/* ecdsa.h compat */
#ifdef HEADER_ECDSA_H

#ifndef HAVE_ECDSA_SIG_SET0
static inline int
ECDSA_SIG_set0(ECDSA_SIG *sig, BIGNUM *r, BIGNUM *s)
{
	BN_clear_free(sig->r);
	BN_clear_free(sig->s);
	sig->r = r;
	sig->s = s;
	return 1;
}
#endif

#endif /* HEADER_ECDSA_H */

/* dsa.h compat */
#ifdef HEADER_DSA_H

#ifndef HAVE_DSA_SIG_SET0
static inline int
DSA_SIG_set0(DSA_SIG *sig, BIGNUM *r, BIGNUM *s)
{
	BN_clear_free(sig->r);
	BN_clear_free(sig->s);
	sig->r = r;
	sig->s = s;
	return 1;
}
#endif

#ifndef HAVE_DSA_GET0_PQG
static inline void
DSA_get0_pqg(const DSA *d, const BIGNUM **p, const BIGNUM **q, const BIGNUM **g)
{
	if (p)
		*p = d->p;
	if (q)
		*q = d->q;
	if (g)
		*g = d->g;
}
#endif

#ifndef HAVE_DSA_SET0_PQG
static inline int
DSA_set0_pqg(DSA *d, BIGNUM *p, BIGNUM *q, BIGNUM *g)
{
	if (p) {
		BN_free(d->p);
		d->p = p;
	}
	if (q) {
		BN_free(d->q);
		d->q = q;
	}
	if (g) {
		BN_free(d->g);
		d->g = g;
	}
	return 1;
}
#endif

#ifndef HAVE_DSA_GET0_KEY
static inline void
DSA_get0_key(const DSA *d, const BIGNUM **pub_key, const BIGNUM **priv_key)
{
	if (pub_key)
		*pub_key = d->pub_key;
	if (priv_key)
		*priv_key = d->priv_key;
}
#endif

#ifndef HAVE_DSA_SET0_KEY
static inline int
DSA_set0_key(DSA *d, BIGNUM *pub_key, BIGNUM *priv_key)
{
	if (pub_key) {
		BN_free(d->pub_key);
		d->pub_key = pub_key;
	}
	if (priv_key) {
		BN_free(d->priv_key);
		d->priv_key = priv_key;
	}
	return 1;
}
#endif

#endif /* HEADER_DSA_H */

#endif /* OPENSSL_COMPAT_H */
