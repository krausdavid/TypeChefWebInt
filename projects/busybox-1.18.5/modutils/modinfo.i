extern int fnmatch (const char *__pattern, const char *__name,
      int __flags);

struct utsname
  {
    char sysname[65];
    char nodename[65];
    char release[65];
    char version[65];
    char machine[65];
    char __domainname[65];
  };
extern int uname (struct utsname *__name) __attribute__ ((__nothrow__));
