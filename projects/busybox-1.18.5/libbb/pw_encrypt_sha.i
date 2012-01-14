




static const char str_rounds[] ALIGN1 = "rounds=%u$";
static char *
NOINLINE
sha_crypt( char *key_data, char *salt_data)
{
 void (*sha_begin)(void *ctx) FAST_FUNC;
 void (*sha_hash)(void *ctx, const void *buffer, size_t len) FAST_FUNC;
 void (*sha_end)(void *ctx, void *resbuf) FAST_FUNC;
 int _32or64;
 char *result, *resptr;
 struct {
  unsigned char alt_result[64];
  unsigned char temp_result[64];
  union {
   sha256_ctx_t x;
   sha512_ctx_t y;
  } ctx;
  union {
   sha256_ctx_t x;
   sha512_ctx_t y;
  } alt_ctx;
 } L __attribute__((__aligned__(__alignof__(uint64_t))));
 unsigned salt_len;
 unsigned key_len;
 unsigned cnt;
 unsigned rounds;
 char *cp;
 char is_sha512;
 cnt = strlen(salt_data) + 1 + 43 + 1;
 is_sha512 = salt_data[1];
 if (is_sha512 == '6')
  cnt += 43;
 result = resptr = xzalloc(cnt);
 *resptr++ = '$';
 *resptr++ = is_sha512;
 *resptr++ = '$';
 rounds = 5000;
 salt_data += 3;
 if (strncmp(salt_data, str_rounds, 7) == 0) {
  char *endp;
  cnt = bb_strtou(salt_data + 7, &endp, 10);
  if (*endp == '$') {
   salt_data = endp + 1;
   rounds = cnt;
   if (rounds < 1000)
    rounds = 1000;
   if (rounds > 999999999)
    rounds = 999999999;
   resptr += sprintf(resptr, str_rounds, rounds);
  }
 }
 salt_len = strchrnul(salt_data, '$') - salt_data;
 if (salt_len > 16)
  salt_len = 16;
 salt_data = xstrndup(salt_data, salt_len);
 strcpy(resptr, salt_data);
 resptr += salt_len;
 *resptr++ = '$';
 key_len = strlen(key_data);
 key_data = xstrdup(key_data);
 sha_begin = (void*)sha256_begin;
 sha_hash = (void*)sha256_hash;
 sha_end = (void*)sha256_end;
 _32or64 = 32;
 if (is_sha512 == '6') {
  sha_begin = (void*)sha512_begin;
  sha_hash = (void*)sha512_hash;
  sha_end = (void*)sha512_end;
  _32or64 = 64;
 }
 sha_begin(&(L.ctx ));
 sha_hash(&(L.ctx ), key_data, key_len);
 sha_hash(&(L.ctx ), salt_data, salt_len);
 sha_begin(&(L.alt_ctx ));
 sha_hash(&(L.alt_ctx ), key_data, key_len);
 sha_hash(&(L.alt_ctx ), salt_data, salt_len);
 sha_hash(&(L.alt_ctx ), key_data, key_len);
 sha_end(&(L.alt_ctx ), (L.alt_result ));
 for (cnt = key_len; cnt > _32or64; cnt -= _32or64)
  sha_hash(&(L.ctx ), (L.alt_result ), _32or64);
 sha_hash(&(L.ctx ), (L.alt_result ), cnt);
 for (cnt = key_len; cnt != 0; cnt >>= 1)
  if ((cnt & 1) != 0)
   sha_hash(&(L.ctx ), (L.alt_result ), _32or64);
  else
   sha_hash(&(L.ctx ), key_data, key_len);
 sha_end(&(L.ctx ), (L.alt_result ));
 sha_begin(&(L.alt_ctx ));
 for (cnt = 0; cnt < key_len; ++cnt)
  sha_hash(&(L.alt_ctx ), key_data, key_len);
 sha_end(&(L.alt_ctx ), (L.temp_result));
 cp = key_data;
 for (cnt = key_len; cnt >= _32or64; cnt -= _32or64) {
  cp = memcpy(cp, (L.temp_result), _32or64);
  cp += _32or64;
 }
 memcpy(cp, (L.temp_result), cnt);
 sha_begin(&(L.alt_ctx ));
 for (cnt = 0; cnt < 16 + (L.alt_result )[0]; ++cnt)
  sha_hash(&(L.alt_ctx ), salt_data, salt_len);
 sha_end(&(L.alt_ctx ), (L.temp_result));
 cp = salt_data;
 for (cnt = salt_len; cnt >= _32or64; cnt -= _32or64) {
  cp = memcpy(cp, (L.temp_result), _32or64);
  cp += _32or64;
 }
 memcpy(cp, (L.temp_result), cnt);
 for (cnt = 0; cnt < rounds; ++cnt) {
  sha_begin(&(L.ctx ));
  if ((cnt & 1) != 0)
   sha_hash(&(L.ctx ), key_data, key_len);
  else
   sha_hash(&(L.ctx ), (L.alt_result ), _32or64);
  if (cnt % 3 != 0)
   sha_hash(&(L.ctx ), salt_data, salt_len);
  if (cnt % 7 != 0)
   sha_hash(&(L.ctx ), key_data, key_len);
  if ((cnt & 1) != 0)
   sha_hash(&(L.ctx ), (L.alt_result ), _32or64);
  else
   sha_hash(&(L.ctx ), key_data, key_len);
  sha_end(&(L.ctx ), (L.alt_result ));
 }
 if (is_sha512 == '5') {
  unsigned i = 0;
  while (1) {
   unsigned j = i + 10;
   unsigned k = i + 20;
   if (j >= 30) j -= 30;
   if (k >= 30) k -= 30;
   do { unsigned w = (((L.alt_result )[i]) << 16) | (((L.alt_result )[j]) << 8) | ((L.alt_result )[k]); resptr = to64(resptr, w, 4); } while (0);
   if (k == 29)
    break;
   i = k + 1;
  }
  do { unsigned w = ((0) << 16) | (((L.alt_result )[31]) << 8) | ((L.alt_result )[30]); resptr = to64(resptr, w, 3); } while (0);
 } else {
  unsigned i = 0;
  while (1) {
   unsigned j = i + 21;
   unsigned k = i + 42;
   if (j >= 63) j -= 63;
   if (k >= 63) k -= 63;
   do { unsigned w = (((L.alt_result )[i]) << 16) | (((L.alt_result )[j]) << 8) | ((L.alt_result )[k]); resptr = to64(resptr, w, 4); } while (0);
   if (j == 20)
    break;
   i = j + 1;
  }
  do { unsigned w = ((0) << 16) | ((0) << 8) | ((L.alt_result )[63]); resptr = to64(resptr, w, 2); } while (0);
 }
 memset(&L, 0, sizeof(L));
 memset(key_data, 0, key_len);
 memset(salt_data, 0, salt_len);
 free(key_data);
 free(salt_data);
 return result;
}
