unsigned type FAST_FUNC xstrtou(_range_sfx)(const char *numstr, int base,
  unsigned type lower,
  unsigned type upper,
  const struct suffix_mult *suffixes)
{
 unsigned type r;
 int old_errno;
 char *e;
 if (*numstr == '-' || *numstr == '+' || isspace(*numstr))
  goto inval;
 old_errno = errno;
 errno = 0;
 r = XSTR_STRTOU(numstr, &e, base);
 if (errno || numstr == e)
  goto inval;
 errno = old_errno;
 if (suffixes) {
  while (suffixes->mult) {
   if (strcmp(suffixes->suffix, e) == 0) {
    if (XSTR_UTYPE_MAX / suffixes->mult < r)
     goto range;
    r *= suffixes->mult;
    goto chk_range;
   }
   ++suffixes;
  }
 }
 if (*e)
  goto inval;
 chk_range:
 if (r >= lower && r <= upper)
  return r;
 range:
 bb_error_msg_and_die("number %s is not in %llu..%llu range",
  numstr, (unsigned long long)lower,
  (unsigned long long)upper);
 inval:
 bb_error_msg_and_die("invalid number '%s'", numstr);
}
unsigned type FAST_FUNC xstrtou(_range)(const char *numstr, int base,
  unsigned type lower,
  unsigned type upper)
{
 return xstrtou(_range_sfx)(numstr, base, lower, upper, NULL);
}
unsigned type FAST_FUNC xstrtou(_sfx)(const char *numstr, int base,
  const struct suffix_mult *suffixes)
{
 return xstrtou(_range_sfx)(numstr, base, 0, XSTR_UTYPE_MAX, suffixes);
}
unsigned type FAST_FUNC xstrtou()(const char *numstr, int base)
{
 return xstrtou(_range_sfx)(numstr, base, 0, XSTR_UTYPE_MAX, NULL);
}
unsigned type FAST_FUNC xatou(_range_sfx)(const char *numstr,
  unsigned type lower,
  unsigned type upper,
  const struct suffix_mult *suffixes)
{
 return xstrtou(_range_sfx)(numstr, 10, lower, upper, suffixes);
}
unsigned type FAST_FUNC xatou(_range)(const char *numstr,
  unsigned type lower,
  unsigned type upper)
{
 return xstrtou(_range_sfx)(numstr, 10, lower, upper, NULL);
}
unsigned type FAST_FUNC xatou(_sfx)(const char *numstr,
  const struct suffix_mult *suffixes)
{
 return xstrtou(_range_sfx)(numstr, 10, 0, XSTR_UTYPE_MAX, suffixes);
}
unsigned type FAST_FUNC xatou()(const char *numstr)
{
 return xatou(_sfx)(numstr, NULL);
}
type FAST_FUNC xstrto(_range_sfx)(const char *numstr, int base,
  type lower,
  type upper,
  const struct suffix_mult *suffixes)
{
 unsigned type u = XSTR_TYPE_MAX;
 type r;
 const char *p = numstr;
 if (p[0] == '+' || p[0] == '-') {
  ++p;
  if (p[0] == '-')
   ++u;
 }
 r = xstrtou(_range_sfx)(p, base, 0, u, suffixes);
 if (*numstr == '-') {
  r = -r;
 }
 if (r < lower || r > upper) {
  bb_error_msg_and_die("number %s is not in %lld..%lld range",
    numstr, (long long)lower, (long long)upper);
 }
 return r;
}
type FAST_FUNC xstrto(_range)(const char *numstr, int base, type lower, type upper)
{
 return xstrto(_range_sfx)(numstr, base, lower, upper, NULL);
}
type FAST_FUNC xstrto()(const char *numstr, int base)
{
 return xstrto(_range_sfx)(numstr, base, XSTR_TYPE_MIN, XSTR_TYPE_MAX, NULL);
}
type FAST_FUNC xato(_range_sfx)(const char *numstr,
  type lower,
  type upper,
  const struct suffix_mult *suffixes)
{
 return xstrto(_range_sfx)(numstr, 10, lower, upper, suffixes);
}
type FAST_FUNC xato(_range)(const char *numstr, type lower, type upper)
{
 return xstrto(_range_sfx)(numstr, 10, lower, upper, NULL);
}
type FAST_FUNC xato(_sfx)(const char *numstr, const struct suffix_mult *suffixes)
{
 return xstrto(_range_sfx)(numstr, 10, XSTR_TYPE_MIN, XSTR_TYPE_MAX, suffixes);
}
type FAST_FUNC xato()(const char *numstr)
{
 return xstrto(_range_sfx)(numstr, 10, XSTR_TYPE_MIN, XSTR_TYPE_MAX, NULL);
}
