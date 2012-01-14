typedef __builtin_va_list __gnuc_va_list;

extern void closelog (void);
extern void openlog (__const char *__ident, int __option, int __facility);
extern int setlogmask (int __mask) __attribute__ ((__nothrow__));
extern void syslog (int __pri, __const char *__fmt, ...)
     __attribute__ ((__format__ (__printf__, 2, 3)));
extern void vsyslog (int __pri, __const char *__fmt, __gnuc_va_list __ap)
     __attribute__ ((__format__ (__printf__, 2, 0)));
