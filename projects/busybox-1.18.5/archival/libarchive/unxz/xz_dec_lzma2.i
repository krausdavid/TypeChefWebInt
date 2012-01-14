typedef long unsigned int size_t;
typedef int wchar_t;

union wait
  {
    int w_status;
    struct
      {
 unsigned int __w_termsig:7;
 unsigned int __w_coredump:1;
 unsigned int __w_retcode:8;
 unsigned int:16;
      } __wait_terminated;
    struct
      {
 unsigned int __w_stopval:8;
 unsigned int __w_stopsig:8;
 unsigned int:16;
      } __wait_stopped;
  };
typedef union
  {
    union wait *__uptr;
    int *__iptr;
  } __WAIT_STATUS __attribute__ ((__transparent_union__));

typedef struct
  {
    int quot;
    int rem;
  } div_t;
typedef struct
  {
    long int quot;
    long int rem;
  } ldiv_t;


__extension__ typedef struct
  {
    long long int quot;
    long long int rem;
  } lldiv_t;

extern size_t __ctype_get_mb_cur_max (void) __attribute__ ((__nothrow__)) ;

extern double atof (__const char *__nptr)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1))) ;
extern int atoi (__const char *__nptr)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1))) ;
extern long int atol (__const char *__nptr)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1))) ;


__extension__ extern long long int atoll (__const char *__nptr)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1))) ;


extern double strtod (__const char *__restrict __nptr,
        char **__restrict __endptr)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;


extern float strtof (__const char *__restrict __nptr,
       char **__restrict __endptr) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;
extern long double strtold (__const char *__restrict __nptr,
       char **__restrict __endptr)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;


extern long int strtol (__const char *__restrict __nptr,
   char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;
extern unsigned long int strtoul (__const char *__restrict __nptr,
      char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;

__extension__
extern long long int strtoq (__const char *__restrict __nptr,
        char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;
__extension__
extern unsigned long long int strtouq (__const char *__restrict __nptr,
           char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;

__extension__
extern long long int strtoll (__const char *__restrict __nptr,
         char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;
__extension__
extern unsigned long long int strtoull (__const char *__restrict __nptr,
     char **__restrict __endptr, int __base)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;

extern char *l64a (long int __n) __attribute__ ((__nothrow__)) ;
extern long int a64l (__const char *__s)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1))) ;

typedef unsigned char __u_char;
typedef unsigned short int __u_short;
typedef unsigned int __u_int;
typedef unsigned long int __u_long;
typedef signed char __int8_t;
typedef unsigned char __uint8_t;
typedef signed short int __int16_t;
typedef unsigned short int __uint16_t;
typedef signed int __int32_t;
typedef unsigned int __uint32_t;
typedef signed long int __int64_t;
typedef unsigned long int __uint64_t;
typedef long int __quad_t;
typedef unsigned long int __u_quad_t;
typedef unsigned long int __dev_t;
typedef unsigned int __uid_t;
typedef unsigned int __gid_t;
typedef unsigned long int __ino_t;
typedef unsigned long int __ino64_t;
typedef unsigned int __mode_t;
typedef unsigned long int __nlink_t;
typedef long int __off_t;
typedef long int __off64_t;
typedef int __pid_t;
typedef struct { int __val[2]; } __fsid_t;
typedef long int __clock_t;
typedef unsigned long int __rlim_t;
typedef unsigned long int __rlim64_t;
typedef unsigned int __id_t;
typedef long int __time_t;
typedef unsigned int __useconds_t;
typedef long int __suseconds_t;
typedef int __daddr_t;
typedef long int __swblk_t;
typedef int __key_t;
typedef int __clockid_t;
typedef void * __timer_t;
typedef long int __blksize_t;
typedef long int __blkcnt_t;
typedef long int __blkcnt64_t;
typedef unsigned long int __fsblkcnt_t;
typedef unsigned long int __fsblkcnt64_t;
typedef unsigned long int __fsfilcnt_t;
typedef unsigned long int __fsfilcnt64_t;
typedef long int __ssize_t;
typedef __off64_t __loff_t;
typedef __quad_t *__qaddr_t;
typedef char *__caddr_t;
typedef long int __intptr_t;
typedef unsigned int __socklen_t;
typedef __u_char u_char;
typedef __u_short u_short;
typedef __u_int u_int;
typedef __u_long u_long;
typedef __quad_t quad_t;
typedef __u_quad_t u_quad_t;
typedef __fsid_t fsid_t;
typedef __loff_t loff_t;
typedef __ino_t ino_t;
typedef __dev_t dev_t;
typedef __gid_t gid_t;
typedef __mode_t mode_t;
typedef __nlink_t nlink_t;
typedef __uid_t uid_t;
typedef __off_t off_t;
typedef __pid_t pid_t;
typedef __id_t id_t;
typedef __ssize_t ssize_t;
typedef __daddr_t daddr_t;
typedef __caddr_t caddr_t;
typedef __key_t key_t;

typedef __clock_t clock_t;



typedef __time_t time_t;


typedef __clockid_t clockid_t;
typedef __timer_t timer_t;
typedef unsigned long int ulong;
typedef unsigned short int ushort;
typedef unsigned int uint;
typedef int int8_t __attribute__ ((__mode__ (__QI__)));
typedef int int16_t __attribute__ ((__mode__ (__HI__)));
typedef int int32_t __attribute__ ((__mode__ (__SI__)));
typedef int int64_t __attribute__ ((__mode__ (__DI__)));
typedef unsigned int u_int8_t __attribute__ ((__mode__ (__QI__)));
typedef unsigned int u_int16_t __attribute__ ((__mode__ (__HI__)));
typedef unsigned int u_int32_t __attribute__ ((__mode__ (__SI__)));
typedef unsigned int u_int64_t __attribute__ ((__mode__ (__DI__)));
typedef int register_t __attribute__ ((__mode__ (__word__)));
typedef int __sig_atomic_t;
typedef struct
  {
    unsigned long int __val[(1024 / (8 * sizeof (unsigned long int)))];
  } __sigset_t;
typedef __sigset_t sigset_t;
struct timespec
  {
    __time_t tv_sec;
    long int tv_nsec;
  };
struct timeval
  {
    __time_t tv_sec;
    __suseconds_t tv_usec;
  };
typedef __suseconds_t suseconds_t;
typedef long int __fd_mask;
typedef struct
  {
    __fd_mask __fds_bits[1024 / (8 * (int) sizeof (__fd_mask))];
  } fd_set;
typedef __fd_mask fd_mask;

extern int select (int __nfds, fd_set *__restrict __readfds,
     fd_set *__restrict __writefds,
     fd_set *__restrict __exceptfds,
     struct timeval *__restrict __timeout);
extern int pselect (int __nfds, fd_set *__restrict __readfds,
      fd_set *__restrict __writefds,
      fd_set *__restrict __exceptfds,
      const struct timespec *__restrict __timeout,
      const __sigset_t *__restrict __sigmask);


__extension__
extern unsigned int gnu_dev_major (unsigned long long int __dev)
     __attribute__ ((__nothrow__));
__extension__
extern unsigned int gnu_dev_minor (unsigned long long int __dev)
     __attribute__ ((__nothrow__));
__extension__
extern unsigned long long int gnu_dev_makedev (unsigned int __major,
            unsigned int __minor)
     __attribute__ ((__nothrow__));

typedef __blksize_t blksize_t;
typedef __blkcnt_t blkcnt_t;
typedef __fsblkcnt_t fsblkcnt_t;


typedef __fsfilcnt_t fsfilcnt_t;
typedef unsigned long int pthread_t;
typedef union
{
  char __size[56];
  long int __align;
} pthread_attr_t;
typedef struct __pthread_internal_list
{
  struct __pthread_internal_list *__prev;
  struct __pthread_internal_list *__next;
} __pthread_list_t;
typedef union
{
  struct __pthread_mutex_s
  {
    int __lock;
    unsigned int __count;
    int __owner;
    unsigned int __nusers;
    int __kind;
    int __spins;
    __pthread_list_t __list;
  } __data;
  char __size[40];
  long int __align;
} pthread_mutex_t;
typedef union
{
  char __size[4];
  int __align;
} pthread_mutexattr_t;
typedef union
{
  struct
  {
    int __lock;
    unsigned int __futex;
    __extension__ unsigned long long int __total_seq;
    __extension__ unsigned long long int __wakeup_seq;
    __extension__ unsigned long long int __woken_seq;
    void *__mutex;
    unsigned int __nwaiters;
    unsigned int __broadcast_seq;
  } __data;
  char __size[48];
  __extension__ long long int __align;
} pthread_cond_t;
typedef union
{
  char __size[4];
  int __align;
} pthread_condattr_t;
typedef unsigned int pthread_key_t;
typedef int pthread_once_t;
typedef union
{
  struct
  {
    int __lock;
    unsigned int __nr_readers;
    unsigned int __readers_wakeup;
    unsigned int __writer_wakeup;
    unsigned int __nr_readers_queued;
    unsigned int __nr_writers_queued;
    int __writer;
    int __shared;
    unsigned long int __pad1;
    unsigned long int __pad2;
    unsigned int __flags;
  } __data;
  char __size[56];
  long int __align;
} pthread_rwlock_t;
typedef union
{
  char __size[8];
  long int __align;
} pthread_rwlockattr_t;
typedef volatile int pthread_spinlock_t;
typedef union
{
  char __size[32];
  long int __align;
} pthread_barrier_t;
typedef union
{
  char __size[4];
  int __align;
} pthread_barrierattr_t;

extern long int random (void) __attribute__ ((__nothrow__));
extern void srandom (unsigned int __seed) __attribute__ ((__nothrow__));
extern char *initstate (unsigned int __seed, char *__statebuf,
   size_t __statelen) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2)));


extern char *setstate (char *__statebuf) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));







struct random_data
  {
    int32_t *fptr;
    int32_t *rptr;
    int32_t *state;
    int rand_type;
    int rand_deg;
    int rand_sep;
    int32_t *end_ptr;
  };

extern int random_r (struct random_data *__restrict __buf,
       int32_t *__restrict __result) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));

extern int srandom_r (unsigned int __seed, struct random_data *__buf)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2)));

extern int initstate_r (unsigned int __seed, char *__restrict __statebuf,
   size_t __statelen,
   struct random_data *__restrict __buf)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2, 4)));

extern int setstate_r (char *__restrict __statebuf,
         struct random_data *__restrict __buf)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));






extern int rand (void) __attribute__ ((__nothrow__));

extern void srand (unsigned int __seed) __attribute__ ((__nothrow__));




extern int rand_r (unsigned int *__seed) __attribute__ ((__nothrow__));







extern double drand48 (void) __attribute__ ((__nothrow__));
extern double erand48 (unsigned short int __xsubi[3]) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));


extern long int lrand48 (void) __attribute__ ((__nothrow__));
extern long int nrand48 (unsigned short int __xsubi[3])
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));


extern long int mrand48 (void) __attribute__ ((__nothrow__));
extern long int jrand48 (unsigned short int __xsubi[3])
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));


extern void srand48 (long int __seedval) __attribute__ ((__nothrow__));
extern unsigned short int *seed48 (unsigned short int __seed16v[3])
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
extern void lcong48 (unsigned short int __param[7]) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));





struct drand48_data
  {
    unsigned short int __x[3];
    unsigned short int __old_x[3];
    unsigned short int __c;
    unsigned short int __init;
    unsigned long long int __a;
  };


extern int drand48_r (struct drand48_data *__restrict __buffer,
        double *__restrict __result) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern int erand48_r (unsigned short int __xsubi[3],
        struct drand48_data *__restrict __buffer,
        double *__restrict __result) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));


extern int lrand48_r (struct drand48_data *__restrict __buffer,
        long int *__restrict __result)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern int nrand48_r (unsigned short int __xsubi[3],
        struct drand48_data *__restrict __buffer,
        long int *__restrict __result)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));


extern int mrand48_r (struct drand48_data *__restrict __buffer,
        long int *__restrict __result)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern int jrand48_r (unsigned short int __xsubi[3],
        struct drand48_data *__restrict __buffer,
        long int *__restrict __result)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));


extern int srand48_r (long int __seedval, struct drand48_data *__buffer)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2)));

extern int seed48_r (unsigned short int __seed16v[3],
       struct drand48_data *__buffer) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));

extern int lcong48_r (unsigned short int __param[7],
        struct drand48_data *__buffer)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));









extern void *malloc (size_t __size) __attribute__ ((__nothrow__)) __attribute__ ((__malloc__)) ;

extern void *calloc (size_t __nmemb, size_t __size)
     __attribute__ ((__nothrow__)) __attribute__ ((__malloc__)) ;










extern void *realloc (void *__ptr, size_t __size)
     __attribute__ ((__nothrow__)) __attribute__ ((__warn_unused_result__));

extern void free (void *__ptr) __attribute__ ((__nothrow__));




extern void cfree (void *__ptr) __attribute__ ((__nothrow__));

extern void *alloca (size_t __size) __attribute__ ((__nothrow__));







extern void *valloc (size_t __size) __attribute__ ((__nothrow__)) __attribute__ ((__malloc__)) ;




extern int posix_memalign (void **__memptr, size_t __alignment, size_t __size)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;




extern void abort (void) __attribute__ ((__nothrow__)) __attribute__ ((__noreturn__));



extern int atexit (void (*__func) (void)) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));

extern int on_exit (void (*__func) (int __status, void *__arg), void *__arg)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));

extern void exit (int __status) __attribute__ ((__nothrow__)) __attribute__ ((__noreturn__));


extern void _Exit (int __status) __attribute__ ((__nothrow__)) __attribute__ ((__noreturn__));


extern char *getenv (__const char *__name) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;

extern char *__secure_getenv (__const char *__name)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;
extern int putenv (char *__string) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
extern int setenv (__const char *__name, __const char *__value, int __replace)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2)));
extern int unsetenv (__const char *__name) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
extern int clearenv (void) __attribute__ ((__nothrow__));
extern char *mktemp (char *__template) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;
extern int mkstemp (char *__template) __attribute__ ((__nonnull__ (1))) ;
extern int mkstemps (char *__template, int __suffixlen) __attribute__ ((__nonnull__ (1))) ;
extern char *mkdtemp (char *__template) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;

extern int system (__const char *__command) ;

extern char *realpath (__const char *__restrict __name,
         char *__restrict __resolved) __attribute__ ((__nothrow__)) ;
typedef int (*__compar_fn_t) (__const void *, __const void *);

extern void *bsearch (__const void *__key, __const void *__base,
        size_t __nmemb, size_t __size, __compar_fn_t __compar)
     __attribute__ ((__nonnull__ (1, 2, 5))) ;
extern void qsort (void *__base, size_t __nmemb, size_t __size,
     __compar_fn_t __compar) __attribute__ ((__nonnull__ (1, 4)));
extern int abs (int __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__)) ;
extern long int labs (long int __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__)) ;

__extension__ extern long long int llabs (long long int __x)
     __attribute__ ((__nothrow__)) __attribute__ ((__const__)) ;

extern div_t div (int __numer, int __denom)
     __attribute__ ((__nothrow__)) __attribute__ ((__const__)) ;
extern ldiv_t ldiv (long int __numer, long int __denom)
     __attribute__ ((__nothrow__)) __attribute__ ((__const__)) ;


__extension__ extern lldiv_t lldiv (long long int __numer,
        long long int __denom)
     __attribute__ ((__nothrow__)) __attribute__ ((__const__)) ;

extern char *ecvt (double __value, int __ndigit, int *__restrict __decpt,
     int *__restrict __sign) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (3, 4))) ;
extern char *fcvt (double __value, int __ndigit, int *__restrict __decpt,
     int *__restrict __sign) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (3, 4))) ;
extern char *gcvt (double __value, int __ndigit, char *__buf)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (3))) ;
extern char *qecvt (long double __value, int __ndigit,
      int *__restrict __decpt, int *__restrict __sign)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (3, 4))) ;
extern char *qfcvt (long double __value, int __ndigit,
      int *__restrict __decpt, int *__restrict __sign)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (3, 4))) ;
extern char *qgcvt (long double __value, int __ndigit, char *__buf)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (3))) ;
extern int ecvt_r (double __value, int __ndigit, int *__restrict __decpt,
     int *__restrict __sign, char *__restrict __buf,
     size_t __len) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (3, 4, 5)));
extern int fcvt_r (double __value, int __ndigit, int *__restrict __decpt,
     int *__restrict __sign, char *__restrict __buf,
     size_t __len) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (3, 4, 5)));
extern int qecvt_r (long double __value, int __ndigit,
      int *__restrict __decpt, int *__restrict __sign,
      char *__restrict __buf, size_t __len)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (3, 4, 5)));
extern int qfcvt_r (long double __value, int __ndigit,
      int *__restrict __decpt, int *__restrict __sign,
      char *__restrict __buf, size_t __len)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (3, 4, 5)));

extern int mblen (__const char *__s, size_t __n) __attribute__ ((__nothrow__)) ;
extern int mbtowc (wchar_t *__restrict __pwc,
     __const char *__restrict __s, size_t __n) __attribute__ ((__nothrow__)) ;
extern int wctomb (char *__s, wchar_t __wchar) __attribute__ ((__nothrow__)) ;
extern size_t mbstowcs (wchar_t *__restrict __pwcs,
   __const char *__restrict __s, size_t __n) __attribute__ ((__nothrow__));
extern size_t wcstombs (char *__restrict __s,
   __const wchar_t *__restrict __pwcs, size_t __n)
     __attribute__ ((__nothrow__));

extern int rpmatch (__const char *__response) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;
extern int getsubopt (char **__restrict __optionp,
        char *__const *__restrict __tokens,
        char **__restrict __valuep)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2, 3))) ;
extern int getloadavg (double __loadavg[], int __nelem)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));



extern void *memcpy (void *__restrict __dest,
       __const void *__restrict __src, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern void *memmove (void *__dest, __const void *__src, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));

extern void *memccpy (void *__restrict __dest, __const void *__restrict __src,
        int __c, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));

extern void *memset (void *__s, int __c, size_t __n) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
extern int memcmp (__const void *__s1, __const void *__s2, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern void *memchr (__const void *__s, int __c, size_t __n)
      __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));


extern char *strcpy (char *__restrict __dest, __const char *__restrict __src)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *strncpy (char *__restrict __dest,
        __const char *__restrict __src, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *strcat (char *__restrict __dest, __const char *__restrict __src)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *strncat (char *__restrict __dest, __const char *__restrict __src,
        size_t __n) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern int strcmp (__const char *__s1, __const char *__s2)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern int strncmp (__const char *__s1, __const char *__s2, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern int strcoll (__const char *__s1, __const char *__s2)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern size_t strxfrm (char *__restrict __dest,
         __const char *__restrict __src, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2)));

typedef struct __locale_struct
{
  struct __locale_data *__locales[13];
  const unsigned short int *__ctype_b;
  const int *__ctype_tolower;
  const int *__ctype_toupper;
  const char *__names[13];
} *__locale_t;
typedef __locale_t locale_t;
extern int strcoll_l (__const char *__s1, __const char *__s2, __locale_t __l)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2, 3)));
extern size_t strxfrm_l (char *__dest, __const char *__src, size_t __n,
    __locale_t __l) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2, 4)));
extern char *strdup (__const char *__s)
     __attribute__ ((__nothrow__)) __attribute__ ((__malloc__)) __attribute__ ((__nonnull__ (1)));
extern char *strndup (__const char *__string, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__malloc__)) __attribute__ ((__nonnull__ (1)));

extern char *strchr (__const char *__s, int __c)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));
extern char *strrchr (__const char *__s, int __c)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));


extern size_t strcspn (__const char *__s, __const char *__reject)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern size_t strspn (__const char *__s, __const char *__accept)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *strpbrk (__const char *__s, __const char *__accept)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *strstr (__const char *__haystack, __const char *__needle)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *strtok (char *__restrict __s, __const char *__restrict __delim)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2)));

extern char *__strtok_r (char *__restrict __s,
    __const char *__restrict __delim,
    char **__restrict __save_ptr)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2, 3)));
extern char *strtok_r (char *__restrict __s, __const char *__restrict __delim,
         char **__restrict __save_ptr)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2, 3)));

extern size_t strlen (__const char *__s)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));

extern size_t strnlen (__const char *__string, size_t __maxlen)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));

extern char *strerror (int __errnum) __attribute__ ((__nothrow__));

extern int strerror_r (int __errnum, char *__buf, size_t __buflen) __asm__ ("" "__xpg_strerror_r") __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2)));
extern char *strerror_l (int __errnum, __locale_t __l) __attribute__ ((__nothrow__));
extern void __bzero (void *__s, size_t __n) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
extern void bcopy (__const void *__src, void *__dest, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern void bzero (void *__s, size_t __n) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
extern int bcmp (__const void *__s1, __const void *__s2, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *index (__const char *__s, int __c)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));
extern char *rindex (__const char *__s, int __c)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));
extern int ffs (int __i) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern int strcasecmp (__const char *__s1, __const char *__s2)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern int strncasecmp (__const char *__s1, __const char *__s2, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *strsep (char **__restrict __stringp,
       __const char *__restrict __delim)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *strsignal (int __sig) __attribute__ ((__nothrow__));
extern char *__stpcpy (char *__restrict __dest, __const char *__restrict __src)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *stpcpy (char *__restrict __dest, __const char *__restrict __src)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *__stpncpy (char *__restrict __dest,
   __const char *__restrict __src, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *stpncpy (char *__restrict __dest,
        __const char *__restrict __src, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));

typedef long int ptrdiff_t;
typedef unsigned char uint8_t;
typedef unsigned short int uint16_t;
typedef unsigned int uint32_t;
typedef unsigned long int uint64_t;
typedef signed char int_least8_t;
typedef short int int_least16_t;
typedef int int_least32_t;
typedef long int int_least64_t;
typedef unsigned char uint_least8_t;
typedef unsigned short int uint_least16_t;
typedef unsigned int uint_least32_t;
typedef unsigned long int uint_least64_t;
typedef signed char int_fast8_t;
typedef long int int_fast16_t;
typedef long int int_fast32_t;
typedef long int int_fast64_t;
typedef unsigned char uint_fast8_t;
typedef unsigned long int uint_fast16_t;
typedef unsigned long int uint_fast32_t;
typedef unsigned long int uint_fast64_t;
typedef long int intptr_t;
typedef unsigned long int uintptr_t;
typedef long int intmax_t;
typedef unsigned long int uintmax_t;
enum xz_mode {
 XZ_SINGLE,
 XZ_PREALLOC,
 XZ_DYNALLOC
};
enum xz_ret {
 XZ_OK,
 XZ_STREAM_END,
 XZ_UNSUPPORTED_CHECK,
 XZ_MEM_ERROR,
 XZ_MEMLIMIT_ERROR,
 XZ_FORMAT_ERROR,
 XZ_OPTIONS_ERROR,
 XZ_DATA_ERROR,
 XZ_BUF_ERROR
};
struct xz_buf {
 const uint8_t *in;
 size_t in_pos;
 size_t in_size;
 uint8_t *out;
 size_t out_pos;
 size_t out_size;
};
struct xz_dec;
extern struct xz_dec * xz_dec_init(
  enum xz_mode mode, uint32_t dict_max);
extern enum xz_ret xz_dec_run(struct xz_dec *s, struct xz_buf *b);
extern void xz_dec_reset(struct xz_dec *s);
extern void xz_dec_end(struct xz_dec *s);
extern void xz_crc32_init(void);
extern uint32_t xz_crc32(
  const uint8_t *buf, size_t size, uint32_t crc);
static inline uint32_t get_unaligned_le32(const uint8_t *buf)
{
 return (uint32_t)buf[0]
   | ((uint32_t)buf[1] << 8)
   | ((uint32_t)buf[2] << 16)
   | ((uint32_t)buf[3] << 24);
}
static inline uint32_t get_unaligned_be32(const uint8_t *buf)
{
 return (uint32_t)(buf[0] << 24)
   | ((uint32_t)buf[1] << 16)
   | ((uint32_t)buf[2] << 8)
   | (uint32_t)buf[3];
}
static inline void put_unaligned_le32(uint32_t val, uint8_t *buf)
{
 buf[0] = (uint8_t)val;
 buf[1] = (uint8_t)(val >> 8);
 buf[2] = (uint8_t)(val >> 16);
 buf[3] = (uint8_t)(val >> 24);
}
static inline void put_unaligned_be32(uint32_t val, uint8_t *buf)
{
 buf[0] = (uint8_t)(val >> 24);
 buf[1] = (uint8_t)(val >> 16);
 buf[2] = (uint8_t)(val >> 8);
 buf[3] = (uint8_t)val;
}
extern struct xz_dec_lzma2 * xz_dec_lzma2_create(
  enum xz_mode mode, uint32_t dict_max);
extern enum xz_ret xz_dec_lzma2_reset(
  struct xz_dec_lzma2 *s, uint8_t props);
extern enum xz_ret xz_dec_lzma2_run(
  struct xz_dec_lzma2 *s, struct xz_buf *b);
extern void xz_dec_lzma2_end(struct xz_dec_lzma2 *s);
enum lzma_state {
 STATE_LIT_LIT,
 STATE_MATCH_LIT_LIT,
 STATE_REP_LIT_LIT,
 STATE_SHORTREP_LIT_LIT,
 STATE_MATCH_LIT,
 STATE_REP_LIT,
 STATE_SHORTREP_LIT,
 STATE_LIT_MATCH,
 STATE_LIT_LONGREP,
 STATE_LIT_SHORTREP,
 STATE_NONLIT_MATCH,
 STATE_NONLIT_REP
};
static inline void lzma_state_literal(enum lzma_state *state)
{
 if (*state <= STATE_SHORTREP_LIT_LIT)
  *state = STATE_LIT_LIT;
 else if (*state <= STATE_LIT_SHORTREP)
  *state -= 3;
 else
  *state -= 6;
}
static inline void lzma_state_match(enum lzma_state *state)
{
 *state = *state < 7 ? STATE_LIT_MATCH : STATE_NONLIT_MATCH;
}
static inline void lzma_state_long_rep(enum lzma_state *state)
{
 *state = *state < 7 ? STATE_LIT_LONGREP : STATE_NONLIT_REP;
}
static inline void lzma_state_short_rep(enum lzma_state *state)
{
 *state = *state < 7 ? STATE_LIT_SHORTREP : STATE_NONLIT_REP;
}
static inline _Bool lzma_state_is_literal(enum lzma_state state)
{
 return state < 7;
}
static inline uint32_t lzma_get_dist_state(uint32_t len)
{
 return len < 4 + 2
   ? len - 2 : 4 - 1;
}
struct dictionary {
 uint8_t *buf;
 size_t start;
 size_t pos;
 size_t full;
 size_t limit;
 size_t end;
 uint32_t size;
 uint32_t size_max;
 uint32_t allocated;
 enum xz_mode mode;
};
struct rc_dec {
 uint32_t range;
 uint32_t code;
 uint32_t init_bytes_left;
 const uint8_t *in;
 size_t in_pos;
 size_t in_limit;
};
struct lzma_len_dec {
 uint16_t choice;
 uint16_t choice2;
 uint16_t low[(1 << 4)][(1 << 3)];
 uint16_t mid[(1 << 4)][(1 << 3)];
 uint16_t high[(1 << 8)];
};
struct lzma_dec {
 uint32_t rep0;
 uint32_t rep1;
 uint32_t rep2;
 uint32_t rep3;
 enum lzma_state state;
 uint32_t len;
 uint32_t lc;
 uint32_t literal_pos_mask;
 uint32_t pos_mask;
 uint16_t is_match[12][(1 << 4)];
 uint16_t is_rep[12];
 uint16_t is_rep0[12];
 uint16_t is_rep1[12];
 uint16_t is_rep2[12];
 uint16_t is_rep0_long[12][(1 << 4)];
 uint16_t dist_slot[4][(1 << 6)];
 uint16_t dist_special[(1 << (14 / 2)) - 14];
 uint16_t dist_align[(1 << 4)];
 struct lzma_len_dec match_len_dec;
 struct lzma_len_dec rep_len_dec;
 uint16_t literal[(1 << 4)][0x300];
};
struct lzma2_dec {
 enum lzma2_seq {
  SEQ_CONTROL,
  SEQ_UNCOMPRESSED_1,
  SEQ_UNCOMPRESSED_2,
  SEQ_COMPRESSED_0,
  SEQ_COMPRESSED_1,
  SEQ_PROPERTIES,
  SEQ_LZMA_PREPARE,
  SEQ_LZMA_RUN,
  SEQ_COPY
 } sequence;
 enum lzma2_seq next_sequence;
 uint32_t uncompressed;
 uint32_t compressed;
 _Bool need_dict_reset;
 _Bool need_props;
};
struct xz_dec_lzma2 {
 struct rc_dec rc;
 struct dictionary dict;
 struct lzma2_dec lzma2;
 struct lzma_dec lzma;
 struct {
  uint32_t size;
  uint8_t buf[3 * 21];
 } temp;
};
static void dict_reset(struct dictionary *dict, struct xz_buf *b)
{
 if (((dict->mode) == XZ_SINGLE)) {
  dict->buf = b->out + b->out_pos;
  dict->end = b->out_size - b->out_pos;
 }
 dict->start = 0;
 dict->pos = 0;
 dict->limit = 0;
 dict->full = 0;
}
static void dict_limit(struct dictionary *dict, size_t out_max)
{
 if (dict->end - dict->pos <= out_max)
  dict->limit = dict->end;
 else
  dict->limit = dict->pos + out_max;
}
static __inline __attribute__ ((__always_inline__)) _Bool dict_has_space(const struct dictionary *dict)
{
 return dict->pos < dict->limit;
}
static __inline __attribute__ ((__always_inline__)) uint32_t dict_get(
  const struct dictionary *dict, uint32_t dist)
{
 size_t offset = dict->pos - dist - 1;
 if (dist >= dict->pos)
  offset += dict->end;
 return dict->full > 0 ? dict->buf[offset] : 0;
}
static inline void dict_put(struct dictionary *dict, uint8_t byte)
{
 dict->buf[dict->pos++] = byte;
 if (dict->full < dict->pos)
  dict->full = dict->pos;
}
static _Bool dict_repeat(
  struct dictionary *dict, uint32_t *len, uint32_t dist)
{
 size_t back;
 uint32_t left;
 if (dist >= dict->full || dist >= dict->size)
  return 0;
 left = ((dict->limit - dict->pos) < (*len) ? (dict->limit - dict->pos) : (*len));
 *len -= left;
 back = dict->pos - dist - 1;
 if (dist >= dict->pos)
  back += dict->end;
 do {
  dict->buf[dict->pos++] = dict->buf[back++];
  if (back == dict->end)
   back = 0;
 } while (--left > 0);
 if (dict->full < dict->pos)
  dict->full = dict->pos;
 return 1;
}
static void dict_uncompressed(
  struct dictionary *dict, struct xz_buf *b, uint32_t *left)
{
 size_t copy_size;
 while (*left > 0 && b->in_pos < b->in_size
   && b->out_pos < b->out_size) {
  copy_size = ((b->in_size - b->in_pos) < (b->out_size - b->out_pos) ? (b->in_size - b->in_pos) : (b->out_size - b->out_pos));
  if (copy_size > dict->end - dict->pos)
   copy_size = dict->end - dict->pos;
  if (copy_size > *left)
   copy_size = *left;
  *left -= copy_size;
  memcpy(dict->buf + dict->pos, b->in + b->in_pos, copy_size);
  dict->pos += copy_size;
  if (dict->full < dict->pos)
   dict->full = dict->pos;
  if (((dict->mode) != XZ_SINGLE)) {
   if (dict->pos == dict->end)
    dict->pos = 0;
   memcpy(b->out + b->out_pos, b->in + b->in_pos,
     copy_size);
  }
  dict->start = dict->pos;
  b->out_pos += copy_size;
  b->in_pos += copy_size;
 }
}
static uint32_t dict_flush(struct dictionary *dict, struct xz_buf *b)
{
 size_t copy_size = dict->pos - dict->start;
 if (((dict->mode) != XZ_SINGLE)) {
  if (dict->pos == dict->end)
   dict->pos = 0;
  memcpy(b->out + b->out_pos, dict->buf + dict->start,
    copy_size);
 }
 dict->start = dict->pos;
 b->out_pos += copy_size;
 return copy_size;
}
static void rc_reset(struct rc_dec *rc)
{
 rc->range = (uint32_t)-1;
 rc->code = 0;
 rc->init_bytes_left = 5;
}
static _Bool rc_read_init(struct rc_dec *rc, struct xz_buf *b)
{
 while (rc->init_bytes_left > 0) {
  if (b->in_pos == b->in_size)
   return 0;
  rc->code = (rc->code << 8) + b->in[b->in_pos++];
  --rc->init_bytes_left;
 }
 return 1;
}
static inline _Bool rc_limit_exceeded(const struct rc_dec *rc)
{
 return rc->in_pos > rc->in_limit;
}
static inline _Bool rc_is_finished(const struct rc_dec *rc)
{
 return rc->code == 0;
}
static __inline __attribute__ ((__always_inline__)) void rc_normalize(struct rc_dec *rc)
{
 if (rc->range < (1 << 24)) {
  rc->range <<= 8;
  rc->code = (rc->code << 8) + rc->in[rc->in_pos++];
 }
}
static __inline __attribute__ ((__always_inline__)) int rc_bit(struct rc_dec *rc, uint16_t *prob)
{
 uint32_t bound;
 int bit;
 rc_normalize(rc);
 bound = (rc->range >> 11) * *prob;
 if (rc->code < bound) {
  rc->range = bound;
  *prob += ((1 << 11) - *prob) >> 5;
  bit = 0;
 } else {
  rc->range -= bound;
  rc->code -= bound;
  *prob -= *prob >> 5;
  bit = 1;
 }
 return bit;
}
static __inline __attribute__ ((__always_inline__)) uint32_t rc_bittree(
  struct rc_dec *rc, uint16_t *probs, uint32_t limit)
{
 uint32_t symbol = 1;
 do {
  if (rc_bit(rc, &probs[symbol]))
   symbol = (symbol << 1) + 1;
  else
   symbol <<= 1;
 } while (symbol < limit);
 return symbol;
}
static __inline __attribute__ ((__always_inline__)) void rc_bittree_reverse(struct rc_dec *rc,
  uint16_t *probs, uint32_t *dest, uint32_t limit)
{
 uint32_t symbol = 1;
 uint32_t i = 0;
 do {
  if (rc_bit(rc, &probs[symbol])) {
   symbol = (symbol << 1) + 1;
   *dest += 1 << i;
  } else {
   symbol <<= 1;
  }
 } while (++i < limit);
}
static inline void rc_direct(
  struct rc_dec *rc, uint32_t *dest, uint32_t limit)
{
 uint32_t mask;
 do {
  rc_normalize(rc);
  rc->range >>= 1;
  rc->code -= rc->range;
  mask = (uint32_t)0 - (rc->code >> 31);
  rc->code += rc->range & mask;
  *dest = (*dest << 1) + (mask + 1);
 } while (--limit > 0);
}
static uint16_t * lzma_literal_probs(struct xz_dec_lzma2 *s)
{
 uint32_t prev_byte = dict_get(&s->dict, 0);
 uint32_t low = prev_byte >> (8 - s->lzma.lc);
 uint32_t high = (s->dict.pos & s->lzma.literal_pos_mask) << s->lzma.lc;
 return s->lzma.literal[low + high];
}
static void lzma_literal(struct xz_dec_lzma2 *s)
{
 uint16_t *probs;
 uint32_t symbol;
 uint32_t match_byte;
 uint32_t match_bit;
 uint32_t offset;
 uint32_t i;
 probs = lzma_literal_probs(s);
 if (lzma_state_is_literal(s->lzma.state)) {
  symbol = rc_bittree(&s->rc, probs, 0x100);
 } else {
  symbol = 1;
  match_byte = dict_get(&s->dict, s->lzma.rep0) << 1;
  offset = 0x100;
  do {
   match_bit = match_byte & offset;
   match_byte <<= 1;
   i = offset + match_bit + symbol;
   if (rc_bit(&s->rc, &probs[i])) {
    symbol = (symbol << 1) + 1;
    offset &= match_bit;
   } else {
    symbol <<= 1;
    offset &= ~match_bit;
   }
  } while (symbol < 0x100);
 }
 dict_put(&s->dict, (uint8_t)symbol);
 lzma_state_literal(&s->lzma.state);
}
static void lzma_len(struct xz_dec_lzma2 *s, struct lzma_len_dec *l,
  uint32_t pos_state)
{
 uint16_t *probs;
 uint32_t limit;
 if (!rc_bit(&s->rc, &l->choice)) {
  probs = l->low[pos_state];
  limit = (1 << 3);
  s->lzma.len = 2;
 } else {
  if (!rc_bit(&s->rc, &l->choice2)) {
   probs = l->mid[pos_state];
   limit = (1 << 3);
   s->lzma.len = 2 + (1 << 3);
  } else {
   probs = l->high;
   limit = (1 << 8);
   s->lzma.len = 2 + (1 << 3)
     + (1 << 3);
  }
 }
 s->lzma.len += rc_bittree(&s->rc, probs, limit) - limit;
}
static void lzma_match(struct xz_dec_lzma2 *s, uint32_t pos_state)
{
 uint16_t *probs;
 uint32_t dist_slot;
 uint32_t limit;
 lzma_state_match(&s->lzma.state);
 s->lzma.rep3 = s->lzma.rep2;
 s->lzma.rep2 = s->lzma.rep1;
 s->lzma.rep1 = s->lzma.rep0;
 lzma_len(s, &s->lzma.match_len_dec, pos_state);
 probs = s->lzma.dist_slot[lzma_get_dist_state(s->lzma.len)];
 dist_slot = rc_bittree(&s->rc, probs, (1 << 6)) - (1 << 6);
 if (dist_slot < 4) {
  s->lzma.rep0 = dist_slot;
 } else {
  limit = (dist_slot >> 1) - 1;
  s->lzma.rep0 = 2 + (dist_slot & 1);
  if (dist_slot < 14) {
   s->lzma.rep0 <<= limit;
   probs = s->lzma.dist_special + s->lzma.rep0
     - dist_slot - 1;
   rc_bittree_reverse(&s->rc, probs,
     &s->lzma.rep0, limit);
  } else {
   rc_direct(&s->rc, &s->lzma.rep0, limit - 4);
   s->lzma.rep0 <<= 4;
   rc_bittree_reverse(&s->rc, s->lzma.dist_align,
     &s->lzma.rep0, 4);
  }
 }
}
static void lzma_rep_match(struct xz_dec_lzma2 *s, uint32_t pos_state)
{
 uint32_t tmp;
 if (!rc_bit(&s->rc, &s->lzma.is_rep0[s->lzma.state])) {
  if (!rc_bit(&s->rc, &s->lzma.is_rep0_long[
    s->lzma.state][pos_state])) {
   lzma_state_short_rep(&s->lzma.state);
   s->lzma.len = 1;
   return;
  }
 } else {
  if (!rc_bit(&s->rc, &s->lzma.is_rep1[s->lzma.state])) {
   tmp = s->lzma.rep1;
  } else {
   if (!rc_bit(&s->rc, &s->lzma.is_rep2[s->lzma.state])) {
    tmp = s->lzma.rep2;
   } else {
    tmp = s->lzma.rep3;
    s->lzma.rep3 = s->lzma.rep2;
   }
   s->lzma.rep2 = s->lzma.rep1;
  }
  s->lzma.rep1 = s->lzma.rep0;
  s->lzma.rep0 = tmp;
 }
 lzma_state_long_rep(&s->lzma.state);
 lzma_len(s, &s->lzma.rep_len_dec, pos_state);
}
static _Bool lzma_main(struct xz_dec_lzma2 *s)
{
 uint32_t pos_state;
 if (dict_has_space(&s->dict) && s->lzma.len > 0)
  dict_repeat(&s->dict, &s->lzma.len, s->lzma.rep0);
 while (dict_has_space(&s->dict) && !rc_limit_exceeded(&s->rc)) {
  pos_state = s->dict.pos & s->lzma.pos_mask;
  if (!rc_bit(&s->rc, &s->lzma.is_match[
    s->lzma.state][pos_state])) {
   lzma_literal(s);
  } else {
   if (rc_bit(&s->rc, &s->lzma.is_rep[s->lzma.state]))
    lzma_rep_match(s, pos_state);
   else
    lzma_match(s, pos_state);
   if (!dict_repeat(&s->dict, &s->lzma.len, s->lzma.rep0))
    return 0;
  }
 }
 rc_normalize(&s->rc);
 return 1;
}
static void lzma_reset(struct xz_dec_lzma2 *s)
{
 uint16_t *probs;
 size_t i;
 s->lzma.state = STATE_LIT_LIT;
 s->lzma.rep0 = 0;
 s->lzma.rep1 = 0;
 s->lzma.rep2 = 0;
 s->lzma.rep3 = 0;
 probs = s->lzma.is_match[0];
 for (i = 0; i < (1846 + (1 << 4) * 0x300); ++i)
  probs[i] = (1 << 11) / 2;
 rc_reset(&s->rc);
}
static _Bool lzma_props(struct xz_dec_lzma2 *s, uint8_t props)
{
 if (props > (4 * 5 + 4) * 9 + 8)
  return 0;
 s->lzma.pos_mask = 0;
 while (props >= 9 * 5) {
  props -= 9 * 5;
  ++s->lzma.pos_mask;
 }
 s->lzma.pos_mask = (1 << s->lzma.pos_mask) - 1;
 s->lzma.literal_pos_mask = 0;
 while (props >= 9) {
  props -= 9;
  ++s->lzma.literal_pos_mask;
 }
 s->lzma.lc = props;
 if (s->lzma.lc + s->lzma.literal_pos_mask > 4)
  return 0;
 s->lzma.literal_pos_mask = (1 << s->lzma.literal_pos_mask) - 1;
 lzma_reset(s);
 return 1;
}
static _Bool lzma2_lzma(struct xz_dec_lzma2 *s, struct xz_buf *b)
{
 size_t in_avail;
 uint32_t tmp;
 in_avail = b->in_size - b->in_pos;
 if (s->temp.size > 0 || s->lzma2.compressed == 0) {
  tmp = 2 * 21 - s->temp.size;
  if (tmp > s->lzma2.compressed - s->temp.size)
   tmp = s->lzma2.compressed - s->temp.size;
  if (tmp > in_avail)
   tmp = in_avail;
  memcpy(s->temp.buf + s->temp.size, b->in + b->in_pos, tmp);
  if (s->temp.size + tmp == s->lzma2.compressed) {
   memset(s->temp.buf + s->temp.size + tmp, 0, sizeof(s->temp.buf) - s->temp.size - tmp);
   s->rc.in_limit = s->temp.size + tmp;
  } else if (s->temp.size + tmp < 21) {
   s->temp.size += tmp;
   b->in_pos += tmp;
   return 1;
  } else {
   s->rc.in_limit = s->temp.size + tmp - 21;
  }
  s->rc.in = s->temp.buf;
  s->rc.in_pos = 0;
  if (!lzma_main(s) || s->rc.in_pos > s->temp.size + tmp)
   return 0;
  s->lzma2.compressed -= s->rc.in_pos;
  if (s->rc.in_pos < s->temp.size) {
   s->temp.size -= s->rc.in_pos;
   memmove(s->temp.buf, s->temp.buf + s->rc.in_pos,
     s->temp.size);
   return 1;
  }
  b->in_pos += s->rc.in_pos - s->temp.size;
  s->temp.size = 0;
 }
 in_avail = b->in_size - b->in_pos;
 if (in_avail >= 21) {
  s->rc.in = b->in;
  s->rc.in_pos = b->in_pos;
  if (in_avail >= s->lzma2.compressed + 21)
   s->rc.in_limit = b->in_pos + s->lzma2.compressed;
  else
   s->rc.in_limit = b->in_size - 21;
  if (!lzma_main(s))
   return 0;
  in_avail = s->rc.in_pos - b->in_pos;
  if (in_avail > s->lzma2.compressed)
   return 0;
  s->lzma2.compressed -= in_avail;
  b->in_pos = s->rc.in_pos;
 }
 in_avail = b->in_size - b->in_pos;
 if (in_avail < 21) {
  if (in_avail > s->lzma2.compressed)
   in_avail = s->lzma2.compressed;
  memcpy(s->temp.buf, b->in + b->in_pos, in_avail);
  s->temp.size = in_avail;
  b->in_pos += in_avail;
 }
 return 1;
}
extern NOINLINE enum xz_ret xz_dec_lzma2_run(
  struct xz_dec_lzma2 *s, struct xz_buf *b)
{
 uint32_t tmp;
 while (b->in_pos < b->in_size || s->lzma2.sequence == SEQ_LZMA_RUN) {
  switch (s->lzma2.sequence) {
  case SEQ_CONTROL:
   tmp = b->in[b->in_pos++];
   if (tmp >= 0xE0 || tmp == 0x01) {
    s->lzma2.need_props = 1;
    s->lzma2.need_dict_reset = 0;
    dict_reset(&s->dict, b);
   } else if (s->lzma2.need_dict_reset) {
    return XZ_DATA_ERROR;
   }
   if (tmp >= 0x80) {
    s->lzma2.uncompressed = (tmp & 0x1F) << 16;
    s->lzma2.sequence = SEQ_UNCOMPRESSED_1;
    if (tmp >= 0xC0) {
     s->lzma2.need_props = 0;
     s->lzma2.next_sequence
       = SEQ_PROPERTIES;
    } else if (s->lzma2.need_props) {
     return XZ_DATA_ERROR;
    } else {
     s->lzma2.next_sequence
       = SEQ_LZMA_PREPARE;
     if (tmp >= 0xA0)
      lzma_reset(s);
    }
   } else {
    if (tmp == 0x00)
     return XZ_STREAM_END;
    if (tmp > 0x02)
     return XZ_DATA_ERROR;
    s->lzma2.sequence = SEQ_COMPRESSED_0;
    s->lzma2.next_sequence = SEQ_COPY;
   }
   break;
  case SEQ_UNCOMPRESSED_1:
   s->lzma2.uncompressed
     += (uint32_t)b->in[b->in_pos++] << 8;
   s->lzma2.sequence = SEQ_UNCOMPRESSED_2;
   break;
  case SEQ_UNCOMPRESSED_2:
   s->lzma2.uncompressed
     += (uint32_t)b->in[b->in_pos++] + 1;
   s->lzma2.sequence = SEQ_COMPRESSED_0;
   break;
  case SEQ_COMPRESSED_0:
   s->lzma2.compressed
     = (uint32_t)b->in[b->in_pos++] << 8;
   s->lzma2.sequence = SEQ_COMPRESSED_1;
   break;
  case SEQ_COMPRESSED_1:
   s->lzma2.compressed
     += (uint32_t)b->in[b->in_pos++] + 1;
   s->lzma2.sequence = s->lzma2.next_sequence;
   break;
  case SEQ_PROPERTIES:
   if (!lzma_props(s, b->in[b->in_pos++]))
    return XZ_DATA_ERROR;
   s->lzma2.sequence = SEQ_LZMA_PREPARE;
  case SEQ_LZMA_PREPARE:
   if (s->lzma2.compressed < 5)
    return XZ_DATA_ERROR;
   if (!rc_read_init(&s->rc, b))
    return XZ_OK;
   s->lzma2.compressed -= 5;
   s->lzma2.sequence = SEQ_LZMA_RUN;
  case SEQ_LZMA_RUN:
   dict_limit(&s->dict, ((b->out_size - b->out_pos) < (s->lzma2.uncompressed) ? (b->out_size - b->out_pos) : (s->lzma2.uncompressed)));
   if (!lzma2_lzma(s, b))
    return XZ_DATA_ERROR;
   s->lzma2.uncompressed -= dict_flush(&s->dict, b);
   if (s->lzma2.uncompressed == 0) {
    if (s->lzma2.compressed > 0 || s->lzma.len > 0
      || !rc_is_finished(&s->rc))
     return XZ_DATA_ERROR;
    rc_reset(&s->rc);
    s->lzma2.sequence = SEQ_CONTROL;
   } else if (b->out_pos == b->out_size
     || (b->in_pos == b->in_size
      && s->temp.size
      < s->lzma2.compressed)) {
    return XZ_OK;
   }
   break;
  case SEQ_COPY:
   dict_uncompressed(&s->dict, b, &s->lzma2.compressed);
   if (s->lzma2.compressed > 0)
    return XZ_OK;
   s->lzma2.sequence = SEQ_CONTROL;
   break;
  }
 }
 return XZ_OK;
}
extern struct xz_dec_lzma2 * xz_dec_lzma2_create(
  enum xz_mode mode, uint32_t dict_max)
{
 struct xz_dec_lzma2 *s = malloc(sizeof(*s));
 if (s == ((void *)0))
  return ((void *)0);
 s->dict.mode = mode;
 s->dict.size_max = dict_max;
 if (((mode) == XZ_PREALLOC)) {
  s->dict.buf = malloc(dict_max);
  if (s->dict.buf == ((void *)0)) {
   free(s);
   return ((void *)0);
  }
 } else if (((mode) == XZ_DYNALLOC)) {
  s->dict.buf = ((void *)0);
  s->dict.allocated = 0;
 }
 return s;
}
extern enum xz_ret xz_dec_lzma2_reset(
  struct xz_dec_lzma2 *s, uint8_t props)
{
 if (props > 39)
  return XZ_OPTIONS_ERROR;
 s->dict.size = 2 + (props & 1);
 s->dict.size <<= (props >> 1) + 11;
 if (((s->dict.mode) != XZ_SINGLE)) {
  if (s->dict.size > s->dict.size_max)
   return XZ_MEMLIMIT_ERROR;
  s->dict.end = s->dict.size;
  if (((s->dict.mode) == XZ_DYNALLOC)) {
   if (s->dict.allocated < s->dict.size) {
    free(s->dict.buf);
    s->dict.buf = malloc(s->dict.size);
    if (s->dict.buf == ((void *)0)) {
     s->dict.allocated = 0;
     return XZ_MEM_ERROR;
    }
   }
  }
 }
 s->lzma.len = 0;
 s->lzma2.sequence = SEQ_CONTROL;
 s->lzma2.need_dict_reset = 1;
 s->temp.size = 0;
 return XZ_OK;
}
extern void xz_dec_lzma2_end(struct xz_dec_lzma2 *s)
{
 if (((s->dict.mode) != XZ_SINGLE))
  free(s->dict.buf);
 free(s);
}
