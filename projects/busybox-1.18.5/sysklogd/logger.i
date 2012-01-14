static int decode(char *name, const CODE *codetab)
{
 const CODE *c;
 if (isdigit(*name))
  return atoi(name);
 for (c = codetab; c->c_name; c++) {
  if (!strcasecmp(name, c->c_name)) {
   return c->c_val;
  }
 }
 return -1;
}
static int pencode(char *s)
{
 char *save;
 int lev, fac = LOG_USER;
 for (save = s; *s && *s != '.'; ++s)
  ;
 if (*s) {
  *s = '\0';
  fac = decode(save, facilitynames);
  if (fac < 0)
   bb_error_msg_and_die("unknown %s name: %s", "facility", save);
  *s++ = '.';
 } else {
  s = save;
 }
 lev = decode(s, prioritynames);
 if (lev < 0)
  bb_error_msg_and_die("unknown %s name: %s", "priority", save);
 return ((lev & LOG_PRIMASK) | (fac & LOG_FACMASK));
}
int logger_main(int argc, char **argv) MAIN_EXTERNALLY_VISIBLE;
int logger_main(int argc UNUSED_PARAM, char **argv)
{
 char *str_p, *str_t;
 int opt;
 int i = 0;
 str_t = uid2uname_utoa(geteuid());
 opt = getopt32(argv, "p:st:", &str_p, &str_t);
 if (opt & 0x2)
  i |= LOG_PERROR;
 openlog(str_t, i, 0);
 i = LOG_USER | LOG_NOTICE;
 if (opt & 0x1)
  i = pencode(str_p);
 argv += optind;
 if (!argv[0]) {
  while (fgets(bb_common_bufsiz1, COMMON_BUFSIZE, stdin)) {
   if (bb_common_bufsiz1[0]
    && NOT_LONE_CHAR(bb_common_bufsiz1, '\n')
   ) {
    syslog(i, "%s", bb_common_bufsiz1);
   }
  }
 } else {
  char *message = NULL;
  int len = 0;
  int pos = 0;
  do {
   len += strlen(*argv) + 1;
   message = xrealloc(message, len + 1);
   sprintf(message + pos, " %s", *argv),
   pos = len;
  } while (*++argv);
  syslog(i, "%s", message + 1);
 }
 closelog();
 return EXIT_SUCCESS;
}
