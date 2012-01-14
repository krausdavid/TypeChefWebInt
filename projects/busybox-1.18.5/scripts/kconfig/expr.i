
typedef long unsigned int size_t;
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
struct _IO_FILE;

typedef struct _IO_FILE FILE;









typedef struct _IO_FILE __FILE;
typedef struct
{
  int __count;
  union
  {
    unsigned int __wch;
    char __wchb[4];
  } __value;
} __mbstate_t;
typedef struct
{
  __off_t __pos;
  __mbstate_t __state;
} _G_fpos_t;
typedef struct
{
  __off64_t __pos;
  __mbstate_t __state;
} _G_fpos64_t;
typedef int _G_int16_t __attribute__ ((__mode__ (__HI__)));
typedef int _G_int32_t __attribute__ ((__mode__ (__SI__)));
typedef unsigned int _G_uint16_t __attribute__ ((__mode__ (__HI__)));
typedef unsigned int _G_uint32_t __attribute__ ((__mode__ (__SI__)));
typedef __builtin_va_list __gnuc_va_list;
struct _IO_jump_t; struct _IO_FILE;
typedef void _IO_lock_t;
struct _IO_marker {
  struct _IO_marker *_next;
  struct _IO_FILE *_sbuf;
  int _pos;
};
enum __codecvt_result
{
  __codecvt_ok,
  __codecvt_partial,
  __codecvt_error,
  __codecvt_noconv
};
struct _IO_FILE {
  int _flags;
  char* _IO_read_ptr;
  char* _IO_read_end;
  char* _IO_read_base;
  char* _IO_write_base;
  char* _IO_write_ptr;
  char* _IO_write_end;
  char* _IO_buf_base;
  char* _IO_buf_end;
  char *_IO_save_base;
  char *_IO_backup_base;
  char *_IO_save_end;
  struct _IO_marker *_markers;
  struct _IO_FILE *_chain;
  int _fileno;
  int _flags2;
  __off_t _old_offset;
  unsigned short _cur_column;
  signed char _vtable_offset;
  char _shortbuf[1];
  _IO_lock_t *_lock;
  __off64_t _offset;
  void *__pad1;
  void *__pad2;
  void *__pad3;
  void *__pad4;
  size_t __pad5;
  int _mode;
  char _unused2[15 * sizeof (int) - 4 * sizeof (void *) - sizeof (size_t)];
};
typedef struct _IO_FILE _IO_FILE;
struct _IO_FILE_plus;
extern struct _IO_FILE_plus _IO_2_1_stdin_;
extern struct _IO_FILE_plus _IO_2_1_stdout_;
extern struct _IO_FILE_plus _IO_2_1_stderr_;
typedef __ssize_t __io_read_fn (void *__cookie, char *__buf, size_t __nbytes);
typedef __ssize_t __io_write_fn (void *__cookie, __const char *__buf,
     size_t __n);
typedef int __io_seek_fn (void *__cookie, __off64_t *__pos, int __w);
typedef int __io_close_fn (void *__cookie);
extern int __underflow (_IO_FILE *);
extern int __uflow (_IO_FILE *);
extern int __overflow (_IO_FILE *, int);
extern int _IO_getc (_IO_FILE *__fp);
extern int _IO_putc (int __c, _IO_FILE *__fp);
extern int _IO_feof (_IO_FILE *__fp) __attribute__ ((__nothrow__));
extern int _IO_ferror (_IO_FILE *__fp) __attribute__ ((__nothrow__));
extern int _IO_peekc_locked (_IO_FILE *__fp);
extern void _IO_flockfile (_IO_FILE *) __attribute__ ((__nothrow__));
extern void _IO_funlockfile (_IO_FILE *) __attribute__ ((__nothrow__));
extern int _IO_ftrylockfile (_IO_FILE *) __attribute__ ((__nothrow__));
extern int _IO_vfscanf (_IO_FILE * __restrict, const char * __restrict,
   __gnuc_va_list, int *__restrict);
extern int _IO_vfprintf (_IO_FILE *__restrict, const char *__restrict,
    __gnuc_va_list);
extern __ssize_t _IO_padn (_IO_FILE *, int, __ssize_t);
extern size_t _IO_sgetn (_IO_FILE *, void *, size_t);
extern __off64_t _IO_seekoff (_IO_FILE *, __off64_t, int, int);
extern __off64_t _IO_seekpos (_IO_FILE *, __off64_t, int);
extern void _IO_free_backup_area (_IO_FILE *) __attribute__ ((__nothrow__));
typedef __gnuc_va_list va_list;
typedef __off_t off_t;
typedef __ssize_t ssize_t;

typedef _G_fpos_t fpos_t;

extern struct _IO_FILE *stdin;
extern struct _IO_FILE *stdout;
extern struct _IO_FILE *stderr;



extern int remove (__const char *__filename) __attribute__ ((__nothrow__));

extern int rename (__const char *__old, __const char *__new) __attribute__ ((__nothrow__));




extern int renameat (int __oldfd, __const char *__old, int __newfd,
       __const char *__new) __attribute__ ((__nothrow__));








extern FILE *tmpfile (void) ;
extern char *tmpnam (char *__s) __attribute__ ((__nothrow__)) ;

extern char *tmpnam_r (char *__s) __attribute__ ((__nothrow__)) ;
extern char *tempnam (__const char *__dir, __const char *__pfx)
     __attribute__ ((__nothrow__)) __attribute__ ((__malloc__)) ;

extern int fclose (FILE *__stream);
extern int fflush (FILE *__stream);

extern int fflush_unlocked (FILE *__stream);

extern FILE *fopen (__const char *__restrict __filename,
      __const char *__restrict __modes) ;
extern FILE *freopen (__const char *__restrict __filename,
        __const char *__restrict __modes,
        FILE *__restrict __stream) ;

extern FILE *fdopen (int __fd, __const char *__modes) __attribute__ ((__nothrow__)) ;
extern FILE *fmemopen (void *__s, size_t __len, __const char *__modes)
  __attribute__ ((__nothrow__)) ;
extern FILE *open_memstream (char **__bufloc, size_t *__sizeloc) __attribute__ ((__nothrow__)) ;

extern void setbuf (FILE *__restrict __stream, char *__restrict __buf) __attribute__ ((__nothrow__));
extern int setvbuf (FILE *__restrict __stream, char *__restrict __buf,
      int __modes, size_t __n) __attribute__ ((__nothrow__));

extern void setbuffer (FILE *__restrict __stream, char *__restrict __buf,
         size_t __size) __attribute__ ((__nothrow__));
extern void setlinebuf (FILE *__stream) __attribute__ ((__nothrow__));

extern int fprintf (FILE *__restrict __stream,
      __const char *__restrict __format, ...);
extern int printf (__const char *__restrict __format, ...);
extern int sprintf (char *__restrict __s,
      __const char *__restrict __format, ...) __attribute__ ((__nothrow__));
extern int vfprintf (FILE *__restrict __s, __const char *__restrict __format,
       __gnuc_va_list __arg);
extern int vprintf (__const char *__restrict __format, __gnuc_va_list __arg);
extern int vsprintf (char *__restrict __s, __const char *__restrict __format,
       __gnuc_va_list __arg) __attribute__ ((__nothrow__));


extern int snprintf (char *__restrict __s, size_t __maxlen,
       __const char *__restrict __format, ...)
     __attribute__ ((__nothrow__)) __attribute__ ((__format__ (__printf__, 3, 4)));
extern int vsnprintf (char *__restrict __s, size_t __maxlen,
        __const char *__restrict __format, __gnuc_va_list __arg)
     __attribute__ ((__nothrow__)) __attribute__ ((__format__ (__printf__, 3, 0)));

extern int vdprintf (int __fd, __const char *__restrict __fmt,
       __gnuc_va_list __arg)
     __attribute__ ((__format__ (__printf__, 2, 0)));
extern int dprintf (int __fd, __const char *__restrict __fmt, ...)
     __attribute__ ((__format__ (__printf__, 2, 3)));

extern int fscanf (FILE *__restrict __stream,
     __const char *__restrict __format, ...) ;
extern int scanf (__const char *__restrict __format, ...) ;
extern int sscanf (__const char *__restrict __s,
     __const char *__restrict __format, ...) __attribute__ ((__nothrow__));
extern int fscanf (FILE *__restrict __stream, __const char *__restrict __format, ...) __asm__ ("" "__isoc99_fscanf") ;
extern int scanf (__const char *__restrict __format, ...) __asm__ ("" "__isoc99_scanf") ;
extern int sscanf (__const char *__restrict __s, __const char *__restrict __format, ...) __asm__ ("" "__isoc99_sscanf") __attribute__ ((__nothrow__));


extern int vfscanf (FILE *__restrict __s, __const char *__restrict __format,
      __gnuc_va_list __arg)
     __attribute__ ((__format__ (__scanf__, 2, 0))) ;
extern int vscanf (__const char *__restrict __format, __gnuc_va_list __arg)
     __attribute__ ((__format__ (__scanf__, 1, 0))) ;
extern int vsscanf (__const char *__restrict __s,
      __const char *__restrict __format, __gnuc_va_list __arg)
     __attribute__ ((__nothrow__)) __attribute__ ((__format__ (__scanf__, 2, 0)));
extern int vfscanf (FILE *__restrict __s, __const char *__restrict __format, __gnuc_va_list __arg) __asm__ ("" "__isoc99_vfscanf")
     __attribute__ ((__format__ (__scanf__, 2, 0))) ;
extern int vscanf (__const char *__restrict __format, __gnuc_va_list __arg) __asm__ ("" "__isoc99_vscanf")
     __attribute__ ((__format__ (__scanf__, 1, 0))) ;
extern int vsscanf (__const char *__restrict __s, __const char *__restrict __format, __gnuc_va_list __arg) __asm__ ("" "__isoc99_vsscanf") __attribute__ ((__nothrow__))
     __attribute__ ((__format__ (__scanf__, 2, 0)));


extern int fgetc (FILE *__stream);
extern int getc (FILE *__stream);
extern int getchar (void);

extern int getc_unlocked (FILE *__stream);
extern int getchar_unlocked (void);
extern int fgetc_unlocked (FILE *__stream);

extern int fputc (int __c, FILE *__stream);
extern int putc (int __c, FILE *__stream);
extern int putchar (int __c);

extern int fputc_unlocked (int __c, FILE *__stream);
extern int putc_unlocked (int __c, FILE *__stream);
extern int putchar_unlocked (int __c);
extern int getw (FILE *__stream);
extern int putw (int __w, FILE *__stream);

extern char *fgets (char *__restrict __s, int __n, FILE *__restrict __stream)
     ;
extern char *gets (char *__s) ;

extern __ssize_t __getdelim (char **__restrict __lineptr,
          size_t *__restrict __n, int __delimiter,
          FILE *__restrict __stream) ;
extern __ssize_t getdelim (char **__restrict __lineptr,
        size_t *__restrict __n, int __delimiter,
        FILE *__restrict __stream) ;
extern __ssize_t getline (char **__restrict __lineptr,
       size_t *__restrict __n,
       FILE *__restrict __stream) ;

extern int fputs (__const char *__restrict __s, FILE *__restrict __stream);
extern int puts (__const char *__s);
extern int ungetc (int __c, FILE *__stream);
extern size_t fread (void *__restrict __ptr, size_t __size,
       size_t __n, FILE *__restrict __stream) ;
extern size_t fwrite (__const void *__restrict __ptr, size_t __size,
        size_t __n, FILE *__restrict __s) ;

extern size_t fread_unlocked (void *__restrict __ptr, size_t __size,
         size_t __n, FILE *__restrict __stream) ;
extern size_t fwrite_unlocked (__const void *__restrict __ptr, size_t __size,
          size_t __n, FILE *__restrict __stream) ;

extern int fseek (FILE *__stream, long int __off, int __whence);
extern long int ftell (FILE *__stream) ;
extern void rewind (FILE *__stream);

extern int fseeko (FILE *__stream, __off_t __off, int __whence);
extern __off_t ftello (FILE *__stream) ;

extern int fgetpos (FILE *__restrict __stream, fpos_t *__restrict __pos);
extern int fsetpos (FILE *__stream, __const fpos_t *__pos);


extern void clearerr (FILE *__stream) __attribute__ ((__nothrow__));
extern int feof (FILE *__stream) __attribute__ ((__nothrow__)) ;
extern int ferror (FILE *__stream) __attribute__ ((__nothrow__)) ;

extern void clearerr_unlocked (FILE *__stream) __attribute__ ((__nothrow__));
extern int feof_unlocked (FILE *__stream) __attribute__ ((__nothrow__)) ;
extern int ferror_unlocked (FILE *__stream) __attribute__ ((__nothrow__)) ;

extern void perror (__const char *__s);

extern int sys_nerr;
extern __const char *__const sys_errlist[];
extern int fileno (FILE *__stream) __attribute__ ((__nothrow__)) ;
extern int fileno_unlocked (FILE *__stream) __attribute__ ((__nothrow__)) ;
extern FILE *popen (__const char *__command, __const char *__modes) ;
extern int pclose (FILE *__stream);
extern char *ctermid (char *__s) __attribute__ ((__nothrow__));
extern void flockfile (FILE *__stream) __attribute__ ((__nothrow__));
extern int ftrylockfile (FILE *__stream) __attribute__ ((__nothrow__)) ;
extern void funlockfile (FILE *__stream) __attribute__ ((__nothrow__));

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
typedef __pid_t pid_t;
typedef __id_t id_t;
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

struct file {
 struct file *next;
 struct file *parent;
 char *name;
 int lineno;
 int flags;
};
typedef enum tristate {
 no, mod, yes
} tristate;
enum expr_type {
 E_NONE, E_OR, E_AND, E_NOT, E_EQUAL, E_UNEQUAL, E_CHOICE, E_SYMBOL, E_RANGE
};
union expr_data {
 struct expr *expr;
 struct symbol *sym;
};
struct expr {
 enum expr_type type;
 union expr_data left, right;
};
struct expr_value {
 struct expr *expr;
 tristate tri;
};
struct symbol_value {
 void *val;
 tristate tri;
};
enum symbol_type {
 S_UNKNOWN, S_BOOLEAN, S_TRISTATE, S_INT, S_HEX, S_STRING, S_OTHER
};
struct symbol {
 struct symbol *next;
 char *name;
 char *help;
 enum symbol_type type;
 struct symbol_value curr, user;
 tristate visible;
 int flags;
 struct property *prop;
 struct expr *dep, *dep2;
 struct expr_value rev_dep;
};
enum prop_type {
 P_UNKNOWN, P_PROMPT, P_COMMENT, P_MENU, P_DEFAULT, P_CHOICE, P_SELECT, P_RANGE
};
struct property {
 struct property *next;
 struct symbol *sym;
 enum prop_type type;
 const char *text;
 struct expr_value visible;
 struct expr *expr;
 struct menu *menu;
 struct file *file;
 int lineno;
};
struct menu {
 struct menu *next;
 struct menu *parent;
 struct menu *list;
 struct symbol *sym;
 struct property *prompt;
 struct expr *dep;
 unsigned int flags;
 struct file *file;
 int lineno;
 void *data;
};
extern struct file *file_list;
extern struct file *current_file;
struct file *lookup_file(const char *name);
extern struct symbol symbol_yes, symbol_no, symbol_mod;
extern struct symbol *modules_sym;
extern int cdebug;
struct expr *expr_alloc_symbol(struct symbol *sym);
struct expr *expr_alloc_one(enum expr_type type, struct expr *ce);
struct expr *expr_alloc_two(enum expr_type type, struct expr *e1, struct expr *e2);
struct expr *expr_alloc_comp(enum expr_type type, struct symbol *s1, struct symbol *s2);
struct expr *expr_alloc_and(struct expr *e1, struct expr *e2);
struct expr *expr_alloc_or(struct expr *e1, struct expr *e2);
struct expr *expr_copy(struct expr *org);
void expr_free(struct expr *e);
int expr_eq(struct expr *e1, struct expr *e2);
void expr_eliminate_eq(struct expr **ep1, struct expr **ep2);
tristate expr_calc_value(struct expr *e);
struct expr *expr_eliminate_yn(struct expr *e);
struct expr *expr_trans_bool(struct expr *e);
struct expr *expr_eliminate_dups(struct expr *e);
struct expr *expr_transform(struct expr *e);
int expr_contains_symbol(struct expr *dep, struct symbol *sym);
_Bool expr_depends_symbol(struct expr *dep, struct symbol *sym);
struct expr *expr_extract_eq_and(struct expr **ep1, struct expr **ep2);
struct expr *expr_extract_eq_or(struct expr **ep1, struct expr **ep2);
void expr_extract_eq(enum expr_type type, struct expr **ep, struct expr **ep1, struct expr **ep2);
struct expr *expr_trans_compare(struct expr *e, enum expr_type type, struct symbol *sym);
void expr_fprint(struct expr *e, FILE *out);
struct gstr;
void expr_gstr_print(struct expr *e, struct gstr *gs);
static inline int expr_is_yes(struct expr *e)
{
 return !e || (e->type == E_SYMBOL && e->left.sym == &symbol_yes);
}
static inline int expr_is_no(struct expr *e)
{
 return e && (e->type == E_SYMBOL && e->left.sym == &symbol_no);
}

extern char *gettext (__const char *__msgid)
     __attribute__ ((__nothrow__)) __attribute__ ((__format_arg__ (1)));
extern char *dgettext (__const char *__domainname, __const char *__msgid)
     __attribute__ ((__nothrow__)) __attribute__ ((__format_arg__ (2)));
extern char *__dgettext (__const char *__domainname, __const char *__msgid)
     __attribute__ ((__nothrow__)) __attribute__ ((__format_arg__ (2)));
extern char *dcgettext (__const char *__domainname,
   __const char *__msgid, int __category)
     __attribute__ ((__nothrow__)) __attribute__ ((__format_arg__ (2)));
extern char *__dcgettext (__const char *__domainname,
     __const char *__msgid, int __category)
     __attribute__ ((__nothrow__)) __attribute__ ((__format_arg__ (2)));
extern char *ngettext (__const char *__msgid1, __const char *__msgid2,
         unsigned long int __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__format_arg__ (1))) __attribute__ ((__format_arg__ (2)));
extern char *dngettext (__const char *__domainname, __const char *__msgid1,
   __const char *__msgid2, unsigned long int __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__format_arg__ (2))) __attribute__ ((__format_arg__ (3)));
extern char *dcngettext (__const char *__domainname, __const char *__msgid1,
    __const char *__msgid2, unsigned long int __n,
    int __category)
     __attribute__ ((__nothrow__)) __attribute__ ((__format_arg__ (2))) __attribute__ ((__format_arg__ (3)));
extern char *textdomain (__const char *__domainname) __attribute__ ((__nothrow__));
extern char *bindtextdomain (__const char *__domainname,
        __const char *__dirname) __attribute__ ((__nothrow__));
extern char *bind_textdomain_codeset (__const char *__domainname,
          __const char *__codeset) __attribute__ ((__nothrow__));

extern void conf_parse (const char *name);
extern int conf_read (const char *name);
extern int conf_read_simple (const char *name);
extern int conf_write (const char *name);
extern struct menu rootmenu ;
extern _Bool menu_is_visible (struct menu *menu);
extern const char * menu_get_prompt (struct menu *menu);
extern struct menu * menu_get_root_menu (struct menu *menu);
extern struct menu * menu_get_parent_menu (struct menu *menu);
extern struct symbol * symbol_hash [257];
extern int sym_change_count ;
extern struct symbol * sym_lookup (const char *name, int isconst);
extern struct symbol * sym_find (const char *name);
extern struct symbol ** sym_re_search (const char *pattern);
extern const char * sym_type_name (enum symbol_type type);
extern void sym_calc_value (struct symbol *sym);
extern enum symbol_type sym_get_type (struct symbol *sym);
extern _Bool sym_tristate_within_range (struct symbol *sym,tristate tri);
extern _Bool sym_set_tristate_value (struct symbol *sym,tristate tri);
extern tristate sym_toggle_tristate_value (struct symbol *sym);
extern _Bool sym_string_valid (struct symbol *sym, const char *newval);
extern _Bool sym_string_within_range (struct symbol *sym, const char *str);
extern _Bool sym_set_string_value (struct symbol *sym, const char *newval);
extern _Bool sym_is_changable (struct symbol *sym);
extern struct property * sym_get_choice_prop (struct symbol *sym);
extern struct property * sym_get_default_prop (struct symbol *sym);
extern const char * sym_get_string_value (struct symbol *sym);
extern const char * prop_get_type_name (enum prop_type type);
extern int expr_compare_type (enum expr_type t1, enum expr_type t2);
extern void expr_print (struct expr *e, void (*fn)(void *, const char *), void *data, int prevtoken);
struct kconf_id {
 int name;
 int token;
 unsigned int flags;
 enum symbol_type stype;
};
int zconfparse(void);
void zconfdump(FILE *out);
extern int zconfdebug;
void zconf_starthelp(void);
FILE *zconf_fopen(const char *name);
void zconf_initscan(const char *name);
void zconf_nextfile(const char *name);
int zconf_lineno(void);
char *zconf_curname(void);
extern const char conf_def_filename[];
char *conf_get_default_confname(void);
void kconfig_load(void);
void menu_init(void);
struct menu *menu_add_menu(void);
void menu_end_menu(void);
void menu_add_entry(struct symbol *sym);
void menu_end_entry(void);
void menu_add_dep(struct expr *dep);
struct property *menu_add_prop(enum prop_type type, char *prompt, struct expr *expr, struct expr *dep);
struct property *menu_add_prompt(enum prop_type type, char *prompt, struct expr *dep);
void menu_add_expr(enum prop_type type, struct expr *expr, struct expr *dep);
void menu_add_symbol(enum prop_type type, struct symbol *sym, struct expr *dep);
void menu_finalize(struct menu *parent);
void menu_set_type(int type);
struct file *file_lookup(const char *name);
int file_write_dep(const char *name);
struct gstr {
 size_t len;
 char *s;
};
struct gstr str_new(void);
struct gstr str_assign(const char *s);
void str_free(struct gstr *gs);
void str_append(struct gstr *gs, const char *s);
void str_printf(struct gstr *gs, const char *fmt, ...);
const char *str_get(struct gstr *gs);
void sym_init(void);
void sym_clear_all_valid(void);
void sym_set_changed(struct symbol *sym);
struct symbol *sym_check_deps(struct symbol *sym);
struct property *prop_alloc(enum prop_type type, struct symbol *sym);
struct symbol *prop_get_symbol(struct property *prop);
static inline tristate sym_get_tristate_value(struct symbol *sym)
{
 return sym->curr.tri;
}
static inline struct symbol *sym_get_choice_value(struct symbol *sym)
{
 return (struct symbol *)sym->curr.val;
}
static inline _Bool sym_set_choice_value(struct symbol *ch, struct symbol *chval)
{
 return sym_set_tristate_value(chval, yes);
}
static inline _Bool sym_is_choice(struct symbol *sym)
{
 return sym->flags & 0x0010 ? 1 : 0;
}
static inline _Bool sym_is_choice_value(struct symbol *sym)
{
 return sym->flags & 0x0020 ? 1 : 0;
}
static inline _Bool sym_is_optional(struct symbol *sym)
{
 return sym->flags & 0x0100 ? 1 : 0;
}
static inline _Bool sym_has_value(struct symbol *sym)
{
 return sym->flags & 0x0800 ? 0 : 1;
}
struct expr *expr_alloc_symbol(struct symbol *sym)
{
 struct expr *e = malloc(sizeof(*e));
 memset(e, 0, sizeof(*e));
 e->type = E_SYMBOL;
 e->left.sym = sym;
 return e;
}
struct expr *expr_alloc_one(enum expr_type type, struct expr *ce)
{
 struct expr *e = malloc(sizeof(*e));
 memset(e, 0, sizeof(*e));
 e->type = type;
 e->left.expr = ce;
 return e;
}
struct expr *expr_alloc_two(enum expr_type type, struct expr *e1, struct expr *e2)
{
 struct expr *e = malloc(sizeof(*e));
 memset(e, 0, sizeof(*e));
 e->type = type;
 e->left.expr = e1;
 e->right.expr = e2;
 return e;
}
struct expr *expr_alloc_comp(enum expr_type type, struct symbol *s1, struct symbol *s2)
{
 struct expr *e = malloc(sizeof(*e));
 memset(e, 0, sizeof(*e));
 e->type = type;
 e->left.sym = s1;
 e->right.sym = s2;
 return e;
}
struct expr *expr_alloc_and(struct expr *e1, struct expr *e2)
{
 if (!e1)
  return e2;
 return e2 ? expr_alloc_two(E_AND, e1, e2) : e1;
}
struct expr *expr_alloc_or(struct expr *e1, struct expr *e2)
{
 if (!e1)
  return e2;
 return e2 ? expr_alloc_two(E_OR, e1, e2) : e1;
}
struct expr *expr_copy(struct expr *org)
{
 struct expr *e;
 if (!org)
  return ((void *)0);
 e = malloc(sizeof(*org));
 memcpy(e, org, sizeof(*org));
 switch (org->type) {
 case E_SYMBOL:
  e->left = org->left;
  break;
 case E_NOT:
  e->left.expr = expr_copy(org->left.expr);
  break;
 case E_EQUAL:
 case E_UNEQUAL:
  e->left.sym = org->left.sym;
  e->right.sym = org->right.sym;
  break;
 case E_AND:
 case E_OR:
 case E_CHOICE:
  e->left.expr = expr_copy(org->left.expr);
  e->right.expr = expr_copy(org->right.expr);
  break;
 default:
  printf("can't copy type %d\n", e->type);
  free(e);
  e = ((void *)0);
  break;
 }
 return e;
}
void expr_free(struct expr *e)
{
 if (!e)
  return;
 switch (e->type) {
 case E_SYMBOL:
  break;
 case E_NOT:
  expr_free(e->left.expr);
  return;
 case E_EQUAL:
 case E_UNEQUAL:
  break;
 case E_OR:
 case E_AND:
  expr_free(e->left.expr);
  expr_free(e->right.expr);
  break;
 default:
  printf("how to free type %d?\n", e->type);
  break;
 }
 free(e);
}
static int trans_count;
static void __expr_eliminate_eq(enum expr_type type, struct expr **ep1, struct expr **ep2)
{
 if ((*ep1)->type == type) {
  __expr_eliminate_eq(type, &(*ep1)->left.expr, &(*ep2));
  __expr_eliminate_eq(type, &(*ep1)->right.expr, &(*ep2));
  return;
 }
 if ((*ep2)->type == type) {
  __expr_eliminate_eq(type, &(*ep1), &(*ep2)->left.expr);
  __expr_eliminate_eq(type, &(*ep1), &(*ep2)->right.expr);
  return;
 }
 if ((*ep1)->type == E_SYMBOL && (*ep2)->type == E_SYMBOL &&
     (*ep1)->left.sym == (*ep2)->left.sym && ((*ep1)->left.sym->flags & (0x0001|0x0004)))
  return;
 if (!expr_eq((*ep1), (*ep2)))
  return;
 trans_count++;
 expr_free((*ep1)); expr_free((*ep2));
 switch (type) {
 case E_OR:
  (*ep1) = expr_alloc_symbol(&symbol_no);
  (*ep2) = expr_alloc_symbol(&symbol_no);
  break;
 case E_AND:
  (*ep1) = expr_alloc_symbol(&symbol_yes);
  (*ep2) = expr_alloc_symbol(&symbol_yes);
  break;
 default:
  ;
 }
}
void expr_eliminate_eq(struct expr **ep1, struct expr **ep2)
{
 if (!(*ep1) || !(*ep2))
  return;
 switch ((*ep1)->type) {
 case E_OR:
 case E_AND:
  __expr_eliminate_eq((*ep1)->type, ep1, ep2);
 default:
  ;
 }
 if ((*ep1)->type != (*ep2)->type) switch ((*ep2)->type) {
 case E_OR:
 case E_AND:
  __expr_eliminate_eq((*ep2)->type, ep1, ep2);
 default:
  ;
 }
 (*ep1) = expr_eliminate_yn((*ep1));
 (*ep2) = expr_eliminate_yn((*ep2));
}
int expr_eq(struct expr *e1, struct expr *e2)
{
 int res, old_count;
 if (e1->type != e2->type)
  return 0;
 switch (e1->type) {
 case E_EQUAL:
 case E_UNEQUAL:
  return e1->left.sym == e2->left.sym && e1->right.sym == e2->right.sym;
 case E_SYMBOL:
  return e1->left.sym == e2->left.sym;
 case E_NOT:
  return expr_eq(e1->left.expr, e2->left.expr);
 case E_AND:
 case E_OR:
  e1 = expr_copy(e1);
  e2 = expr_copy(e2);
  old_count = trans_count;
  expr_eliminate_eq(&e1, &e2);
  res = (e1->type == E_SYMBOL && e2->type == E_SYMBOL &&
         e1->left.sym == e2->left.sym);
  expr_free(e1);
  expr_free(e2);
  trans_count = old_count;
  return res;
 case E_CHOICE:
 case E_RANGE:
 case E_NONE:
             ;
 }
 if (0) {
  expr_fprint(e1, stdout);
  printf(" = ");
  expr_fprint(e2, stdout);
  printf(" ?\n");
 }
 return 0;
}
struct expr *expr_eliminate_yn(struct expr *e)
{
 struct expr *tmp;
 if (e) switch (e->type) {
 case E_AND:
  e->left.expr = expr_eliminate_yn(e->left.expr);
  e->right.expr = expr_eliminate_yn(e->right.expr);
  if (e->left.expr->type == E_SYMBOL) {
   if (e->left.expr->left.sym == &symbol_no) {
    expr_free(e->left.expr);
    expr_free(e->right.expr);
    e->type = E_SYMBOL;
    e->left.sym = &symbol_no;
    e->right.expr = ((void *)0);
    return e;
   } else if (e->left.expr->left.sym == &symbol_yes) {
    free(e->left.expr);
    tmp = e->right.expr;
    *e = *(e->right.expr);
    free(tmp);
    return e;
   }
  }
  if (e->right.expr->type == E_SYMBOL) {
   if (e->right.expr->left.sym == &symbol_no) {
    expr_free(e->left.expr);
    expr_free(e->right.expr);
    e->type = E_SYMBOL;
    e->left.sym = &symbol_no;
    e->right.expr = ((void *)0);
    return e;
   } else if (e->right.expr->left.sym == &symbol_yes) {
    free(e->right.expr);
    tmp = e->left.expr;
    *e = *(e->left.expr);
    free(tmp);
    return e;
   }
  }
  break;
 case E_OR:
  e->left.expr = expr_eliminate_yn(e->left.expr);
  e->right.expr = expr_eliminate_yn(e->right.expr);
  if (e->left.expr->type == E_SYMBOL) {
   if (e->left.expr->left.sym == &symbol_no) {
    free(e->left.expr);
    tmp = e->right.expr;
    *e = *(e->right.expr);
    free(tmp);
    return e;
   } else if (e->left.expr->left.sym == &symbol_yes) {
    expr_free(e->left.expr);
    expr_free(e->right.expr);
    e->type = E_SYMBOL;
    e->left.sym = &symbol_yes;
    e->right.expr = ((void *)0);
    return e;
   }
  }
  if (e->right.expr->type == E_SYMBOL) {
   if (e->right.expr->left.sym == &symbol_no) {
    free(e->right.expr);
    tmp = e->left.expr;
    *e = *(e->left.expr);
    free(tmp);
    return e;
   } else if (e->right.expr->left.sym == &symbol_yes) {
    expr_free(e->left.expr);
    expr_free(e->right.expr);
    e->type = E_SYMBOL;
    e->left.sym = &symbol_yes;
    e->right.expr = ((void *)0);
    return e;
   }
  }
  break;
 default:
  ;
 }
 return e;
}
struct expr *expr_trans_bool(struct expr *e)
{
 if (!e)
  return ((void *)0);
 switch (e->type) {
 case E_AND:
 case E_OR:
 case E_NOT:
  e->left.expr = expr_trans_bool(e->left.expr);
  e->right.expr = expr_trans_bool(e->right.expr);
  break;
 case E_UNEQUAL:
  if (e->left.sym->type == S_TRISTATE) {
   if (e->right.sym == &symbol_no) {
    e->type = E_SYMBOL;
    e->right.sym = ((void *)0);
   }
  }
  break;
 default:
  ;
 }
 return e;
}
struct expr *expr_join_or(struct expr *e1, struct expr *e2)
{
 struct expr *tmp;
 struct symbol *sym1, *sym2;
 if (expr_eq(e1, e2))
  return expr_copy(e1);
 if (e1->type != E_EQUAL && e1->type != E_UNEQUAL && e1->type != E_SYMBOL && e1->type != E_NOT)
  return ((void *)0);
 if (e2->type != E_EQUAL && e2->type != E_UNEQUAL && e2->type != E_SYMBOL && e2->type != E_NOT)
  return ((void *)0);
 if (e1->type == E_NOT) {
  tmp = e1->left.expr;
  if (tmp->type != E_EQUAL && tmp->type != E_UNEQUAL && tmp->type != E_SYMBOL)
   return ((void *)0);
  sym1 = tmp->left.sym;
 } else
  sym1 = e1->left.sym;
 if (e2->type == E_NOT) {
  if (e2->left.expr->type != E_SYMBOL)
   return ((void *)0);
  sym2 = e2->left.expr->left.sym;
 } else
  sym2 = e2->left.sym;
 if (sym1 != sym2)
  return ((void *)0);
 if (sym1->type != S_BOOLEAN && sym1->type != S_TRISTATE)
  return ((void *)0);
 if (sym1->type == S_TRISTATE) {
  if (e1->type == E_EQUAL && e2->type == E_EQUAL &&
      ((e1->right.sym == &symbol_yes && e2->right.sym == &symbol_mod) ||
       (e1->right.sym == &symbol_mod && e2->right.sym == &symbol_yes))) {
   return expr_alloc_comp(E_UNEQUAL, sym1, &symbol_no);
  }
  if (e1->type == E_EQUAL && e2->type == E_EQUAL &&
      ((e1->right.sym == &symbol_yes && e2->right.sym == &symbol_no) ||
       (e1->right.sym == &symbol_no && e2->right.sym == &symbol_yes))) {
   return expr_alloc_comp(E_UNEQUAL, sym1, &symbol_mod);
  }
  if (e1->type == E_EQUAL && e2->type == E_EQUAL &&
      ((e1->right.sym == &symbol_mod && e2->right.sym == &symbol_no) ||
       (e1->right.sym == &symbol_no && e2->right.sym == &symbol_mod))) {
   return expr_alloc_comp(E_UNEQUAL, sym1, &symbol_yes);
  }
 }
 if (sym1->type == S_BOOLEAN && sym1 == sym2) {
  if ((e1->type == E_NOT && e1->left.expr->type == E_SYMBOL && e2->type == E_SYMBOL) ||
      (e2->type == E_NOT && e2->left.expr->type == E_SYMBOL && e1->type == E_SYMBOL))
   return expr_alloc_symbol(&symbol_yes);
 }
 if (0) {
  printf("optimize (");
  expr_fprint(e1, stdout);
  printf(") || (");
  expr_fprint(e2, stdout);
  printf(")?\n");
 }
 return ((void *)0);
}
struct expr *expr_join_and(struct expr *e1, struct expr *e2)
{
 struct expr *tmp;
 struct symbol *sym1, *sym2;
 if (expr_eq(e1, e2))
  return expr_copy(e1);
 if (e1->type != E_EQUAL && e1->type != E_UNEQUAL && e1->type != E_SYMBOL && e1->type != E_NOT)
  return ((void *)0);
 if (e2->type != E_EQUAL && e2->type != E_UNEQUAL && e2->type != E_SYMBOL && e2->type != E_NOT)
  return ((void *)0);
 if (e1->type == E_NOT) {
  tmp = e1->left.expr;
  if (tmp->type != E_EQUAL && tmp->type != E_UNEQUAL && tmp->type != E_SYMBOL)
   return ((void *)0);
  sym1 = tmp->left.sym;
 } else
  sym1 = e1->left.sym;
 if (e2->type == E_NOT) {
  if (e2->left.expr->type != E_SYMBOL)
   return ((void *)0);
  sym2 = e2->left.expr->left.sym;
 } else
  sym2 = e2->left.sym;
 if (sym1 != sym2)
  return ((void *)0);
 if (sym1->type != S_BOOLEAN && sym1->type != S_TRISTATE)
  return ((void *)0);
 if ((e1->type == E_SYMBOL && e2->type == E_EQUAL && e2->right.sym == &symbol_yes) ||
     (e2->type == E_SYMBOL && e1->type == E_EQUAL && e1->right.sym == &symbol_yes))
  return expr_alloc_comp(E_EQUAL, sym1, &symbol_yes);
 if ((e1->type == E_SYMBOL && e2->type == E_UNEQUAL && e2->right.sym == &symbol_no) ||
     (e2->type == E_SYMBOL && e1->type == E_UNEQUAL && e1->right.sym == &symbol_no))
  return expr_alloc_symbol(sym1);
 if ((e1->type == E_SYMBOL && e2->type == E_UNEQUAL && e2->right.sym == &symbol_mod) ||
     (e2->type == E_SYMBOL && e1->type == E_UNEQUAL && e1->right.sym == &symbol_mod))
  return expr_alloc_comp(E_EQUAL, sym1, &symbol_yes);
 if (sym1->type == S_TRISTATE) {
  if (e1->type == E_EQUAL && e2->type == E_UNEQUAL) {
   sym2 = e1->right.sym;
   if ((e2->right.sym->flags & 0x0007) && (sym2->flags & 0x0007))
    return sym2 != e2->right.sym ? expr_alloc_comp(E_EQUAL, sym1, sym2)
            : expr_alloc_symbol(&symbol_no);
  }
  if (e1->type == E_UNEQUAL && e2->type == E_EQUAL) {
   sym2 = e2->right.sym;
   if ((e1->right.sym->flags & 0x0007) && (sym2->flags & 0x0007))
    return sym2 != e1->right.sym ? expr_alloc_comp(E_EQUAL, sym1, sym2)
            : expr_alloc_symbol(&symbol_no);
  }
  if (e1->type == E_UNEQUAL && e2->type == E_UNEQUAL &&
      ((e1->right.sym == &symbol_yes && e2->right.sym == &symbol_no) ||
       (e1->right.sym == &symbol_no && e2->right.sym == &symbol_yes)))
   return expr_alloc_comp(E_EQUAL, sym1, &symbol_mod);
  if (e1->type == E_UNEQUAL && e2->type == E_UNEQUAL &&
      ((e1->right.sym == &symbol_yes && e2->right.sym == &symbol_mod) ||
       (e1->right.sym == &symbol_mod && e2->right.sym == &symbol_yes)))
   return expr_alloc_comp(E_EQUAL, sym1, &symbol_no);
  if (e1->type == E_UNEQUAL && e2->type == E_UNEQUAL &&
      ((e1->right.sym == &symbol_mod && e2->right.sym == &symbol_no) ||
       (e1->right.sym == &symbol_no && e2->right.sym == &symbol_mod)))
   return expr_alloc_comp(E_EQUAL, sym1, &symbol_yes);
  if ((e1->type == E_SYMBOL && e2->type == E_EQUAL && e2->right.sym == &symbol_mod) ||
      (e2->type == E_SYMBOL && e1->type == E_EQUAL && e1->right.sym == &symbol_mod) ||
      (e1->type == E_SYMBOL && e2->type == E_UNEQUAL && e2->right.sym == &symbol_yes) ||
      (e2->type == E_SYMBOL && e1->type == E_UNEQUAL && e1->right.sym == &symbol_yes))
   return ((void *)0);
 }
 if (0) {
  printf("optimize (");
  expr_fprint(e1, stdout);
  printf(") && (");
  expr_fprint(e2, stdout);
  printf(")?\n");
 }
 return ((void *)0);
}
static void expr_eliminate_dups1(enum expr_type type, struct expr **ep1, struct expr **ep2)
{
 struct expr *tmp;
 if ((*ep1)->type == type) {
  expr_eliminate_dups1(type, &(*ep1)->left.expr, &(*ep2));
  expr_eliminate_dups1(type, &(*ep1)->right.expr, &(*ep2));
  return;
 }
 if ((*ep2)->type == type) {
  expr_eliminate_dups1(type, &(*ep1), &(*ep2)->left.expr);
  expr_eliminate_dups1(type, &(*ep1), &(*ep2)->right.expr);
  return;
 }
 if ((*ep1) == (*ep2))
  return;
 switch ((*ep1)->type) {
 case E_OR: case E_AND:
  expr_eliminate_dups1((*ep1)->type, &(*ep1), &(*ep1));
 default:
  ;
 }
 switch (type) {
 case E_OR:
  tmp = expr_join_or((*ep1), (*ep2));
  if (tmp) {
   expr_free((*ep1)); expr_free((*ep2));
   (*ep1) = expr_alloc_symbol(&symbol_no);
   (*ep2) = tmp;
   trans_count++;
  }
  break;
 case E_AND:
  tmp = expr_join_and((*ep1), (*ep2));
  if (tmp) {
   expr_free((*ep1)); expr_free((*ep2));
   (*ep1) = expr_alloc_symbol(&symbol_yes);
   (*ep2) = tmp;
   trans_count++;
  }
  break;
 default:
  ;
 }
}
static void expr_eliminate_dups2(enum expr_type type, struct expr **ep1, struct expr **ep2)
{
 struct expr *tmp, *tmp1, *tmp2;
 if ((*ep1)->type == type) {
  expr_eliminate_dups2(type, &(*ep1)->left.expr, &(*ep2));
  expr_eliminate_dups2(type, &(*ep1)->right.expr, &(*ep2));
  return;
 }
 if ((*ep2)->type == type) {
  expr_eliminate_dups2(type, &(*ep1), &(*ep2)->left.expr);
  expr_eliminate_dups2(type, &(*ep1), &(*ep2)->right.expr);
 }
 if ((*ep1) == (*ep2))
  return;
 switch ((*ep1)->type) {
 case E_OR:
  expr_eliminate_dups2((*ep1)->type, &(*ep1), &(*ep1));
  tmp1 = expr_transform(expr_alloc_one(E_NOT, expr_copy((*ep1))));
  tmp2 = expr_copy((*ep2));
  tmp = expr_extract_eq_and(&tmp1, &tmp2);
  if (expr_is_yes(tmp1)) {
   expr_free((*ep1));
   (*ep1) = expr_alloc_symbol(&symbol_no);
   trans_count++;
  }
  expr_free(tmp2);
  expr_free(tmp1);
  expr_free(tmp);
  break;
 case E_AND:
  expr_eliminate_dups2((*ep1)->type, &(*ep1), &(*ep1));
  tmp1 = expr_transform(expr_alloc_one(E_NOT, expr_copy((*ep1))));
  tmp2 = expr_copy((*ep2));
  tmp = expr_extract_eq_or(&tmp1, &tmp2);
  if (expr_is_no(tmp1)) {
   expr_free((*ep1));
   (*ep1) = expr_alloc_symbol(&symbol_yes);
   trans_count++;
  }
  expr_free(tmp2);
  expr_free(tmp1);
  expr_free(tmp);
  break;
 default:
  ;
 }
}
struct expr *expr_eliminate_dups(struct expr *e)
{
 int oldcount;
 if (!e)
  return e;
 oldcount = trans_count;
 while (1) {
  trans_count = 0;
  switch (e->type) {
  case E_OR: case E_AND:
   expr_eliminate_dups1(e->type, &e, &e);
   expr_eliminate_dups2(e->type, &e, &e);
  default:
   ;
  }
  if (!trans_count)
   break;
  e = expr_eliminate_yn(e);
 }
 trans_count = oldcount;
 return e;
}
struct expr *expr_transform(struct expr *e)
{
 struct expr *tmp;
 if (!e)
  return ((void *)0);
 switch (e->type) {
 case E_EQUAL:
 case E_UNEQUAL:
 case E_SYMBOL:
 case E_CHOICE:
  break;
 default:
  e->left.expr = expr_transform(e->left.expr);
  e->right.expr = expr_transform(e->right.expr);
 }
 switch (e->type) {
 case E_EQUAL:
  if (e->left.sym->type != S_BOOLEAN)
   break;
  if (e->right.sym == &symbol_no) {
   e->type = E_NOT;
   e->left.expr = expr_alloc_symbol(e->left.sym);
   e->right.sym = ((void *)0);
   break;
  }
  if (e->right.sym == &symbol_mod) {
   printf("boolean symbol %s tested for 'm'? test forced to 'n'\n", e->left.sym->name);
   e->type = E_SYMBOL;
   e->left.sym = &symbol_no;
   e->right.sym = ((void *)0);
   break;
  }
  if (e->right.sym == &symbol_yes) {
   e->type = E_SYMBOL;
   e->right.sym = ((void *)0);
   break;
  }
  break;
 case E_UNEQUAL:
  if (e->left.sym->type != S_BOOLEAN)
   break;
  if (e->right.sym == &symbol_no) {
   e->type = E_SYMBOL;
   e->right.sym = ((void *)0);
   break;
  }
  if (e->right.sym == &symbol_mod) {
   printf("boolean symbol %s tested for 'm'? test forced to 'y'\n", e->left.sym->name);
   e->type = E_SYMBOL;
   e->left.sym = &symbol_yes;
   e->right.sym = ((void *)0);
   break;
  }
  if (e->right.sym == &symbol_yes) {
   e->type = E_NOT;
   e->left.expr = expr_alloc_symbol(e->left.sym);
   e->right.sym = ((void *)0);
   break;
  }
  break;
 case E_NOT:
  switch (e->left.expr->type) {
  case E_NOT:
   tmp = e->left.expr->left.expr;
   free(e->left.expr);
   free(e);
   e = tmp;
   e = expr_transform(e);
   break;
  case E_EQUAL:
  case E_UNEQUAL:
   tmp = e->left.expr;
   free(e);
   e = tmp;
   e->type = e->type == E_EQUAL ? E_UNEQUAL : E_EQUAL;
   break;
  case E_OR:
   tmp = e->left.expr;
   e->type = E_AND;
   e->right.expr = expr_alloc_one(E_NOT, tmp->right.expr);
   tmp->type = E_NOT;
   tmp->right.expr = ((void *)0);
   e = expr_transform(e);
   break;
  case E_AND:
   tmp = e->left.expr;
   e->type = E_OR;
   e->right.expr = expr_alloc_one(E_NOT, tmp->right.expr);
   tmp->type = E_NOT;
   tmp->right.expr = ((void *)0);
   e = expr_transform(e);
   break;
  case E_SYMBOL:
   if (e->left.expr->left.sym == &symbol_yes) {
    tmp = e->left.expr;
    free(e);
    e = tmp;
    e->type = E_SYMBOL;
    e->left.sym = &symbol_no;
    break;
   }
   if (e->left.expr->left.sym == &symbol_mod) {
    tmp = e->left.expr;
    free(e);
    e = tmp;
    e->type = E_SYMBOL;
    e->left.sym = &symbol_mod;
    break;
   }
   if (e->left.expr->left.sym == &symbol_no) {
    tmp = e->left.expr;
    free(e);
    e = tmp;
    e->type = E_SYMBOL;
    e->left.sym = &symbol_yes;
    break;
   }
   break;
  default:
   ;
  }
  break;
 default:
  ;
 }
 return e;
}
int expr_contains_symbol(struct expr *dep, struct symbol *sym)
{
 if (!dep)
  return 0;
 switch (dep->type) {
 case E_AND:
 case E_OR:
  return expr_contains_symbol(dep->left.expr, sym) ||
         expr_contains_symbol(dep->right.expr, sym);
 case E_SYMBOL:
  return dep->left.sym == sym;
 case E_EQUAL:
 case E_UNEQUAL:
  return dep->left.sym == sym ||
         dep->right.sym == sym;
 case E_NOT:
  return expr_contains_symbol(dep->left.expr, sym);
 default:
  ;
 }
 return 0;
}
_Bool expr_depends_symbol(struct expr *dep, struct symbol *sym)
{
 if (!dep)
  return 0;
 switch (dep->type) {
 case E_AND:
  return expr_depends_symbol(dep->left.expr, sym) ||
         expr_depends_symbol(dep->right.expr, sym);
 case E_SYMBOL:
  return dep->left.sym == sym;
 case E_EQUAL:
  if (dep->left.sym == sym) {
   if (dep->right.sym == &symbol_yes || dep->right.sym == &symbol_mod)
    return 1;
  }
  break;
 case E_UNEQUAL:
  if (dep->left.sym == sym) {
   if (dep->right.sym == &symbol_no)
    return 1;
  }
  break;
 default:
  ;
 }
 return 0;
}
struct expr *expr_extract_eq_and(struct expr **ep1, struct expr **ep2)
{
 struct expr *tmp = ((void *)0);
 expr_extract_eq(E_AND, &tmp, ep1, ep2);
 if (tmp) {
  *ep1 = expr_eliminate_yn(*ep1);
  *ep2 = expr_eliminate_yn(*ep2);
 }
 return tmp;
}
struct expr *expr_extract_eq_or(struct expr **ep1, struct expr **ep2)
{
 struct expr *tmp = ((void *)0);
 expr_extract_eq(E_OR, &tmp, ep1, ep2);
 if (tmp) {
  *ep1 = expr_eliminate_yn(*ep1);
  *ep2 = expr_eliminate_yn(*ep2);
 }
 return tmp;
}
void expr_extract_eq(enum expr_type type, struct expr **ep, struct expr **ep1, struct expr **ep2)
{
 if ((*ep1)->type == type) {
  expr_extract_eq(type, ep, &(*ep1)->left.expr, &(*ep2));
  expr_extract_eq(type, ep, &(*ep1)->right.expr, &(*ep2));
  return;
 }
 if ((*ep2)->type == type) {
  expr_extract_eq(type, ep, ep1, &(*ep2)->left.expr);
  expr_extract_eq(type, ep, ep1, &(*ep2)->right.expr);
  return;
 }
 if (expr_eq((*ep1), (*ep2))) {
  *ep = *ep ? expr_alloc_two(type, *ep, (*ep1)) : (*ep1);
  expr_free((*ep2));
  if (type == E_AND) {
   (*ep1) = expr_alloc_symbol(&symbol_yes);
   (*ep2) = expr_alloc_symbol(&symbol_yes);
  } else if (type == E_OR) {
   (*ep1) = expr_alloc_symbol(&symbol_no);
   (*ep2) = expr_alloc_symbol(&symbol_no);
  }
 }
}
struct expr *expr_trans_compare(struct expr *e, enum expr_type type, struct symbol *sym)
{
 struct expr *e1, *e2;
 if (!e) {
  e = expr_alloc_symbol(sym);
  if (type == E_UNEQUAL)
   e = expr_alloc_one(E_NOT, e);
  return e;
 }
 switch (e->type) {
 case E_AND:
  e1 = expr_trans_compare(e->left.expr, E_EQUAL, sym);
  e2 = expr_trans_compare(e->right.expr, E_EQUAL, sym);
  if (sym == &symbol_yes)
   e = expr_alloc_two(E_AND, e1, e2);
  if (sym == &symbol_no)
   e = expr_alloc_two(E_OR, e1, e2);
  if (type == E_UNEQUAL)
   e = expr_alloc_one(E_NOT, e);
  return e;
 case E_OR:
  e1 = expr_trans_compare(e->left.expr, E_EQUAL, sym);
  e2 = expr_trans_compare(e->right.expr, E_EQUAL, sym);
  if (sym == &symbol_yes)
   e = expr_alloc_two(E_OR, e1, e2);
  if (sym == &symbol_no)
   e = expr_alloc_two(E_AND, e1, e2);
  if (type == E_UNEQUAL)
   e = expr_alloc_one(E_NOT, e);
  return e;
 case E_NOT:
  return expr_trans_compare(e->left.expr, type == E_EQUAL ? E_UNEQUAL : E_EQUAL, sym);
 case E_UNEQUAL:
 case E_EQUAL:
  if (type == E_EQUAL) {
   if (sym == &symbol_yes)
    return expr_copy(e);
   if (sym == &symbol_mod)
    return expr_alloc_symbol(&symbol_no);
   if (sym == &symbol_no)
    return expr_alloc_one(E_NOT, expr_copy(e));
  } else {
   if (sym == &symbol_yes)
    return expr_alloc_one(E_NOT, expr_copy(e));
   if (sym == &symbol_mod)
    return expr_alloc_symbol(&symbol_yes);
   if (sym == &symbol_no)
    return expr_copy(e);
  }
  break;
 case E_SYMBOL:
  return expr_alloc_comp(type, e->left.sym, sym);
 case E_CHOICE:
 case E_RANGE:
 case E_NONE:
             ;
 }
 return ((void *)0);
}
tristate expr_calc_value(struct expr *e)
{
 tristate val1, val2;
 const char *str1, *str2;
 if (!e)
  return yes;
 switch (e->type) {
 case E_SYMBOL:
  sym_calc_value(e->left.sym);
  return e->left.sym->curr.tri;
 case E_AND:
  val1 = expr_calc_value(e->left.expr);
  val2 = expr_calc_value(e->right.expr);
  return (((val1)<(val2))?(val1):(val2));
 case E_OR:
  val1 = expr_calc_value(e->left.expr);
  val2 = expr_calc_value(e->right.expr);
  return (((val1)>(val2))?(val1):(val2));
 case E_NOT:
  val1 = expr_calc_value(e->left.expr);
  return (2-(val1));
 case E_EQUAL:
  sym_calc_value(e->left.sym);
  sym_calc_value(e->right.sym);
  str1 = sym_get_string_value(e->left.sym);
  str2 = sym_get_string_value(e->right.sym);
  return !strcmp(str1, str2) ? yes : no;
 case E_UNEQUAL:
  sym_calc_value(e->left.sym);
  sym_calc_value(e->right.sym);
  str1 = sym_get_string_value(e->left.sym);
  str2 = sym_get_string_value(e->right.sym);
  return !strcmp(str1, str2) ? no : yes;
 default:
  printf("expr_calc_value: %d?\n", e->type);
  return no;
 }
}
int expr_compare_type(enum expr_type t1, enum expr_type t2)
{
 if (t1 == t2)
  return 0;
 switch (t1) {
 case E_EQUAL:
 case E_UNEQUAL:
  if (t2 == E_NOT)
   return 1;
 case E_NOT:
  if (t2 == E_AND)
   return 1;
 case E_AND:
  if (t2 == E_OR)
   return 1;
 case E_OR:
  if (t2 == E_CHOICE)
   return 1;
 case E_CHOICE:
  if (t2 == 0)
   return 1;
 default:
  return -1;
 }
 printf("[%dgt%d?]", t1, t2);
 return 0;
}
void expr_print(struct expr *e, void (*fn)(void *, const char *), void *data, int prevtoken)
{
 if (!e) {
  fn(data, "y");
  return;
 }
 if (expr_compare_type(prevtoken, e->type) > 0)
  fn(data, "(");
 switch (e->type) {
 case E_SYMBOL:
  if (e->left.sym->name)
   fn(data, e->left.sym->name);
  else
   fn(data, "<choice>");
  break;
 case E_NOT:
  fn(data, "!");
  expr_print(e->left.expr, fn, data, E_NOT);
  break;
 case E_EQUAL:
  fn(data, e->left.sym->name);
  fn(data, "=");
  fn(data, e->right.sym->name);
  break;
 case E_UNEQUAL:
  fn(data, e->left.sym->name);
  fn(data, "!=");
  fn(data, e->right.sym->name);
  break;
 case E_OR:
  expr_print(e->left.expr, fn, data, E_OR);
  fn(data, " || ");
  expr_print(e->right.expr, fn, data, E_OR);
  break;
 case E_AND:
  expr_print(e->left.expr, fn, data, E_AND);
  fn(data, " && ");
  expr_print(e->right.expr, fn, data, E_AND);
  break;
 case E_CHOICE:
  fn(data, e->right.sym->name);
  if (e->left.expr) {
   fn(data, " ^ ");
   expr_print(e->left.expr, fn, data, E_CHOICE);
  }
  break;
 case E_RANGE:
  fn(data, "[");
  fn(data, e->left.sym->name);
  fn(data, " ");
  fn(data, e->right.sym->name);
  fn(data, "]");
  break;
 default:
   {
  char buf[32];
  sprintf(buf, "<unknown type %d>", e->type);
  fn(data, buf);
  break;
   }
 }
 if (expr_compare_type(prevtoken, e->type) > 0)
  fn(data, ")");
}
static void expr_print_file_helper(void *data, const char *str)
{
 fwrite(str, strlen(str), 1, data);
}
void expr_fprint(struct expr *e, FILE *out)
{
 expr_print(e, expr_print_file_helper, out, E_NONE);
}
static void expr_print_gstr_helper(void *data, const char *str)
{
 str_append((struct gstr*)data, str);
}
void expr_gstr_print(struct expr *e, struct gstr *gs)
{
 expr_print(e, expr_print_gstr_helper, gs, E_NONE);
}
