static const uint8_t IP[64] = {
 58, 50, 42, 34, 26, 18, 10, 2, 60, 52, 44, 36, 28, 20, 12, 4,
 62, 54, 46, 38, 30, 22, 14, 6, 64, 56, 48, 40, 32, 24, 16, 8,
 57, 49, 41, 33, 25, 17, 9, 1, 59, 51, 43, 35, 27, 19, 11, 3,
 61, 53, 45, 37, 29, 21, 13, 5, 63, 55, 47, 39, 31, 23, 15, 7
};
static const uint8_t key_perm[56] = {
 57, 49, 41, 33, 25, 17, 9, 1, 58, 50, 42, 34, 26, 18,
 10, 2, 59, 51, 43, 35, 27, 19, 11, 3, 60, 52, 44, 36,
 63, 55, 47, 39, 31, 23, 15, 7, 62, 54, 46, 38, 30, 22,
 14, 6, 61, 53, 45, 37, 29, 21, 13, 5, 28, 20, 12, 4
};
static const uint8_t key_shifts[16] = {
 1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1
};
static const uint8_t comp_perm[48] = {
 14, 17, 11, 24, 1, 5, 3, 28, 15, 6, 21, 10,
 23, 19, 12, 4, 26, 8, 16, 7, 27, 20, 13, 2,
 41, 52, 31, 37, 47, 55, 30, 40, 51, 45, 33, 48,
 44, 49, 39, 56, 34, 53, 46, 42, 50, 36, 29, 32
};
static const uint8_t u_sbox[8][32] = {
 { 0x0e, 0xf4, 0x7d, 0x41, 0xe2, 0x2f, 0xdb, 0x18,
  0xa3, 0x6a, 0xc6, 0xbc, 0x95, 0x59, 0x30, 0x87,
  0xf4, 0xc1, 0x8e, 0x28, 0x4d, 0x96, 0x12, 0x7b,
  0x5f, 0xbc, 0x39, 0xe7, 0xa3, 0x0a, 0x65, 0xd0,
 },
 { 0x3f, 0xd1, 0x48, 0x7e, 0xf6, 0x2b, 0x83, 0xe4,
  0xc9, 0x07, 0x12, 0xad, 0x6c, 0x90, 0xb5, 0x5a,
  0xd0, 0x8e, 0xa7, 0x1b, 0x3a, 0xf4, 0x4d, 0x21,
  0xb5, 0x68, 0x7c, 0xc6, 0x09, 0x53, 0xe2, 0x9f,
 },
 { 0xda, 0x70, 0x09, 0x9e, 0x36, 0x43, 0x6f, 0xa5,
  0x21, 0x8d, 0x5c, 0xe7, 0xcb, 0xb4, 0xf2, 0x18,
  0x1d, 0xa6, 0xd4, 0x09, 0x68, 0x9f, 0x83, 0x70,
  0x4b, 0xf1, 0xe2, 0x3c, 0xb5, 0x5a, 0x2e, 0xc7,
 },
 { 0xd7, 0x8d, 0xbe, 0x53, 0x60, 0xf6, 0x09, 0x3a,
  0x41, 0x72, 0x28, 0xc5, 0x1b, 0xac, 0xe4, 0x9f,
  0x3a, 0xf6, 0x09, 0x60, 0xac, 0x1b, 0xd7, 0x8d,
  0x9f, 0x41, 0x53, 0xbe, 0xc5, 0x72, 0x28, 0xe4,
 },
 { 0xe2, 0xbc, 0x24, 0xc1, 0x47, 0x7a, 0xdb, 0x16,
  0x58, 0x05, 0xf3, 0xaf, 0x3d, 0x90, 0x8e, 0x69,
  0xb4, 0x82, 0xc1, 0x7b, 0x1a, 0xed, 0x27, 0xd8,
  0x6f, 0xf9, 0x0c, 0x95, 0xa6, 0x43, 0x50, 0x3e,
 },
 { 0xac, 0xf1, 0x4a, 0x2f, 0x79, 0xc2, 0x96, 0x58,
  0x60, 0x1d, 0xd3, 0xe4, 0x0e, 0xb7, 0x35, 0x8b,
  0x49, 0x3e, 0x2f, 0xc5, 0x92, 0x58, 0xfc, 0xa3,
  0xb7, 0xe0, 0x14, 0x7a, 0x61, 0x0d, 0x8b, 0xd6,
 },
 { 0xd4, 0x0b, 0xb2, 0x7e, 0x4f, 0x90, 0x18, 0xad,
  0xe3, 0x3c, 0x59, 0xc7, 0x25, 0xfa, 0x86, 0x61,
  0x61, 0xb4, 0xdb, 0x8d, 0x1c, 0x43, 0xa7, 0x7e,
  0x9a, 0x5f, 0x06, 0xf8, 0xe0, 0x25, 0x39, 0xc2,
 },
 { 0x1d, 0xf2, 0xd8, 0x84, 0xa6, 0x3f, 0x7b, 0x41,
  0xca, 0x59, 0x63, 0xbe, 0x05, 0xe0, 0x9c, 0x27,
  0x27, 0x1b, 0xe4, 0x71, 0x49, 0xac, 0x8e, 0xd2,
  0xf0, 0xc6, 0x9a, 0x0d, 0x3f, 0x53, 0x65, 0xb8,
 },
};
static const uint8_t pbox[32] = {
 16, 7, 20, 21, 29, 12, 28, 17, 1, 15, 23, 26, 5, 18, 31, 10,
  2, 8, 24, 14, 32, 27, 3, 9, 19, 13, 30, 6, 22, 11, 4, 25
};
static const uint32_t bits32[32] =
{
 0x80000000, 0x40000000, 0x20000000, 0x10000000,
 0x08000000, 0x04000000, 0x02000000, 0x01000000,
 0x00800000, 0x00400000, 0x00200000, 0x00100000,
 0x00080000, 0x00040000, 0x00020000, 0x00010000,
 0x00008000, 0x00004000, 0x00002000, 0x00001000,
 0x00000800, 0x00000400, 0x00000200, 0x00000100,
 0x00000080, 0x00000040, 0x00000020, 0x00000010,
 0x00000008, 0x00000004, 0x00000002, 0x00000001
};
static const uint8_t bits8[8] = { 0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01 };
static int
ascii_to_bin(char ch)
{
 if (ch > 'z')
  return 0;
 if (ch >= 'a')
  return (ch - 'a' + 38);
 if (ch > 'Z')
  return 0;
 if (ch >= 'A')
  return (ch - 'A' + 12);
 if (ch > '9')
  return 0;
 if (ch >= '.')
  return (ch - '.');
 return 0;
}
struct const_des_ctx {
 uint8_t final_perm[64];
 uint8_t m_sbox[4][4096];
};
static struct const_des_ctx*
const_des_init(void)
{
 unsigned i, j, b;
 struct const_des_ctx *cctx;
 cctx = xmalloc(sizeof(*cctx));
 for (b = 0; b < 4; b++)
  for (i = 0; i < 64; i++)
   for (j = 0; j < 64; j++) {
  uint8_t lo, hi;
  hi = u_sbox[(b << 1)][i / 2];
  if (!(i & 1))
   hi <<= 4;
  lo = u_sbox[(b << 1) + 1][j / 2];
  if (j & 1)
   lo >>= 4;
  ((*cctx).m_sbox )[b][(i << 6) | j] = (hi & 0xf0) | (lo & 0x0f);
 }
 for (i = 0; i < 64; i++) {
  ((*cctx).final_perm)[i] = IP[i] - 1;
 }
 return cctx;
}
struct des_ctx {
 const struct const_des_ctx *const_ctx;
 uint32_t saltbits;
 uint8_t un_pbox[32];
 uint8_t inv_comp_perm[56];
 uint8_t inv_key_perm[64];
 uint32_t en_keysl[16], en_keysr[16];
 uint32_t fp_maskl[8][256], fp_maskr[8][256];
 uint32_t key_perm_maskl[8][128], key_perm_maskr[8][128];
 uint32_t comp_maskl[8][128], comp_maskr[8][128];
 uint32_t psbox[4][256];
};
static struct des_ctx*
des_init(struct des_ctx *ctx, const struct const_des_ctx *cctx)
{
 int i, j, b, k, inbit, obit;
 uint32_t p;
 const uint32_t *bits28, *bits24;
 if (!ctx)
  ctx = xmalloc(sizeof(*ctx));
 ((*ctx).const_ctx ) = cctx;
 ((*ctx).saltbits ) = 0;
 bits28 = bits32 + 4;
 bits24 = bits28 + 4;
 for (i = 0; i < 64; i++) {
  ((*ctx).inv_key_perm )[i] = 255;
 }
 for (i = 0; i < 56; i++) {
  ((*ctx).inv_key_perm )[key_perm[i] - 1] = (uint8_t)i;
  ((*ctx).inv_comp_perm )[i] = 255;
 }
 for (i = 0; i < 48; i++) {
  ((*ctx).inv_comp_perm )[comp_perm[i] - 1] = (uint8_t)i;
 }
 for (k = 0; k < 8; k++) {
  uint32_t il, ir;
  uint32_t fl, fr;
  for (i = 0; i < 256; i++) {
   fl = 0;
   fr = 0;
   for (j = 0; j < 8; j++) {
    inbit = 8 * k + j;
    if (i & bits8[j]) {
     obit = ((*cctx).final_perm)[inbit];
     if (obit < 32)
      fl |= bits32[obit];
     else
      fr |= bits32[obit - 32];
    }
   }
   ((*ctx).fp_maskl )[k][i] = fl;
   ((*ctx).fp_maskr )[k][i] = fr;
  }
  for (i = 0; i < 128; i++) {
   il = 0;
   ir = 0;
   for (j = 0; j < 7; j++) {
    inbit = 8 * k + j;
    if (i & bits8[j + 1]) {
     obit = ((*ctx).inv_key_perm )[inbit];
     if (obit == 255)
      continue;
     if (obit < 28)
      il |= bits28[obit];
     else
      ir |= bits28[obit - 28];
    }
   }
   ((*ctx).key_perm_maskl )[k][i] = il;
   ((*ctx).key_perm_maskr )[k][i] = ir;
   il = 0;
   ir = 0;
   for (j = 0; j < 7; j++) {
    inbit = 7 * k + j;
    if (i & bits8[j + 1]) {
     obit = ((*ctx).inv_comp_perm )[inbit];
     if (obit == 255)
      continue;
     if (obit < 24)
      il |= bits24[obit];
     else
      ir |= bits24[obit - 24];
    }
   }
   ((*ctx).comp_maskl )[k][i] = il;
   ((*ctx).comp_maskr )[k][i] = ir;
  }
 }
 for (i = 0; i < 32; i++)
  ((*ctx).un_pbox )[pbox[i] - 1] = (uint8_t)i;
 for (b = 0; b < 4; b++) {
  for (i = 0; i < 256; i++) {
   p = 0;
   for (j = 0; j < 8; j++) {
    if (i & bits8[j])
     p |= bits32[((*ctx).un_pbox )[8 * b + j]];
   }
   ((*ctx).psbox )[b][i] = p;
  }
 }
 return ctx;
}
static void
setup_salt(struct des_ctx *ctx, uint32_t salt)
{
 uint32_t obit, saltbit;
 int i;
 ((*ctx).saltbits ) = 0;
 saltbit = 1;
 obit = 0x800000;
 for (i = 0; i < 24; i++) {
  if (salt & saltbit)
   ((*ctx).saltbits ) |= obit;
  saltbit <<= 1;
  obit >>= 1;
 }
}
static void
des_setkey(struct des_ctx *ctx, const char *key)
{
 uint32_t k0, k1, rawkey0, rawkey1;
 int shifts, round;
 rawkey0 = ntohl(*(const uint32_t *) key);
 rawkey1 = ntohl(*(const uint32_t *) (key + 4));
 k0 = ((*ctx).key_perm_maskl )[0][rawkey0 >> 25]
    | ((*ctx).key_perm_maskl )[1][(rawkey0 >> 17) & 0x7f]
    | ((*ctx).key_perm_maskl )[2][(rawkey0 >> 9) & 0x7f]
    | ((*ctx).key_perm_maskl )[3][(rawkey0 >> 1) & 0x7f]
    | ((*ctx).key_perm_maskl )[4][rawkey1 >> 25]
    | ((*ctx).key_perm_maskl )[5][(rawkey1 >> 17) & 0x7f]
    | ((*ctx).key_perm_maskl )[6][(rawkey1 >> 9) & 0x7f]
    | ((*ctx).key_perm_maskl )[7][(rawkey1 >> 1) & 0x7f];
 k1 = ((*ctx).key_perm_maskr )[0][rawkey0 >> 25]
    | ((*ctx).key_perm_maskr )[1][(rawkey0 >> 17) & 0x7f]
    | ((*ctx).key_perm_maskr )[2][(rawkey0 >> 9) & 0x7f]
    | ((*ctx).key_perm_maskr )[3][(rawkey0 >> 1) & 0x7f]
    | ((*ctx).key_perm_maskr )[4][rawkey1 >> 25]
    | ((*ctx).key_perm_maskr )[5][(rawkey1 >> 17) & 0x7f]
    | ((*ctx).key_perm_maskr )[6][(rawkey1 >> 9) & 0x7f]
    | ((*ctx).key_perm_maskr )[7][(rawkey1 >> 1) & 0x7f];
 shifts = 0;
 for (round = 0; round < 16; round++) {
  uint32_t t0, t1;
  shifts += key_shifts[round];
  t0 = (k0 << shifts) | (k0 >> (28 - shifts));
  t1 = (k1 << shifts) | (k1 >> (28 - shifts));
  ((*ctx).en_keysl )[round] = ((*ctx).comp_maskl )[0][(t0 >> 21) & 0x7f]
    | ((*ctx).comp_maskl )[1][(t0 >> 14) & 0x7f]
    | ((*ctx).comp_maskl )[2][(t0 >> 7) & 0x7f]
    | ((*ctx).comp_maskl )[3][t0 & 0x7f]
    | ((*ctx).comp_maskl )[4][(t1 >> 21) & 0x7f]
    | ((*ctx).comp_maskl )[5][(t1 >> 14) & 0x7f]
    | ((*ctx).comp_maskl )[6][(t1 >> 7) & 0x7f]
    | ((*ctx).comp_maskl )[7][t1 & 0x7f];
  ((*ctx).en_keysr )[round] = ((*ctx).comp_maskr )[0][(t0 >> 21) & 0x7f]
    | ((*ctx).comp_maskr )[1][(t0 >> 14) & 0x7f]
    | ((*ctx).comp_maskr )[2][(t0 >> 7) & 0x7f]
    | ((*ctx).comp_maskr )[3][t0 & 0x7f]
    | ((*ctx).comp_maskr )[4][(t1 >> 21) & 0x7f]
    | ((*ctx).comp_maskr )[5][(t1 >> 14) & 0x7f]
    | ((*ctx).comp_maskr )[6][(t1 >> 7) & 0x7f]
    | ((*ctx).comp_maskr )[7][t1 & 0x7f];
 }
}
static void
do_des(struct des_ctx *ctx, uint32_t *l_out, uint32_t *r_out, int count)
{
 const struct const_des_ctx *cctx = ((*ctx).const_ctx );
 uint32_t l, r, *kl, *kr;
 uint32_t f = f;
 uint32_t r48l, r48r;
 int round;
 l = r = 0;
 do {
  kl = ((*ctx).en_keysl );
  kr = ((*ctx).en_keysr );
  round = 16;
  do {
   r48l = ((r & 0x00000001) << 23)
    | ((r & 0xf8000000) >> 9)
    | ((r & 0x1f800000) >> 11)
    | ((r & 0x01f80000) >> 13)
    | ((r & 0x001f8000) >> 15);
   r48r = ((r & 0x0001f800) << 7)
    | ((r & 0x00001f80) << 5)
    | ((r & 0x000001f8) << 3)
    | ((r & 0x0000001f) << 1)
    | ((r & 0x80000000) >> 31);
   f = (r48l ^ r48r) & ((*ctx).saltbits );
   r48l ^= f ^ *kl++;
   r48r ^= f ^ *kr++;
   f = ((*ctx).psbox )[0][((*cctx).m_sbox )[0][r48l >> 12]]
     | ((*ctx).psbox )[1][((*cctx).m_sbox )[1][r48l & 0xfff]]
     | ((*ctx).psbox )[2][((*cctx).m_sbox )[2][r48r >> 12]]
     | ((*ctx).psbox )[3][((*cctx).m_sbox )[3][r48r & 0xfff]];
   f ^= l;
   l = r;
   r = f;
  } while (--round);
  r = l;
  l = f;
 } while (--count);
 *l_out = ((*ctx).fp_maskl )[0][l >> 24]
  | ((*ctx).fp_maskl )[1][(l >> 16) & 0xff]
  | ((*ctx).fp_maskl )[2][(l >> 8) & 0xff]
  | ((*ctx).fp_maskl )[3][l & 0xff]
  | ((*ctx).fp_maskl )[4][r >> 24]
  | ((*ctx).fp_maskl )[5][(r >> 16) & 0xff]
  | ((*ctx).fp_maskl )[6][(r >> 8) & 0xff]
  | ((*ctx).fp_maskl )[7][r & 0xff];
 *r_out = ((*ctx).fp_maskr )[0][l >> 24]
  | ((*ctx).fp_maskr )[1][(l >> 16) & 0xff]
  | ((*ctx).fp_maskr )[2][(l >> 8) & 0xff]
  | ((*ctx).fp_maskr )[3][l & 0xff]
  | ((*ctx).fp_maskr )[4][r >> 24]
  | ((*ctx).fp_maskr )[5][(r >> 16) & 0xff]
  | ((*ctx).fp_maskr )[6][(r >> 8) & 0xff]
  | ((*ctx).fp_maskr )[7][r & 0xff];
}
static void
to64_msb_first(char *s, unsigned v)
{
 *s++ = i64c(v >> 18);
 *s++ = i64c(v >> 12);
 *s++ = i64c(v >> 6);
 *s = i64c(v);
}
static char *
NOINLINE
des_crypt(struct des_ctx *ctx, char output[21],
  const unsigned char *key, const unsigned char *setting)
{
 uint32_t salt, r0, r1, keybuf[2];
 uint8_t *q;
 q = (uint8_t *)keybuf;
 while (q - (uint8_t *)keybuf != 8) {
  *q = *key << 1;
  if (*q)
   key++;
  q++;
 }
 des_setkey(ctx, (char *)keybuf);
 salt = (ascii_to_bin(setting[1]) << 6)
      | ascii_to_bin(setting[0]);
 output[0] = setting[0];
 output[1] = setting[1] ? setting[1] : output[0];
 setup_salt(ctx, salt);
 do_des(ctx, &r0, &r1, 25 );
 to64_msb_first(output + 2, (r0 >> 8));
 to64_msb_first(output + 6, (r0 << 16) | (r1 >> 16));
 to64_msb_first(output + 10, (r1 << 8));
 output[13] = '\0';
 return output;
}
