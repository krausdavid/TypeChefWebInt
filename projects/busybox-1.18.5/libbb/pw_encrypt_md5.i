static char *
NOINLINE
md5_crypt(char result[36], const unsigned char *pw, const unsigned char *salt)
{
 char *p;
 unsigned char final[17];
 int sl, pl, i, pw_len;
 md5_ctx_t ctx, ctx1;
 sl = 3;
 while (salt[sl] && salt[sl] != '$' && sl < (3 + 8))
  sl++;
 md5_begin(&ctx);
 pw_len = strlen((char*)pw);
 md5_hash(&ctx, pw, pw_len);
 md5_hash(&ctx, salt, sl);
 memcpy(result, salt, sl);
 result[sl] = '$';
 salt += 3;
 sl -= 3;
 md5_begin(&ctx1);
 md5_hash(&ctx1, pw, pw_len);
 md5_hash(&ctx1, salt, sl);
 md5_hash(&ctx1, pw, pw_len);
 md5_end(&ctx1, final);
 for (pl = pw_len; pl > 0; pl -= 16)
  md5_hash(&ctx, final, pl > 16 ? 16 : pl);
 memset(final, 0, sizeof(final));
 for (i = pw_len; i; i >>= 1) {
  md5_hash(&ctx, ((i & 1) ? final : (const unsigned char *) pw), 1);
 }
 md5_end(&ctx, final);
 for (i = 0; i < 1000; i++) {
  md5_begin(&ctx1);
  if (i & 1)
   md5_hash(&ctx1, pw, pw_len);
  else
   md5_hash(&ctx1, final, 16);
  if (i % 3)
   md5_hash(&ctx1, salt, sl);
  if (i % 7)
   md5_hash(&ctx1, pw, pw_len);
  if (i & 1)
   md5_hash(&ctx1, final, 16);
  else
   md5_hash(&ctx1, pw, pw_len);
  md5_end(&ctx1, final);
 }
 p = result + sl + 4;
 final[16] = final[5];
 for (i = 0; i < 5; i++) {
  unsigned l = (final[i] << 16) | (final[i+6] << 8) | final[i+12];
  p = to64(p, l, 4);
 }
 p = to64(p, final[11], 2);
 *p = '\0';
 memset(final, 0, sizeof(final));
 return result;
}
