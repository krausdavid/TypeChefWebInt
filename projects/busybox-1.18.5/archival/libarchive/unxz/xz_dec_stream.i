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
typedef uint64_t vli_type;
enum xz_check {
 XZ_CHECK_NONE = 0,
 XZ_CHECK_CRC32 = 1,
 XZ_CHECK_CRC64 = 4,
 XZ_CHECK_SHA256 = 10
};
struct xz_dec_hash {
 vli_type unpadded;
 vli_type uncompressed;
 uint32_t crc32;
};
struct xz_dec {
 enum {
  SEQ_STREAM_HEADER,
  SEQ_BLOCK_START,
  SEQ_BLOCK_HEADER,
  SEQ_BLOCK_UNCOMPRESS,
  SEQ_BLOCK_PADDING,
  SEQ_BLOCK_CHECK,
  SEQ_INDEX,
  SEQ_INDEX_PADDING,
  SEQ_INDEX_CRC32,
  SEQ_STREAM_FOOTER
 } sequence;
 uint32_t pos;
 vli_type vli;
 size_t in_start;
 size_t out_start;
 uint32_t crc32;
 enum xz_check check_type;
 enum xz_mode mode;
 _Bool allow_buf_error;
 struct {
  vli_type compressed;
  vli_type uncompressed;
  uint32_t size;
 } block_header;
 struct {
  vli_type compressed;
  vli_type uncompressed;
  vli_type count;
  struct xz_dec_hash hash;
 } block;
 struct {
  enum {
   SEQ_INDEX_COUNT,
   SEQ_INDEX_UNPADDED,
   SEQ_INDEX_UNCOMPRESSED
  } sequence;
  vli_type size;
  vli_type count;
  struct xz_dec_hash hash;
 } index;
 struct {
  size_t pos;
  size_t size;
  uint8_t buf[1024];
 } temp;
 struct xz_dec_lzma2 *lzma2;
};
static _Bool fill_temp(struct xz_dec *s, struct xz_buf *b)
{
 size_t copy_size = ((b->in_size - b->in_pos) < (s->temp.size - s->temp.pos) ? (b->in_size - b->in_pos) : (s->temp.size - s->temp.pos));
 memcpy(s->temp.buf + s->temp.pos, b->in + b->in_pos, copy_size);
 b->in_pos += copy_size;
 s->temp.pos += copy_size;
 if (s->temp.pos == s->temp.size) {
  s->temp.pos = 0;
  return 1;
 }
 return 0;
}
static enum xz_ret dec_vli(struct xz_dec *s,
  const uint8_t *in, size_t *in_pos, size_t in_size)
{
 uint8_t byte;
 if (s->pos == 0)
  s->vli = 0;
 while (*in_pos < in_size) {
  byte = in[*in_pos];
  ++*in_pos;
  s->vli |= (vli_type)(byte & 0x7F) << s->pos;
  if ((byte & 0x80) == 0) {
   if (byte == 0 && s->pos != 0)
    return XZ_DATA_ERROR;
   s->pos = 0;
   return XZ_STREAM_END;
  }
  s->pos += 7;
  if (s->pos == 7 * (sizeof(vli_type) * 8 / 7))
   return XZ_DATA_ERROR;
 }
 return XZ_OK;
}
static enum xz_ret dec_block(struct xz_dec *s, struct xz_buf *b)
{
 enum xz_ret ret;
 s->in_start = b->in_pos;
 s->out_start = b->out_pos;
  ret = xz_dec_lzma2_run(s->lzma2, b);
 s->block.compressed += b->in_pos - s->in_start;
 s->block.uncompressed += b->out_pos - s->out_start;
 if (s->block.compressed > s->block_header.compressed
   || s->block.uncompressed
    > s->block_header.uncompressed)
  return XZ_DATA_ERROR;
 if (s->check_type == XZ_CHECK_CRC32)
  s->crc32 = xz_crc32(b->out + s->out_start,
    b->out_pos - s->out_start, s->crc32);
 if (ret == XZ_STREAM_END) {
  if (s->block_header.compressed != ((vli_type)-1)
    && s->block_header.compressed
     != s->block.compressed)
   return XZ_DATA_ERROR;
  if (s->block_header.uncompressed != ((vli_type)-1)
    && s->block_header.uncompressed
     != s->block.uncompressed)
   return XZ_DATA_ERROR;
  s->block.hash.unpadded += s->block_header.size
    + s->block.compressed;
  if (s->check_type == XZ_CHECK_CRC32)
   s->block.hash.unpadded += 4;
  s->block.hash.uncompressed += s->block.uncompressed;
  s->block.hash.crc32 = xz_crc32(
    (const uint8_t *)&s->block.hash,
    sizeof(s->block.hash), s->block.hash.crc32);
  ++s->block.count;
 }
 return ret;
}
static void index_update(struct xz_dec *s, const struct xz_buf *b)
{
 size_t in_used = b->in_pos - s->in_start;
 s->index.size += in_used;
 s->crc32 = xz_crc32(b->in + s->in_start, in_used, s->crc32);
}
static enum xz_ret dec_index(struct xz_dec *s, struct xz_buf *b)
{
 enum xz_ret ret;
 do {
  ret = dec_vli(s, b->in, &b->in_pos, b->in_size);
  if (ret != XZ_STREAM_END) {
   index_update(s, b);
   return ret;
  }
  switch (s->index.sequence) {
  case SEQ_INDEX_COUNT:
   s->index.count = s->vli;
   if (s->index.count != s->block.count)
    return XZ_DATA_ERROR;
   s->index.sequence = SEQ_INDEX_UNPADDED;
   break;
  case SEQ_INDEX_UNPADDED:
   s->index.hash.unpadded += s->vli;
   s->index.sequence = SEQ_INDEX_UNCOMPRESSED;
   break;
  case SEQ_INDEX_UNCOMPRESSED:
   s->index.hash.uncompressed += s->vli;
   s->index.hash.crc32 = xz_crc32(
     (const uint8_t *)&s->index.hash,
     sizeof(s->index.hash),
     s->index.hash.crc32);
   --s->index.count;
   s->index.sequence = SEQ_INDEX_UNPADDED;
   break;
  }
 } while (s->index.count > 0);
 return XZ_STREAM_END;
}
static enum xz_ret crc32_validate(struct xz_dec *s, struct xz_buf *b)
{
 do {
  if (b->in_pos == b->in_size)
   return XZ_OK;
  if (((s->crc32 >> s->pos) & 0xFF) != b->in[b->in_pos++])
   return XZ_DATA_ERROR;
  s->pos += 8;
 } while (s->pos < 32);
 s->crc32 = 0;
 s->pos = 0;
 return XZ_STREAM_END;
}
static enum xz_ret dec_stream_header(struct xz_dec *s)
{
 if (!(memcmp(s->temp.buf, "\3757zXZ\0", 6) == 0))
  return XZ_FORMAT_ERROR;
 if (xz_crc32(s->temp.buf + 6, 2, 0)
   != get_unaligned_le32(s->temp.buf + 6 + 2))
  return XZ_DATA_ERROR;
 if (s->temp.buf[6] != 0)
  return XZ_OPTIONS_ERROR;
 s->check_type = s->temp.buf[6 + 1];
 if (s->check_type > XZ_CHECK_CRC32)
  return XZ_OPTIONS_ERROR;
 return XZ_OK;
}
static enum xz_ret dec_stream_footer(struct xz_dec *s)
{
 if (!(memcmp(s->temp.buf + 10, "YZ", 2) == 0))
  return XZ_DATA_ERROR;
 if (xz_crc32(s->temp.buf + 4, 6, 0) != get_unaligned_le32(s->temp.buf))
  return XZ_DATA_ERROR;
 if ((s->index.size >> 2) != get_unaligned_le32(s->temp.buf + 4))
  return XZ_DATA_ERROR;
 if (s->temp.buf[8] != 0 || s->temp.buf[9] != s->check_type)
  return XZ_DATA_ERROR;
 return XZ_STREAM_END;
}
static enum xz_ret dec_block_header(struct xz_dec *s)
{
 enum xz_ret ret;
 s->temp.size -= 4;
 if (xz_crc32(s->temp.buf, s->temp.size, 0)
   != get_unaligned_le32(s->temp.buf + s->temp.size))
  return XZ_DATA_ERROR;
 s->temp.pos = 2;
 if (s->temp.buf[1] & 0x3F)
  return XZ_OPTIONS_ERROR;
 if (s->temp.buf[1] & 0x40) {
  if (dec_vli(s, s->temp.buf, &s->temp.pos, s->temp.size)
     != XZ_STREAM_END)
   return XZ_DATA_ERROR;
  s->block_header.compressed = s->vli;
 } else {
  s->block_header.compressed = ((vli_type)-1);
 }
 if (s->temp.buf[1] & 0x80) {
  if (dec_vli(s, s->temp.buf, &s->temp.pos, s->temp.size)
    != XZ_STREAM_END)
   return XZ_DATA_ERROR;
  s->block_header.uncompressed = s->vli;
 } else {
  s->block_header.uncompressed = ((vli_type)-1);
 }
 if (s->temp.size - s->temp.pos < 2)
  return XZ_DATA_ERROR;
 if (s->temp.buf[s->temp.pos++] != 0x21)
  return XZ_OPTIONS_ERROR;
 if (s->temp.buf[s->temp.pos++] != 0x01)
  return XZ_OPTIONS_ERROR;
 if (s->temp.size - s->temp.pos < 1)
  return XZ_DATA_ERROR;
 ret = xz_dec_lzma2_reset(s->lzma2, s->temp.buf[s->temp.pos++]);
 if (ret != XZ_OK)
  return ret;
 while (s->temp.pos < s->temp.size)
  if (s->temp.buf[s->temp.pos++] != 0x00)
   return XZ_OPTIONS_ERROR;
 s->temp.pos = 0;
 s->block.compressed = 0;
 s->block.uncompressed = 0;
 return XZ_OK;
}
static enum xz_ret dec_main(struct xz_dec *s, struct xz_buf *b)
{
 enum xz_ret ret;
 s->in_start = b->in_pos;
 while (1) {
  switch (s->sequence) {
  case SEQ_STREAM_HEADER:
   if (!fill_temp(s, b))
    return XZ_OK;
   s->sequence = SEQ_BLOCK_START;
   ret = dec_stream_header(s);
   if (ret != XZ_OK)
    return ret;
  case SEQ_BLOCK_START:
   if (b->in_pos == b->in_size)
    return XZ_OK;
   if (b->in[b->in_pos] == 0) {
    s->in_start = b->in_pos++;
    s->sequence = SEQ_INDEX;
    break;
   }
   s->block_header.size
    = ((uint32_t)b->in[b->in_pos] + 1) * 4;
   s->temp.size = s->block_header.size;
   s->temp.pos = 0;
   s->sequence = SEQ_BLOCK_HEADER;
  case SEQ_BLOCK_HEADER:
   if (!fill_temp(s, b))
    return XZ_OK;
   ret = dec_block_header(s);
   if (ret != XZ_OK)
    return ret;
   s->sequence = SEQ_BLOCK_UNCOMPRESS;
  case SEQ_BLOCK_UNCOMPRESS:
   ret = dec_block(s, b);
   if (ret != XZ_STREAM_END)
    return ret;
   s->sequence = SEQ_BLOCK_PADDING;
  case SEQ_BLOCK_PADDING:
   while (s->block.compressed & 3) {
    if (b->in_pos == b->in_size)
     return XZ_OK;
    if (b->in[b->in_pos++] != 0)
     return XZ_DATA_ERROR;
    ++s->block.compressed;
   }
   s->sequence = SEQ_BLOCK_CHECK;
  case SEQ_BLOCK_CHECK:
   if (s->check_type == XZ_CHECK_CRC32) {
    ret = crc32_validate(s, b);
    if (ret != XZ_STREAM_END)
     return ret;
   }
   s->sequence = SEQ_BLOCK_START;
   break;
  case SEQ_INDEX:
   ret = dec_index(s, b);
   if (ret != XZ_STREAM_END)
    return ret;
   s->sequence = SEQ_INDEX_PADDING;
  case SEQ_INDEX_PADDING:
   while ((s->index.size + (b->in_pos - s->in_start))
     & 3) {
    if (b->in_pos == b->in_size) {
     index_update(s, b);
     return XZ_OK;
    }
    if (b->in[b->in_pos++] != 0)
     return XZ_DATA_ERROR;
   }
   index_update(s, b);
   if (!(memcmp(&s->block.hash, &s->index.hash, sizeof(s->block.hash)) == 0))
    return XZ_DATA_ERROR;
   s->sequence = SEQ_INDEX_CRC32;
  case SEQ_INDEX_CRC32:
   ret = crc32_validate(s, b);
   if (ret != XZ_STREAM_END)
    return ret;
   s->temp.size = 12;
   s->sequence = SEQ_STREAM_FOOTER;
  case SEQ_STREAM_FOOTER:
   if (!fill_temp(s, b))
    return XZ_OK;
   return dec_stream_footer(s);
  }
 }
}
extern enum xz_ret xz_dec_run(struct xz_dec *s, struct xz_buf *b)
{
 size_t in_start;
 size_t out_start;
 enum xz_ret ret;
 if (((s->mode) == XZ_SINGLE))
  xz_dec_reset(s);
 in_start = b->in_pos;
 out_start = b->out_pos;
 ret = dec_main(s, b);
 if (((s->mode) == XZ_SINGLE)) {
  if (ret == XZ_OK)
   ret = b->in_pos == b->in_size
     ? XZ_DATA_ERROR : XZ_BUF_ERROR;
  if (ret != XZ_STREAM_END) {
   b->in_pos = in_start;
   b->out_pos = out_start;
  }
 } else if (ret == XZ_OK && in_start == b->in_pos
   && out_start == b->out_pos) {
  if (s->allow_buf_error)
   ret = XZ_BUF_ERROR;
  s->allow_buf_error = 1;
 } else {
  s->allow_buf_error = 0;
 }
 return ret;
}
extern struct xz_dec * xz_dec_init(
  enum xz_mode mode, uint32_t dict_max)
{
 struct xz_dec *s = malloc(sizeof(*s));
 if (s == ((void *)0))
  return ((void *)0);
 s->mode = mode;
 s->lzma2 = xz_dec_lzma2_create(mode, dict_max);
 if (s->lzma2 == ((void *)0))
  goto error_lzma2;
 xz_dec_reset(s);
 return s;
error_lzma2:
 free(s);
 return ((void *)0);
}
extern void xz_dec_reset(struct xz_dec *s)
{
 s->sequence = SEQ_STREAM_HEADER;
 s->allow_buf_error = 0;
 s->pos = 0;
 s->crc32 = 0;
 memset(&s->block, 0, sizeof(s->block));
 memset(&s->index, 0, sizeof(s->index));
 s->temp.pos = 0;
 s->temp.size = 12;
}
extern void xz_dec_end(struct xz_dec *s)
{
 if (s != ((void *)0)) {
  xz_dec_lzma2_end(s->lzma2);
  free(s);
 }
}
