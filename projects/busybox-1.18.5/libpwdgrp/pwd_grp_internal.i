int GETXXKEY_R_FUNC(GETXXKEY_R_KEYTYPE key,
    GETXXKEY_R_ENTTYPE *__restrict resultbuf,
    char *__restrict buffer, size_t buflen,
    GETXXKEY_R_ENTTYPE **__restrict result)
{
 FILE *stream;
 int rv;
 *result = NULL;
 stream = fopen_for_read(GETXXKEY_R_PATHNAME);
 if (!stream)
  return errno;
 while (1) {
  rv = bb__pgsreader(GETXXKEY_R_PARSER, resultbuf, buffer, buflen, stream);
  if (!rv) {
   if (GETXXKEY_R_TEST(resultbuf)) {
    *result = resultbuf;
    break;
   }
  } else {
   if (rv == ENOENT) {
    rv = 0;
   }
   break;
  }
 }
 fclose(stream);
 return rv;
}
