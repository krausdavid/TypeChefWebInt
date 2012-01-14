
struct winsize
  {
    unsigned short int ws_row;
    unsigned short int ws_col;
    unsigned short int ws_xpixel;
    unsigned short int ws_ypixel;
  };
struct termio
  {
    unsigned short int c_iflag;
    unsigned short int c_oflag;
    unsigned short int c_cflag;
    unsigned short int c_lflag;
    unsigned char c_line;
    unsigned char c_cc[8];
};
extern int ioctl (int __fd, unsigned long int __request, ...) __attribute__ ((__nothrow__));





typedef int __sig_atomic_t;




typedef struct
  {
    unsigned long int __val[(1024 / (8 * sizeof (unsigned long int)))];
  } __sigset_t;
extern int __sigismember (__const __sigset_t *, int);
extern int __sigaddset (__sigset_t *, int);
extern int __sigdelset (__sigset_t *, int);





typedef __sig_atomic_t sig_atomic_t;








typedef __sigset_t sigset_t;
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
typedef __pid_t pid_t;
typedef __uid_t uid_t;
struct timespec
  {
    __time_t tv_sec;
    long int tv_nsec;
  };
typedef union sigval
  {
    int sival_int;
    void *sival_ptr;
  } sigval_t;
typedef struct siginfo
  {
    int si_signo;
    int si_errno;
    int si_code;
    union
      {
 int _pad[((128 / sizeof (int)) - 4)];
 struct
   {
     __pid_t si_pid;
     __uid_t si_uid;
   } _kill;
 struct
   {
     int si_tid;
     int si_overrun;
     sigval_t si_sigval;
   } _timer;
 struct
   {
     __pid_t si_pid;
     __uid_t si_uid;
     sigval_t si_sigval;
   } _rt;
 struct
   {
     __pid_t si_pid;
     __uid_t si_uid;
     int si_status;
     __clock_t si_utime;
     __clock_t si_stime;
   } _sigchld;
 struct
   {
     void *si_addr;
   } _sigfault;
 struct
   {
     long int si_band;
     int si_fd;
   } _sigpoll;
      } _sifields;
  } siginfo_t;
enum
{
  SI_ASYNCNL = -60,
  SI_TKILL = -6,
  SI_SIGIO,
  SI_ASYNCIO,
  SI_MESGQ,
  SI_TIMER,
  SI_QUEUE,
  SI_USER,
  SI_KERNEL = 0x80
};
enum
{
  ILL_ILLOPC = 1,
  ILL_ILLOPN,
  ILL_ILLADR,
  ILL_ILLTRP,
  ILL_PRVOPC,
  ILL_PRVREG,
  ILL_COPROC,
  ILL_BADSTK
};
enum
{
  FPE_INTDIV = 1,
  FPE_INTOVF,
  FPE_FLTDIV,
  FPE_FLTOVF,
  FPE_FLTUND,
  FPE_FLTRES,
  FPE_FLTINV,

  FPE_FLTSUB

};


enum
{
  SEGV_MAPERR = 1,

  SEGV_ACCERR

};


enum
{
  BUS_ADRALN = 1,

  BUS_ADRERR,

  BUS_OBJERR

};


enum
{
  TRAP_BRKPT = 1,

  TRAP_TRACE

};


enum
{
  CLD_EXITED = 1,

  CLD_KILLED,

  CLD_DUMPED,

  CLD_TRAPPED,

  CLD_STOPPED,

  CLD_CONTINUED

};


enum
{
  POLL_IN = 1,

  POLL_OUT,

  POLL_MSG,

  POLL_ERR,

  POLL_PRI,

  POLL_HUP

};
typedef struct sigevent
  {
    sigval_t sigev_value;
    int sigev_signo;
    int sigev_notify;
    union
      {
 int _pad[((64 / sizeof (int)) - 4)];
 __pid_t _tid;
 struct
   {
     void (*_function) (sigval_t);
     void *_attribute;
   } _sigev_thread;
      } _sigev_un;
  } sigevent_t;
enum
{
  SIGEV_SIGNAL = 0,
  SIGEV_NONE,
  SIGEV_THREAD,
  SIGEV_THREAD_ID = 4
};
typedef void (*__sighandler_t) (int);
extern __sighandler_t __sysv_signal (int __sig, __sighandler_t __handler)
     __attribute__ ((__nothrow__));

extern __sighandler_t signal (int __sig, __sighandler_t __handler)
     __attribute__ ((__nothrow__));

extern int kill (__pid_t __pid, int __sig) __attribute__ ((__nothrow__));
extern int killpg (__pid_t __pgrp, int __sig) __attribute__ ((__nothrow__));

extern int raise (int __sig) __attribute__ ((__nothrow__));

extern __sighandler_t ssignal (int __sig, __sighandler_t __handler)
     __attribute__ ((__nothrow__));
extern int gsignal (int __sig) __attribute__ ((__nothrow__));
extern void psignal (int __sig, __const char *__s);
extern void psiginfo (__const siginfo_t *__pinfo, __const char *__s);
extern int __sigpause (int __sig_or_mask, int __is_sig);
extern int sigblock (int __mask) __attribute__ ((__nothrow__)) __attribute__ ((__deprecated__));
extern int sigsetmask (int __mask) __attribute__ ((__nothrow__)) __attribute__ ((__deprecated__));
extern int siggetmask (void) __attribute__ ((__nothrow__)) __attribute__ ((__deprecated__));
typedef __sighandler_t sig_t;
extern int sigemptyset (sigset_t *__set) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
extern int sigfillset (sigset_t *__set) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
extern int sigaddset (sigset_t *__set, int __signo) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
extern int sigdelset (sigset_t *__set, int __signo) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
extern int sigismember (__const sigset_t *__set, int __signo)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
struct sigaction
  {
    union
      {
 __sighandler_t sa_handler;
 void (*sa_sigaction) (int, siginfo_t *, void *);
      }
    __sigaction_handler;
    __sigset_t sa_mask;
    int sa_flags;
    void (*sa_restorer) (void);
  };
extern int sigprocmask (int __how, __const sigset_t *__restrict __set,
   sigset_t *__restrict __oset) __attribute__ ((__nothrow__));
extern int sigsuspend (__const sigset_t *__set) __attribute__ ((__nonnull__ (1)));
extern int sigaction (int __sig, __const struct sigaction *__restrict __act,
        struct sigaction *__restrict __oact) __attribute__ ((__nothrow__));
extern int sigpending (sigset_t *__set) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
extern int sigwait (__const sigset_t *__restrict __set, int *__restrict __sig)
     __attribute__ ((__nonnull__ (1, 2)));
extern int sigwaitinfo (__const sigset_t *__restrict __set,
   siginfo_t *__restrict __info) __attribute__ ((__nonnull__ (1)));
extern int sigtimedwait (__const sigset_t *__restrict __set,
    siginfo_t *__restrict __info,
    __const struct timespec *__restrict __timeout)
     __attribute__ ((__nonnull__ (1)));
extern int sigqueue (__pid_t __pid, int __sig, __const union sigval __val)
     __attribute__ ((__nothrow__));
extern __const char *__const _sys_siglist[65];
extern __const char *__const sys_siglist[65];
struct sigvec
  {
    __sighandler_t sv_handler;
    int sv_mask;
    int sv_flags;
  };
extern int sigvec (int __sig, __const struct sigvec *__vec,
     struct sigvec *__ovec) __attribute__ ((__nothrow__));
struct _fpreg
{
  unsigned short significand[4];
  unsigned short exponent;
};
struct _fpxreg
{
  unsigned short significand[4];
  unsigned short exponent;
  unsigned short padding[3];
};
struct _xmmreg
{
  __uint32_t element[4];
};
struct _fpstate
{
  __uint16_t cwd;
  __uint16_t swd;
  __uint16_t ftw;
  __uint16_t fop;
  __uint64_t rip;
  __uint64_t rdp;
  __uint32_t mxcsr;
  __uint32_t mxcr_mask;
  struct _fpxreg _st[8];
  struct _xmmreg _xmm[16];
  __uint32_t padding[24];
};
struct sigcontext
{
  unsigned long r8;
  unsigned long r9;
  unsigned long r10;
  unsigned long r11;
  unsigned long r12;
  unsigned long r13;
  unsigned long r14;
  unsigned long r15;
  unsigned long rdi;
  unsigned long rsi;
  unsigned long rbp;
  unsigned long rbx;
  unsigned long rdx;
  unsigned long rax;
  unsigned long rcx;
  unsigned long rsp;
  unsigned long rip;
  unsigned long eflags;
  unsigned short cs;
  unsigned short gs;
  unsigned short fs;
  unsigned short __pad0;
  unsigned long err;
  unsigned long trapno;
  unsigned long oldmask;
  unsigned long cr2;
  struct _fpstate * fpstate;
  unsigned long __reserved1 [8];
};
extern int sigreturn (struct sigcontext *__scp) __attribute__ ((__nothrow__));
typedef long unsigned int size_t;
extern int siginterrupt (int __sig, int __interrupt) __attribute__ ((__nothrow__));
struct sigstack
  {
    void *ss_sp;
    int ss_onstack;
  };
enum
{
  SS_ONSTACK = 1,
  SS_DISABLE
};
typedef struct sigaltstack
  {
    void *ss_sp;
    int ss_flags;
    size_t ss_size;
  } stack_t;
typedef long int greg_t;
typedef greg_t gregset_t[23];
struct _libc_fpxreg
{
  unsigned short int significand[4];
  unsigned short int exponent;
  unsigned short int padding[3];
};
struct _libc_xmmreg
{
  __uint32_t element[4];
};
struct _libc_fpstate
{
  __uint16_t cwd;
  __uint16_t swd;
  __uint16_t ftw;
  __uint16_t fop;
  __uint64_t rip;
  __uint64_t rdp;
  __uint32_t mxcsr;
  __uint32_t mxcr_mask;
  struct _libc_fpxreg _st[8];
  struct _libc_xmmreg _xmm[16];
  __uint32_t padding[24];
};
typedef struct _libc_fpstate *fpregset_t;
typedef struct
  {
    gregset_t gregs;
    fpregset_t fpregs;
    unsigned long __reserved1 [8];
} mcontext_t;
typedef struct ucontext
  {
    unsigned long int uc_flags;
    struct ucontext *uc_link;
    stack_t uc_stack;
    mcontext_t uc_mcontext;
    __sigset_t uc_sigmask;
    struct _libc_fpstate __fpregs_mem;
  } ucontext_t;
extern int sigstack (struct sigstack *__ss, struct sigstack *__oss)
     __attribute__ ((__nothrow__)) __attribute__ ((__deprecated__));
extern int sigaltstack (__const struct sigaltstack *__restrict __ss,
   struct sigaltstack *__restrict __oss) __attribute__ ((__nothrow__));
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
extern int pthread_sigmask (int __how,
       __const __sigset_t *__restrict __newmask,
       __sigset_t *__restrict __oldmask)__attribute__ ((__nothrow__));
extern int pthread_kill (pthread_t __threadid, int __signo) __attribute__ ((__nothrow__));
extern int __libc_current_sigrtmin (void) __attribute__ ((__nothrow__));
extern int __libc_current_sigrtmax (void) __attribute__ ((__nothrow__));

enum __rlimit_resource
{
  RLIMIT_CPU = 0,
  RLIMIT_FSIZE = 1,
  RLIMIT_DATA = 2,
  RLIMIT_STACK = 3,
  RLIMIT_CORE = 4,
  __RLIMIT_RSS = 5,
  RLIMIT_NOFILE = 7,
  __RLIMIT_OFILE = RLIMIT_NOFILE,
  RLIMIT_AS = 9,
  __RLIMIT_NPROC = 6,
  __RLIMIT_MEMLOCK = 8,
  __RLIMIT_LOCKS = 10,
  __RLIMIT_SIGPENDING = 11,
  __RLIMIT_MSGQUEUE = 12,
  __RLIMIT_NICE = 13,
  __RLIMIT_RTPRIO = 14,
  __RLIMIT_RTTIME = 15,
  __RLIMIT_NLIMITS = 16,
  __RLIM_NLIMITS = __RLIMIT_NLIMITS
};
typedef __rlim_t rlim_t;
struct rlimit
  {
    rlim_t rlim_cur;
    rlim_t rlim_max;
  };
enum __rusage_who
{
  RUSAGE_SELF = 0,
  RUSAGE_CHILDREN = -1
};
struct timeval
  {
    __time_t tv_sec;
    __suseconds_t tv_usec;
  };
struct rusage
  {
    struct timeval ru_utime;
    struct timeval ru_stime;
    long int ru_maxrss;
    long int ru_ixrss;
    long int ru_idrss;
    long int ru_isrss;
    long int ru_minflt;
    long int ru_majflt;
    long int ru_nswap;
    long int ru_inblock;
    long int ru_oublock;
    long int ru_msgsnd;
    long int ru_msgrcv;
    long int ru_nsignals;
    long int ru_nvcsw;
    long int ru_nivcsw;
  };
enum __priority_which
{
  PRIO_PROCESS = 0,
  PRIO_PGRP = 1,
  PRIO_USER = 2
};


typedef __id_t id_t;

typedef int __rlimit_resource_t;
typedef int __rusage_who_t;
typedef int __priority_which_t;
extern int getrlimit (__rlimit_resource_t __resource,
        struct rlimit *__rlimits) __attribute__ ((__nothrow__));
extern int setrlimit (__rlimit_resource_t __resource,
        __const struct rlimit *__rlimits) __attribute__ ((__nothrow__));
extern int getrusage (__rusage_who_t __who, struct rusage *__usage) __attribute__ ((__nothrow__));
extern int getpriority (__priority_which_t __which, id_t __who) __attribute__ ((__nothrow__));
extern int setpriority (__priority_which_t __which, id_t __who, int __prio)
     __attribute__ ((__nothrow__));

typedef union
  {
    union wait *__uptr;
    int *__iptr;
  } __WAIT_STATUS __attribute__ ((__transparent_union__));
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
typedef enum
{
  P_ALL,
  P_PID,
  P_PGID
} idtype_t;
extern __pid_t wait (__WAIT_STATUS __stat_loc);
extern __pid_t waitpid (__pid_t __pid, int *__stat_loc, int __options);
extern int waitid (idtype_t __idtype, __id_t __id, siginfo_t *__infop,
     int __options);
struct rusage;
extern __pid_t wait3 (__WAIT_STATUS __stat_loc, int __options,
        struct rusage * __usage) __attribute__ ((__nothrow__));
extern __pid_t wait4 (__pid_t __pid, __WAIT_STATUS __stat_loc, int __options,
        struct rusage *__usage) __attribute__ ((__nothrow__));


enum
{
  _ISupper = ((0) < 8 ? ((1 << (0)) << 8) : ((1 << (0)) >> 8)),
  _ISlower = ((1) < 8 ? ((1 << (1)) << 8) : ((1 << (1)) >> 8)),
  _ISalpha = ((2) < 8 ? ((1 << (2)) << 8) : ((1 << (2)) >> 8)),
  _ISdigit = ((3) < 8 ? ((1 << (3)) << 8) : ((1 << (3)) >> 8)),
  _ISxdigit = ((4) < 8 ? ((1 << (4)) << 8) : ((1 << (4)) >> 8)),
  _ISspace = ((5) < 8 ? ((1 << (5)) << 8) : ((1 << (5)) >> 8)),
  _ISprint = ((6) < 8 ? ((1 << (6)) << 8) : ((1 << (6)) >> 8)),
  _ISgraph = ((7) < 8 ? ((1 << (7)) << 8) : ((1 << (7)) >> 8)),
  _ISblank = ((8) < 8 ? ((1 << (8)) << 8) : ((1 << (8)) >> 8)),
  _IScntrl = ((9) < 8 ? ((1 << (9)) << 8) : ((1 << (9)) >> 8)),
  _ISpunct = ((10) < 8 ? ((1 << (10)) << 8) : ((1 << (10)) >> 8)),
  _ISalnum = ((11) < 8 ? ((1 << (11)) << 8) : ((1 << (11)) >> 8))
};
extern __const unsigned short int **__ctype_b_loc (void)
     __attribute__ ((__nothrow__)) __attribute__ ((__const));
extern __const __int32_t **__ctype_tolower_loc (void)
     __attribute__ ((__nothrow__)) __attribute__ ((__const));
extern __const __int32_t **__ctype_toupper_loc (void)
     __attribute__ ((__nothrow__)) __attribute__ ((__const));

extern int isalnum (int) __attribute__ ((__nothrow__));
extern int isalpha (int) __attribute__ ((__nothrow__));
extern int iscntrl (int) __attribute__ ((__nothrow__));
extern int isdigit (int) __attribute__ ((__nothrow__));
extern int islower (int) __attribute__ ((__nothrow__));
extern int isgraph (int) __attribute__ ((__nothrow__));
extern int isprint (int) __attribute__ ((__nothrow__));
extern int ispunct (int) __attribute__ ((__nothrow__));
extern int isspace (int) __attribute__ ((__nothrow__));
extern int isupper (int) __attribute__ ((__nothrow__));
extern int isxdigit (int) __attribute__ ((__nothrow__));
extern int tolower (int __c) __attribute__ ((__nothrow__));
extern int toupper (int __c) __attribute__ ((__nothrow__));


extern int isblank (int) __attribute__ ((__nothrow__));

extern int isascii (int __c) __attribute__ ((__nothrow__));
extern int toascii (int __c) __attribute__ ((__nothrow__));
extern int _toupper (int) __attribute__ ((__nothrow__));
extern int _tolower (int) __attribute__ ((__nothrow__));
typedef struct __locale_struct
{
  struct __locale_data *__locales[13];
  const unsigned short int *__ctype_b;
  const int *__ctype_tolower;
  const int *__ctype_toupper;
  const char *__names[13];
} *__locale_t;
typedef __locale_t locale_t;
extern int isalnum_l (int, __locale_t) __attribute__ ((__nothrow__));
extern int isalpha_l (int, __locale_t) __attribute__ ((__nothrow__));
extern int iscntrl_l (int, __locale_t) __attribute__ ((__nothrow__));
extern int isdigit_l (int, __locale_t) __attribute__ ((__nothrow__));
extern int islower_l (int, __locale_t) __attribute__ ((__nothrow__));
extern int isgraph_l (int, __locale_t) __attribute__ ((__nothrow__));
extern int isprint_l (int, __locale_t) __attribute__ ((__nothrow__));
extern int ispunct_l (int, __locale_t) __attribute__ ((__nothrow__));
extern int isspace_l (int, __locale_t) __attribute__ ((__nothrow__));
extern int isupper_l (int, __locale_t) __attribute__ ((__nothrow__));
extern int isxdigit_l (int, __locale_t) __attribute__ ((__nothrow__));
extern int isblank_l (int, __locale_t) __attribute__ ((__nothrow__));
extern int __tolower_l (int __c, __locale_t __l) __attribute__ ((__nothrow__));
extern int tolower_l (int __c, __locale_t __l) __attribute__ ((__nothrow__));
extern int __toupper_l (int __c, __locale_t __l) __attribute__ ((__nothrow__));
extern int toupper_l (int __c, __locale_t __l) __attribute__ ((__nothrow__));


extern int *__errno_location (void) __attribute__ ((__nothrow__)) __attribute__ ((__const__));



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
typedef __off_t off_t;
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

struct flock
  {
    short int l_type;
    short int l_whence;
    __off_t l_start;
    __off_t l_len;
    __pid_t l_pid;
  };


struct stat
  {
    __dev_t st_dev;
    __ino_t st_ino;
    __nlink_t st_nlink;
    __mode_t st_mode;
    __uid_t st_uid;
    __gid_t st_gid;
    int __pad0;
    __dev_t st_rdev;
    __off_t st_size;
    __blksize_t st_blksize;
    __blkcnt_t st_blocks;
    struct timespec st_atim;
    struct timespec st_mtim;
    struct timespec st_ctim;
    long int __unused[3];
  };
extern int fcntl (int __fd, int __cmd, ...);
extern int open (__const char *__file, int __oflag, ...) __attribute__ ((__nonnull__ (1)));
extern int openat (int __fd, __const char *__file, int __oflag, ...)
     __attribute__ ((__nonnull__ (2)));
extern int creat (__const char *__file, __mode_t __mode) __attribute__ ((__nonnull__ (1)));
extern int lockf (int __fd, int __cmd, __off_t __len);
extern int posix_fadvise (int __fd, __off_t __offset, __off_t __len,
     int __advise) __attribute__ ((__nothrow__));
extern int posix_fallocate (int __fd, __off_t __offset, __off_t __len);

typedef __builtin_va_list __gnuc_va_list;
typedef __gnuc_va_list va_list;
typedef int wchar_t;


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


typedef unsigned char cc_t;
typedef unsigned int speed_t;
typedef unsigned int tcflag_t;
struct termios
  {
    tcflag_t c_iflag;
    tcflag_t c_oflag;
    tcflag_t c_cflag;
    tcflag_t c_lflag;
    cc_t c_line;
    cc_t c_cc[32];
    speed_t c_ispeed;
    speed_t c_ospeed;
  };
extern speed_t cfgetospeed (__const struct termios *__termios_p) __attribute__ ((__nothrow__));
extern speed_t cfgetispeed (__const struct termios *__termios_p) __attribute__ ((__nothrow__));
extern int cfsetospeed (struct termios *__termios_p, speed_t __speed) __attribute__ ((__nothrow__));
extern int cfsetispeed (struct termios *__termios_p, speed_t __speed) __attribute__ ((__nothrow__));
extern int cfsetspeed (struct termios *__termios_p, speed_t __speed) __attribute__ ((__nothrow__));
extern int tcgetattr (int __fd, struct termios *__termios_p) __attribute__ ((__nothrow__));
extern int tcsetattr (int __fd, int __optional_actions,
        __const struct termios *__termios_p) __attribute__ ((__nothrow__));
extern void cfmakeraw (struct termios *__termios_p) __attribute__ ((__nothrow__));
extern int tcsendbreak (int __fd, int __duration) __attribute__ ((__nothrow__));
extern int tcdrain (int __fd);
extern int tcflush (int __fd, int __queue_selector) __attribute__ ((__nothrow__));
extern int tcflow (int __fd, int __action) __attribute__ ((__nothrow__));


typedef __useconds_t useconds_t;
typedef __intptr_t intptr_t;
typedef __socklen_t socklen_t;
extern int access (__const char *__name, int __type) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
extern int faccessat (int __fd, __const char *__file, int __type, int __flag)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2))) ;
extern __off_t lseek (int __fd, __off_t __offset, int __whence) __attribute__ ((__nothrow__));
extern int close (int __fd);
extern ssize_t read (int __fd, void *__buf, size_t __nbytes) ;
extern ssize_t write (int __fd, __const void *__buf, size_t __n) ;
extern ssize_t pread (int __fd, void *__buf, size_t __nbytes,
        __off_t __offset) ;
extern ssize_t pwrite (int __fd, __const void *__buf, size_t __n,
         __off_t __offset) ;
extern int pipe (int __pipedes[2]) __attribute__ ((__nothrow__)) ;
extern unsigned int alarm (unsigned int __seconds) __attribute__ ((__nothrow__));
extern unsigned int sleep (unsigned int __seconds);
extern __useconds_t ualarm (__useconds_t __value, __useconds_t __interval)
     __attribute__ ((__nothrow__));
extern int usleep (__useconds_t __useconds);
extern int pause (void);
extern int chown (__const char *__file, __uid_t __owner, __gid_t __group)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;
extern int fchown (int __fd, __uid_t __owner, __gid_t __group) __attribute__ ((__nothrow__)) ;
extern int lchown (__const char *__file, __uid_t __owner, __gid_t __group)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;
extern int fchownat (int __fd, __const char *__file, __uid_t __owner,
       __gid_t __group, int __flag)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2))) ;
extern int chdir (__const char *__path) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;
extern int fchdir (int __fd) __attribute__ ((__nothrow__)) ;
extern char *getcwd (char *__buf, size_t __size) __attribute__ ((__nothrow__)) ;
extern char *getwd (char *__buf)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) __attribute__ ((__deprecated__)) ;
extern int dup (int __fd) __attribute__ ((__nothrow__)) ;
extern int dup2 (int __fd, int __fd2) __attribute__ ((__nothrow__));
extern char **__environ;
extern int execve (__const char *__path, char *__const __argv[],
     char *__const __envp[]) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern int fexecve (int __fd, char *__const __argv[], char *__const __envp[])
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2)));
extern int execv (__const char *__path, char *__const __argv[])
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern int execle (__const char *__path, __const char *__arg, ...)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern int execl (__const char *__path, __const char *__arg, ...)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern int execvp (__const char *__file, char *__const __argv[])
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern int execlp (__const char *__file, __const char *__arg, ...)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern int nice (int __inc) __attribute__ ((__nothrow__)) ;
extern void _exit (int __status) __attribute__ ((__noreturn__));
enum
  {
    _PC_LINK_MAX,
    _PC_MAX_CANON,
    _PC_MAX_INPUT,
    _PC_NAME_MAX,
    _PC_PATH_MAX,
    _PC_PIPE_BUF,
    _PC_CHOWN_RESTRICTED,
    _PC_NO_TRUNC,
    _PC_VDISABLE,
    _PC_SYNC_IO,
    _PC_ASYNC_IO,
    _PC_PRIO_IO,
    _PC_SOCK_MAXBUF,
    _PC_FILESIZEBITS,
    _PC_REC_INCR_XFER_SIZE,
    _PC_REC_MAX_XFER_SIZE,
    _PC_REC_MIN_XFER_SIZE,
    _PC_REC_XFER_ALIGN,
    _PC_ALLOC_SIZE_MIN,
    _PC_SYMLINK_MAX,
    _PC_2_SYMLINKS
  };
enum
  {
    _SC_ARG_MAX,
    _SC_CHILD_MAX,
    _SC_CLK_TCK,
    _SC_NGROUPS_MAX,
    _SC_OPEN_MAX,
    _SC_STREAM_MAX,
    _SC_TZNAME_MAX,
    _SC_JOB_CONTROL,
    _SC_SAVED_IDS,
    _SC_REALTIME_SIGNALS,
    _SC_PRIORITY_SCHEDULING,
    _SC_TIMERS,
    _SC_ASYNCHRONOUS_IO,
    _SC_PRIORITIZED_IO,
    _SC_SYNCHRONIZED_IO,
    _SC_FSYNC,
    _SC_MAPPED_FILES,
    _SC_MEMLOCK,
    _SC_MEMLOCK_RANGE,
    _SC_MEMORY_PROTECTION,
    _SC_MESSAGE_PASSING,
    _SC_SEMAPHORES,
    _SC_SHARED_MEMORY_OBJECTS,
    _SC_AIO_LISTIO_MAX,
    _SC_AIO_MAX,
    _SC_AIO_PRIO_DELTA_MAX,
    _SC_DELAYTIMER_MAX,
    _SC_MQ_OPEN_MAX,
    _SC_MQ_PRIO_MAX,
    _SC_VERSION,
    _SC_PAGESIZE,
    _SC_RTSIG_MAX,
    _SC_SEM_NSEMS_MAX,
    _SC_SEM_VALUE_MAX,
    _SC_SIGQUEUE_MAX,
    _SC_TIMER_MAX,
    _SC_BC_BASE_MAX,
    _SC_BC_DIM_MAX,
    _SC_BC_SCALE_MAX,
    _SC_BC_STRING_MAX,
    _SC_COLL_WEIGHTS_MAX,
    _SC_EQUIV_CLASS_MAX,
    _SC_EXPR_NEST_MAX,
    _SC_LINE_MAX,
    _SC_RE_DUP_MAX,
    _SC_CHARCLASS_NAME_MAX,
    _SC_2_VERSION,
    _SC_2_C_BIND,
    _SC_2_C_DEV,
    _SC_2_FORT_DEV,
    _SC_2_FORT_RUN,
    _SC_2_SW_DEV,
    _SC_2_LOCALEDEF,
    _SC_PII,
    _SC_PII_XTI,
    _SC_PII_SOCKET,
    _SC_PII_INTERNET,
    _SC_PII_OSI,
    _SC_POLL,
    _SC_SELECT,
    _SC_UIO_MAXIOV,
    _SC_IOV_MAX = _SC_UIO_MAXIOV,
    _SC_PII_INTERNET_STREAM,
    _SC_PII_INTERNET_DGRAM,
    _SC_PII_OSI_COTS,
    _SC_PII_OSI_CLTS,
    _SC_PII_OSI_M,
    _SC_T_IOV_MAX,
    _SC_THREADS,
    _SC_THREAD_SAFE_FUNCTIONS,
    _SC_GETGR_R_SIZE_MAX,
    _SC_GETPW_R_SIZE_MAX,
    _SC_LOGIN_NAME_MAX,
    _SC_TTY_NAME_MAX,
    _SC_THREAD_DESTRUCTOR_ITERATIONS,
    _SC_THREAD_KEYS_MAX,
    _SC_THREAD_STACK_MIN,
    _SC_THREAD_THREADS_MAX,
    _SC_THREAD_ATTR_STACKADDR,
    _SC_THREAD_ATTR_STACKSIZE,
    _SC_THREAD_PRIORITY_SCHEDULING,
    _SC_THREAD_PRIO_INHERIT,
    _SC_THREAD_PRIO_PROTECT,
    _SC_THREAD_PROCESS_SHARED,
    _SC_NPROCESSORS_CONF,
    _SC_NPROCESSORS_ONLN,
    _SC_PHYS_PAGES,
    _SC_AVPHYS_PAGES,
    _SC_ATEXIT_MAX,
    _SC_PASS_MAX,
    _SC_XOPEN_VERSION,
    _SC_XOPEN_XCU_VERSION,
    _SC_XOPEN_UNIX,
    _SC_XOPEN_CRYPT,
    _SC_XOPEN_ENH_I18N,
    _SC_XOPEN_SHM,
    _SC_2_CHAR_TERM,
    _SC_2_C_VERSION,
    _SC_2_UPE,
    _SC_XOPEN_XPG2,
    _SC_XOPEN_XPG3,
    _SC_XOPEN_XPG4,
    _SC_CHAR_BIT,
    _SC_CHAR_MAX,
    _SC_CHAR_MIN,
    _SC_INT_MAX,
    _SC_INT_MIN,
    _SC_LONG_BIT,
    _SC_WORD_BIT,
    _SC_MB_LEN_MAX,
    _SC_NZERO,
    _SC_SSIZE_MAX,
    _SC_SCHAR_MAX,
    _SC_SCHAR_MIN,
    _SC_SHRT_MAX,
    _SC_SHRT_MIN,
    _SC_UCHAR_MAX,
    _SC_UINT_MAX,
    _SC_ULONG_MAX,
    _SC_USHRT_MAX,
    _SC_NL_ARGMAX,
    _SC_NL_LANGMAX,
    _SC_NL_MSGMAX,
    _SC_NL_NMAX,
    _SC_NL_SETMAX,
    _SC_NL_TEXTMAX,
    _SC_XBS5_ILP32_OFF32,
    _SC_XBS5_ILP32_OFFBIG,
    _SC_XBS5_LP64_OFF64,
    _SC_XBS5_LPBIG_OFFBIG,
    _SC_XOPEN_LEGACY,
    _SC_XOPEN_REALTIME,
    _SC_XOPEN_REALTIME_THREADS,
    _SC_ADVISORY_INFO,
    _SC_BARRIERS,
    _SC_BASE,
    _SC_C_LANG_SUPPORT,
    _SC_C_LANG_SUPPORT_R,
    _SC_CLOCK_SELECTION,
    _SC_CPUTIME,
    _SC_THREAD_CPUTIME,
    _SC_DEVICE_IO,
    _SC_DEVICE_SPECIFIC,
    _SC_DEVICE_SPECIFIC_R,
    _SC_FD_MGMT,
    _SC_FIFO,
    _SC_PIPE,
    _SC_FILE_ATTRIBUTES,
    _SC_FILE_LOCKING,
    _SC_FILE_SYSTEM,
    _SC_MONOTONIC_CLOCK,
    _SC_MULTI_PROCESS,
    _SC_SINGLE_PROCESS,
    _SC_NETWORKING,
    _SC_READER_WRITER_LOCKS,
    _SC_SPIN_LOCKS,
    _SC_REGEXP,
    _SC_REGEX_VERSION,
    _SC_SHELL,
    _SC_SIGNALS,
    _SC_SPAWN,
    _SC_SPORADIC_SERVER,
    _SC_THREAD_SPORADIC_SERVER,
    _SC_SYSTEM_DATABASE,
    _SC_SYSTEM_DATABASE_R,
    _SC_TIMEOUTS,
    _SC_TYPED_MEMORY_OBJECTS,
    _SC_USER_GROUPS,
    _SC_USER_GROUPS_R,
    _SC_2_PBS,
    _SC_2_PBS_ACCOUNTING,
    _SC_2_PBS_LOCATE,
    _SC_2_PBS_MESSAGE,
    _SC_2_PBS_TRACK,
    _SC_SYMLOOP_MAX,
    _SC_STREAMS,
    _SC_2_PBS_CHECKPOINT,
    _SC_V6_ILP32_OFF32,
    _SC_V6_ILP32_OFFBIG,
    _SC_V6_LP64_OFF64,
    _SC_V6_LPBIG_OFFBIG,
    _SC_HOST_NAME_MAX,
    _SC_TRACE,
    _SC_TRACE_EVENT_FILTER,
    _SC_TRACE_INHERIT,
    _SC_TRACE_LOG,
    _SC_LEVEL1_ICACHE_SIZE,
    _SC_LEVEL1_ICACHE_ASSOC,
    _SC_LEVEL1_ICACHE_LINESIZE,
    _SC_LEVEL1_DCACHE_SIZE,
    _SC_LEVEL1_DCACHE_ASSOC,
    _SC_LEVEL1_DCACHE_LINESIZE,
    _SC_LEVEL2_CACHE_SIZE,
    _SC_LEVEL2_CACHE_ASSOC,
    _SC_LEVEL2_CACHE_LINESIZE,
    _SC_LEVEL3_CACHE_SIZE,
    _SC_LEVEL3_CACHE_ASSOC,
    _SC_LEVEL3_CACHE_LINESIZE,
    _SC_LEVEL4_CACHE_SIZE,
    _SC_LEVEL4_CACHE_ASSOC,
    _SC_LEVEL4_CACHE_LINESIZE,
    _SC_IPV6 = _SC_LEVEL1_ICACHE_SIZE + 50,
    _SC_RAW_SOCKETS,
    _SC_V7_ILP32_OFF32,
    _SC_V7_ILP32_OFFBIG,
    _SC_V7_LP64_OFF64,
    _SC_V7_LPBIG_OFFBIG,
    _SC_SS_REPL_MAX,
    _SC_TRACE_EVENT_NAME_MAX,
    _SC_TRACE_NAME_MAX,
    _SC_TRACE_SYS_MAX,
    _SC_TRACE_USER_EVENT_MAX,
    _SC_XOPEN_STREAMS,
    _SC_THREAD_ROBUST_PRIO_INHERIT,
    _SC_THREAD_ROBUST_PRIO_PROTECT
  };
enum
  {
    _CS_PATH,
    _CS_V6_WIDTH_RESTRICTED_ENVS,
    _CS_GNU_LIBC_VERSION,
    _CS_GNU_LIBPTHREAD_VERSION,
    _CS_V5_WIDTH_RESTRICTED_ENVS,
    _CS_V7_WIDTH_RESTRICTED_ENVS,
    _CS_LFS_CFLAGS = 1000,
    _CS_LFS_LDFLAGS,
    _CS_LFS_LIBS,
    _CS_LFS_LINTFLAGS,
    _CS_LFS64_CFLAGS,
    _CS_LFS64_LDFLAGS,
    _CS_LFS64_LIBS,
    _CS_LFS64_LINTFLAGS,
    _CS_XBS5_ILP32_OFF32_CFLAGS = 1100,
    _CS_XBS5_ILP32_OFF32_LDFLAGS,
    _CS_XBS5_ILP32_OFF32_LIBS,
    _CS_XBS5_ILP32_OFF32_LINTFLAGS,
    _CS_XBS5_ILP32_OFFBIG_CFLAGS,
    _CS_XBS5_ILP32_OFFBIG_LDFLAGS,
    _CS_XBS5_ILP32_OFFBIG_LIBS,
    _CS_XBS5_ILP32_OFFBIG_LINTFLAGS,
    _CS_XBS5_LP64_OFF64_CFLAGS,
    _CS_XBS5_LP64_OFF64_LDFLAGS,
    _CS_XBS5_LP64_OFF64_LIBS,
    _CS_XBS5_LP64_OFF64_LINTFLAGS,
    _CS_XBS5_LPBIG_OFFBIG_CFLAGS,
    _CS_XBS5_LPBIG_OFFBIG_LDFLAGS,
    _CS_XBS5_LPBIG_OFFBIG_LIBS,
    _CS_XBS5_LPBIG_OFFBIG_LINTFLAGS,
    _CS_POSIX_V6_ILP32_OFF32_CFLAGS,
    _CS_POSIX_V6_ILP32_OFF32_LDFLAGS,
    _CS_POSIX_V6_ILP32_OFF32_LIBS,
    _CS_POSIX_V6_ILP32_OFF32_LINTFLAGS,
    _CS_POSIX_V6_ILP32_OFFBIG_CFLAGS,
    _CS_POSIX_V6_ILP32_OFFBIG_LDFLAGS,
    _CS_POSIX_V6_ILP32_OFFBIG_LIBS,
    _CS_POSIX_V6_ILP32_OFFBIG_LINTFLAGS,
    _CS_POSIX_V6_LP64_OFF64_CFLAGS,
    _CS_POSIX_V6_LP64_OFF64_LDFLAGS,
    _CS_POSIX_V6_LP64_OFF64_LIBS,
    _CS_POSIX_V6_LP64_OFF64_LINTFLAGS,
    _CS_POSIX_V6_LPBIG_OFFBIG_CFLAGS,
    _CS_POSIX_V6_LPBIG_OFFBIG_LDFLAGS,
    _CS_POSIX_V6_LPBIG_OFFBIG_LIBS,
    _CS_POSIX_V6_LPBIG_OFFBIG_LINTFLAGS,
    _CS_POSIX_V7_ILP32_OFF32_CFLAGS,
    _CS_POSIX_V7_ILP32_OFF32_LDFLAGS,
    _CS_POSIX_V7_ILP32_OFF32_LIBS,
    _CS_POSIX_V7_ILP32_OFF32_LINTFLAGS,
    _CS_POSIX_V7_ILP32_OFFBIG_CFLAGS,
    _CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS,
    _CS_POSIX_V7_ILP32_OFFBIG_LIBS,
    _CS_POSIX_V7_ILP32_OFFBIG_LINTFLAGS,
    _CS_POSIX_V7_LP64_OFF64_CFLAGS,
    _CS_POSIX_V7_LP64_OFF64_LDFLAGS,
    _CS_POSIX_V7_LP64_OFF64_LIBS,
    _CS_POSIX_V7_LP64_OFF64_LINTFLAGS,
    _CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS,
    _CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS,
    _CS_POSIX_V7_LPBIG_OFFBIG_LIBS,
    _CS_POSIX_V7_LPBIG_OFFBIG_LINTFLAGS,
    _CS_V6_ENV,
    _CS_V7_ENV
  };
extern long int pathconf (__const char *__path, int __name)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
extern long int fpathconf (int __fd, int __name) __attribute__ ((__nothrow__));
extern long int sysconf (int __name) __attribute__ ((__nothrow__));
extern size_t confstr (int __name, char *__buf, size_t __len) __attribute__ ((__nothrow__));
extern __pid_t getpid (void) __attribute__ ((__nothrow__));
extern __pid_t getppid (void) __attribute__ ((__nothrow__));
extern __pid_t getpgrp (void) __attribute__ ((__nothrow__));
extern __pid_t __getpgid (__pid_t __pid) __attribute__ ((__nothrow__));
extern __pid_t getpgid (__pid_t __pid) __attribute__ ((__nothrow__));
extern int setpgid (__pid_t __pid, __pid_t __pgid) __attribute__ ((__nothrow__));
extern int setpgrp (void) __attribute__ ((__nothrow__));
extern __pid_t setsid (void) __attribute__ ((__nothrow__));
extern __pid_t getsid (__pid_t __pid) __attribute__ ((__nothrow__));
extern __uid_t getuid (void) __attribute__ ((__nothrow__));
extern __uid_t geteuid (void) __attribute__ ((__nothrow__));
extern __gid_t getgid (void) __attribute__ ((__nothrow__));
extern __gid_t getegid (void) __attribute__ ((__nothrow__));
extern int getgroups (int __size, __gid_t __list[]) __attribute__ ((__nothrow__)) ;
extern int setuid (__uid_t __uid) __attribute__ ((__nothrow__));
extern int setreuid (__uid_t __ruid, __uid_t __euid) __attribute__ ((__nothrow__));
extern int seteuid (__uid_t __uid) __attribute__ ((__nothrow__));
extern int setgid (__gid_t __gid) __attribute__ ((__nothrow__));
extern int setregid (__gid_t __rgid, __gid_t __egid) __attribute__ ((__nothrow__));
extern int setegid (__gid_t __gid) __attribute__ ((__nothrow__));
extern __pid_t fork (void) __attribute__ ((__nothrow__));
extern __pid_t vfork (void) __attribute__ ((__nothrow__));
extern char *ttyname (int __fd) __attribute__ ((__nothrow__));
extern int ttyname_r (int __fd, char *__buf, size_t __buflen)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2))) ;
extern int isatty (int __fd) __attribute__ ((__nothrow__));
extern int ttyslot (void) __attribute__ ((__nothrow__));
extern int link (__const char *__from, __const char *__to)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2))) ;
extern int linkat (int __fromfd, __const char *__from, int __tofd,
     __const char *__to, int __flags)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2, 4))) ;
extern int symlink (__const char *__from, __const char *__to)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2))) ;
extern ssize_t readlink (__const char *__restrict __path,
    char *__restrict __buf, size_t __len)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2))) ;
extern int symlinkat (__const char *__from, int __tofd,
        __const char *__to) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 3))) ;
extern ssize_t readlinkat (int __fd, __const char *__restrict __path,
      char *__restrict __buf, size_t __len)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2, 3))) ;
extern int unlink (__const char *__name) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
extern int unlinkat (int __fd, __const char *__name, int __flag)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2)));
extern int rmdir (__const char *__path) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
extern __pid_t tcgetpgrp (int __fd) __attribute__ ((__nothrow__));
extern int tcsetpgrp (int __fd, __pid_t __pgrp_id) __attribute__ ((__nothrow__));
extern char *getlogin (void);
extern int getlogin_r (char *__name, size_t __name_len) __attribute__ ((__nonnull__ (1)));
extern int setlogin (__const char *__name) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
extern char *optarg;
extern int optind;
extern int opterr;
extern int optopt;
extern int getopt (int ___argc, char *const *___argv, const char *__shortopts)
       __attribute__ ((__nothrow__));
extern int gethostname (char *__name, size_t __len) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
extern int sethostname (__const char *__name, size_t __len)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;
extern int sethostid (long int __id) __attribute__ ((__nothrow__)) ;
extern int getdomainname (char *__name, size_t __len)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;
extern int setdomainname (__const char *__name, size_t __len)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;
extern int vhangup (void) __attribute__ ((__nothrow__));
extern int revoke (__const char *__file) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;
extern int profil (unsigned short int *__sample_buffer, size_t __size,
     size_t __offset, unsigned int __scale)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
extern int acct (__const char *__name) __attribute__ ((__nothrow__));
extern char *getusershell (void) __attribute__ ((__nothrow__));
extern void endusershell (void) __attribute__ ((__nothrow__));
extern void setusershell (void) __attribute__ ((__nothrow__));
extern int daemon (int __nochdir, int __noclose) __attribute__ ((__nothrow__)) ;
extern int chroot (__const char *__path) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;
extern char *getpass (__const char *__prompt) __attribute__ ((__nonnull__ (1)));
extern int fsync (int __fd);
extern long int gethostid (void);
extern void sync (void) __attribute__ ((__nothrow__));
extern int getpagesize (void) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern int getdtablesize (void) __attribute__ ((__nothrow__));
extern int truncate (__const char *__file, __off_t __length)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1))) ;
extern int ftruncate (int __fd, __off_t __length) __attribute__ ((__nothrow__)) ;
extern int brk (void *__addr) __attribute__ ((__nothrow__)) ;
extern void *sbrk (intptr_t __delta) __attribute__ ((__nothrow__));
extern long int syscall (long int __sysno, ...) __attribute__ ((__nothrow__));
extern int fdatasync (int __fildes);
extern char *ctermid (char *__s) __attribute__ ((__nothrow__));

enum
{
  __LC_CTYPE = 0,
  __LC_NUMERIC = 1,
  __LC_TIME = 2,
  __LC_COLLATE = 3,
  __LC_MONETARY = 4,
  __LC_MESSAGES = 5,
  __LC_ALL = 6,
  __LC_PAPER = 7,
  __LC_NAME = 8,
  __LC_ADDRESS = 9,
  __LC_TELEPHONE = 10,
  __LC_MEASUREMENT = 11,
  __LC_IDENTIFICATION = 12
};


struct lconv
{
  char *decimal_point;
  char *thousands_sep;
  char *grouping;
  char *int_curr_symbol;
  char *currency_symbol;
  char *mon_decimal_point;
  char *mon_thousands_sep;
  char *mon_grouping;
  char *positive_sign;
  char *negative_sign;
  char int_frac_digits;
  char frac_digits;
  char p_cs_precedes;
  char p_sep_by_space;
  char n_cs_precedes;
  char n_sep_by_space;
  char p_sign_posn;
  char n_sign_posn;
  char int_p_cs_precedes;
  char int_p_sep_by_space;
  char int_n_cs_precedes;
  char int_n_sep_by_space;
  char int_p_sign_posn;
  char int_n_sign_posn;
};
extern char *setlocale (int __category, __const char *__locale) __attribute__ ((__nothrow__));
extern struct lconv *localeconv (void) __attribute__ ((__nothrow__));

extern __locale_t newlocale (int __category_mask, __const char *__locale,
        __locale_t __base) __attribute__ ((__nothrow__));
extern __locale_t duplocale (__locale_t __dataset) __attribute__ ((__nothrow__));
extern void freelocale (__locale_t __dataset) __attribute__ ((__nothrow__));
extern __locale_t uselocale (__locale_t __dataset) __attribute__ ((__nothrow__));


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
static char menu_backtitle[128];
static const char mconf_readme[] = ("Overview\n" "--------\n" "Some features may be built directly into busybox.\n" "Some may be made into standalone applets.  Some features\n" "may be completely removed altogether.  There are also certain\n" "parameters which are not really features, but must be\n" "entered in as decimal or hexadecimal numbers or possibly text.\n" "\n" "Menu items beginning with [*], <M> or [ ] represent features\n" "configured to be built in, modularized or removed respectively.\n" "Pointed brackets <> represent module capable features.\n" "\n" "To change any of these features, highlight it with the cursor\n" "keys and press <Y> to build it in, <M> to make it a module or\n" "<N> to removed it.  You may also press the <Space Bar> to cycle\n" "through the available options (ie. Y->N->M->Y).\n" "\n" "Some additional keyboard hints:\n" "\n" "Menus\n" "----------\n" "o  Use the Up/Down arrow keys (cursor keys) to highlight the item\n" "   you wish to change or submenu wish to select and press <Enter>.\n" "   Submenus are designated by \"--->\".\n" "\n" "   Shortcut: Press the option's highlighted letter (hotkey).\n" "             Pressing a hotkey more than once will sequence\n" "             through all visible items which use that hotkey.\n" "\n" "   You may also use the <PAGE UP> and <PAGE DOWN> keys to scroll\n" "   unseen options into view.\n" "\n" "o  To exit a menu use the cursor keys to highlight the <Exit> button\n" "   and press <ENTER>.\n" "\n" "   Shortcut: Press <ESC><ESC> or <E> or <X> if there is no hotkey\n" "             using those letters.  You may press a single <ESC>, but\n" "             there is a delayed response which you may find annoying.\n" "\n" "   Also, the <TAB> and cursor keys will cycle between <Select>,\n" "   <Exit> and <Help>\n" "\n" "o  To get help with an item, use the cursor keys to highlight <Help>\n" "   and Press <ENTER>.\n" "\n" "   Shortcut: Press <H> or <?>.\n" "\n" "\n" "Radiolists  (Choice lists)\n" "-----------\n" "o  Use the cursor keys to select the option you wish to set and press\n" "   <S> or the <SPACE BAR>.\n" "\n" "   Shortcut: Press the first letter of the option you wish to set then\n" "             press <S> or <SPACE BAR>.\n" "\n" "o  To see available help for the item, use the cursor keys to highlight\n" "   <Help> and Press <ENTER>.\n" "\n" "   Shortcut: Press <H> or <?>.\n" "\n" "   Also, the <TAB> and cursor keys will cycle between <Select> and\n" "   <Help>\n" "\n" "\n" "Data Entry\n" "-----------\n" "o  Enter the requested information and press <ENTER>\n" "   If you are entering hexadecimal values, it is not necessary to\n" "   add the '0x' prefix to the entry.\n" "\n" "o  For help, use the <TAB> or cursor keys to highlight the help option\n" "   and press <ENTER>.  You can try <TAB><H> as well.\n" "\n" "\n" "Text Box    (Help Window)\n" "--------\n" "o  Use the cursor keys to scroll up/down/left/right.  The VI editor\n" "   keys h,j,k,l function here as do <SPACE BAR> and <B> for those\n" "   who are familiar with less and lynx.\n" "\n" "o  Press <E>, <X>, <Enter> or <Esc><Esc> to exit.\n" "\n" "\n" "Alternate Configuration Files\n" "-----------------------------\n" "Menuconfig supports the use of alternate configuration files for\n" "those who, for various reasons, find it necessary to switch\n" "between different configurations.\n" "\n" "At the end of the main menu you will find two options.  One is\n" "for saving the current configuration to a file of your choosing.\n" "The other option is for loading a previously saved alternate\n" "configuration.\n" "\n" "Even if you don't use alternate configuration files, but you\n" "find during a Menuconfig session that you have completely messed\n" "up your settings, you may use the \"Load Alternate...\" option to\n" "restore your previously saved settings from \".config\" without\n" "restarting Menuconfig.\n" "\n" "Other information\n" "-----------------\n" "If you use Menuconfig in an XTERM window make sure you have your\n" "$TERM variable set to point to a xterm definition which supports color.\n" "Otherwise, Menuconfig will look rather bad.  Menuconfig will not\n" "display correctly in a RXVT window because rxvt displays only one\n" "intensity of color, bright.\n" "\n" "Menuconfig will display larger menus on screens or xterms which are\n" "set to display more than the standard 25 row by 80 column geometry.\n" "In order for this to work, the \"stty size\" command must be able to\n" "display the screen's current row and column geometry.  I STRONGLY\n" "RECOMMEND that you make sure you do NOT have the shell variables\n" "LINES and COLUMNS exported into your environment.  Some distributions\n" "export those variables via /etc/profile.  Some ncurses programs can\n" "become confused when those variables (LINES & COLUMNS) don't reflect\n" "the true screen size.\n" "\n" "Optional personality available\n" "------------------------------\n" "If you prefer to have all of the options listed in a single\n" "menu, rather than the default multimenu hierarchy, run the menuconfig\n" "with MENUCONFIG_MODE environment variable set to single_menu. Example:\n" "\n" "make MENUCONFIG_MODE=single_menu menuconfig\n" "\n" "<Enter> will then unroll the appropriate category, or enfold it if it\n" "is already unrolled.\n" "\n" "Note that this mode can eventually be a little more CPU expensive\n" "(especially with a larger number of unrolled categories) than the\n" "default mode.\n"),
menu_instructions[] = ("Arrow keys navigate the menu.  " "<Enter> selects submenus --->.  " "Highlighted letters are hotkeys.  " "Pressing <Y> includes, <N> excludes, <M> modularizes features.  " "Press <Esc><Esc> to exit, <?> for Help, </> for Search.  " "Legend: [*] built-in  [ ] excluded  <M> module  < > module capable"),
radiolist_instructions[] = ("Use the arrow keys to navigate this window or " "press the hotkey of the item you wish to select " "followed by the <SPACE BAR>. " "Press <?> for additional information about this option."),
inputbox_instructions_int[] = ("Please enter a decimal value. " "Fractions will not be accepted.  " "Use the <TAB> key to move from the input field to the buttons below it."),
inputbox_instructions_hex[] = ("Please enter a hexadecimal value. " "Use the <TAB> key to move from the input field to the buttons below it."),
inputbox_instructions_string[] = ("Please enter a string value. " "Use the <TAB> key to move from the input field to the buttons below it."),
setmod_text[] = ("This feature depends on another which has been configured as a module.\n" "As a result, this feature will be built as a module."),
nohelp_text[] = ("There is no help available for this option.\n"),
load_config_text[] = ("Enter the name of the configuration file you wish to load.  " "Accept the name shown to restore the configuration you " "last retrieved.  Leave blank to abort."),
load_config_help[] = ("\n" "For various reasons, one may wish to keep several different\n" "configurations available on a single machine.\n" "\n" "If you have saved a previous configuration in a file other than\n" "default, entering the name of the file here will allow you\n" "to modify that configuration.\n" "\n" "If you are uncertain, then you have probably never used alternate\n" "configuration files.  You should therefor leave this blank to abort.\n"),
save_config_text[] = ("Enter a filename to which this configuration should be saved " "as an alternate.  Leave blank to abort."),
save_config_help[] = ("\n" "For various reasons, one may wish to keep different\n" "configurations available on a single machine.\n" "\n" "Entering a file name here will allow you to later retrieve, modify\n" "and use the current configuration as an alternate to whatever\n" "configuration options you have selected at that time.\n" "\n" "If you are uncertain what all this means then you should probably\n" "leave this blank.\n"),
search_help[] = ("\n" "Search for CONFIG_ symbols and display their relations.\n" "Regular expressions are allowed.\n" "Example: search for \"^FOO\"\n" "Result:\n" "-----------------------------------------------------------------\n" "Symbol: FOO [=m]\n" "Prompt: Foo bus is used to drive the bar HW\n" "Defined at drivers/pci/Kconfig:47\n" "Depends on: X86_LOCAL_APIC && X86_IO_APIC || IA64\n" "Location:\n" "  -> Bus options (PCI, PCMCIA, EISA, MCA, ISA)\n" "    -> PCI support (PCI [=y])\n" "      -> PCI access mode (<choice> [=y])\n" "Selects: LIBCRC32\n" "Selected by: BAR\n" "-----------------------------------------------------------------\n" "o The line 'Prompt:' shows the text used in the menu structure for\n" "  this CONFIG_ symbol\n" "o The 'Defined at' line tell at what file / line number the symbol\n" "  is defined\n" "o The 'Depends on:' line tell what symbols needs to be defined for\n" "  this symbol to be visible in the menu (selectable)\n" "o The 'Location:' lines tell where in the menu structure this symbol\n" "  is located\n" "    A location followed by a [=y] indicate that this is a selectable\n" "    menu item - and current value is displayed inside brackets.\n" "o The 'Selects:' line tell what symbol will be automatically\n" "  selected if this symbol is selected (y or m)\n" "o The 'Selected by' line tell what symbol has selected this symbol\n" "\n" "Only relevant lines are shown.\n" "\n\n" "Search examples:\n" "Examples: USB	=> find all CONFIG_ symbols containing USB\n" "          ^USB => find all CONFIG_ symbols starting with USB\n" "          USB$ => find all CONFIG_ symbols ending with USB\n" "\n");
static char buf[4096*10], *bufptr = buf;
static char input_buf[4096];
static const char filename[] = ".config";
static char *args[1024], **argptr = args;
static int indent;
static struct termios ios_org;
static int rows = 0, cols = 0;
static struct menu *current_menu;
static int child_count;
static int do_resize;
static int single_menu_mode;
static void conf(struct menu *menu);
static void conf_choice(struct menu *menu);
static void conf_string(struct menu *menu);
static void conf_load(void);
static void conf_save(void);
static void show_textbox(const char *title, const char *text, int r, int c);
static void show_helptext(const char *title, const char *text);
static void show_help(struct menu *menu);
static void show_file(const char *filename, const char *title, int r, int c);
static void cprint_init(void);
static int cprint1(const char *fmt, ...);
static void cprint_done(void);
static int cprint(const char *fmt, ...);
static void init_wsize(void)
{
 struct winsize ws;
 char *env;
 if (!ioctl(0, 0x5413, &ws)) {
  rows = ws.ws_row;
  cols = ws.ws_col;
 }
 if (!rows) {
  env = getenv("LINES");
  if (env)
   rows = atoi(env);
  if (!rows)
   rows = 24;
 }
 if (!cols) {
  env = getenv("COLUMNS");
  if (env)
   cols = atoi(env);
  if (!cols)
   cols = 80;
 }
 if (rows < 19 || cols < 80) {
  fprintf(stderr, ("Your display is too small to run Menuconfig!\n"));
  fprintf(stderr, ("It must be at least 19 lines by 80 columns.\n"));
  exit(1);
 }
 rows -= 4;
 cols -= 5;
}
static void cprint_init(void)
{
 bufptr = buf;
 argptr = args;
 memset(args, 0, sizeof(args));
 indent = 0;
 child_count = 0;
 cprint("./scripts/kconfig/lxdialog/lxdialog");
 cprint("--backtitle");
 cprint(menu_backtitle);
}
static int cprint1(const char *fmt, ...)
{
 va_list ap;
 int res;
 if (!*argptr)
  *argptr = bufptr;
 __builtin_va_start(ap,fmt);
 res = vsprintf(bufptr, fmt, ap);
 __builtin_va_end(ap);
 bufptr += res;
 return res;
}
static void cprint_done(void)
{
 *bufptr++ = 0;
 argptr++;
}
static int cprint(const char *fmt, ...)
{
 va_list ap;
 int res;
 *argptr++ = bufptr;
 __builtin_va_start(ap,fmt);
 res = vsprintf(bufptr, fmt, ap);
 __builtin_va_end(ap);
 bufptr += res;
 *bufptr++ = 0;
 return res;
}
static void get_prompt_str(struct gstr *r, struct property *prop)
{
 int i, j;
 struct menu *submenu[8], *menu;
 str_printf(r, "Prompt: %s\n", prop->text);
 str_printf(r, "  Defined at %s:%d\n", prop->menu->file->name,
  prop->menu->lineno);
 if (!expr_is_yes(prop->visible.expr)) {
  str_append(r, "  Depends on: ");
  expr_gstr_print(prop->visible.expr, r);
  str_append(r, "\n");
 }
 menu = prop->menu->parent;
 for (i = 0; menu != &rootmenu && i < 8; menu = menu->parent)
  submenu[i++] = menu;
 if (i > 0) {
  str_printf(r, "  Location:\n");
  for (j = 4; --i >= 0; j += 2) {
   menu = submenu[i];
   str_printf(r, "%*c-> %s", j, ' ', menu_get_prompt(menu));
   if (menu->sym) {
    str_printf(r, " (%s [=%s])", menu->sym->name ?
     menu->sym->name : "<choice>",
     sym_get_string_value(menu->sym));
   }
   str_append(r, "\n");
  }
 }
}
static void get_symbol_str(struct gstr *r, struct symbol *sym)
{
 _Bool hit;
 struct property *prop;
 str_printf(r, "Symbol: %s [=%s]\n", sym->name,
                                sym_get_string_value(sym));
 for (prop = sym->prop; prop; prop = prop->next) if (prop->text)
  get_prompt_str(r, prop);
 hit = 0;
 for (prop = sym->prop; prop; prop = prop->next) if (prop->type == (P_SELECT)) {
  if (!hit) {
   str_append(r, "  Selects: ");
   hit = 1;
  } else
   str_printf(r, " && ");
  expr_gstr_print(prop->expr, r);
 }
 if (hit)
  str_append(r, "\n");
 if (sym->rev_dep.expr) {
  str_append(r, "  Selected by: ");
  expr_gstr_print(sym->rev_dep.expr, r);
  str_append(r, "\n");
 }
 str_append(r, "\n\n");
}
static struct gstr get_relations_str(struct symbol **sym_arr)
{
 struct symbol *sym;
 struct gstr res = str_new();
 int i;
 for (i = 0; sym_arr && (sym = sym_arr[i]); i++)
  get_symbol_str(&res, sym);
 if (!i)
  str_append(&res, "No matches found.\n");
 return res;
}
pid_t pid;
static void winch_handler(int sig)
{
 if (!do_resize) {
  kill(pid, 2);
  do_resize = 1;
 }
}
static int exec_conf(void)
{
 int pipefd[2], stat, size;
 struct sigaction sa;
 sigset_t sset, osset;
 sigemptyset(&sset);
 sigaddset(&sset, 2);
 sigprocmask(0, &sset, &osset);
 signal(2, ((__sighandler_t) 0));
 sa.__sigaction_handler.sa_handler = winch_handler;
 sigemptyset(&sa.sa_mask);
 sa.sa_flags = 0x10000000;
 sigaction(28, &sa, ((void *)0));
 *argptr++ = ((void *)0);
 pipe(pipefd);
 pid = fork();
 if (pid == 0) {
  sigprocmask(2, &osset, ((void *)0));
  dup2(pipefd[1], 2);
  close(pipefd[0]);
  close(pipefd[1]);
  execv(args[0], args);
  _exit(1);
 }
 close(pipefd[1]);
 bufptr = input_buf;
 while (1) {
  size = input_buf + sizeof(input_buf) - bufptr;
  size = read(pipefd[0], bufptr, size);
  if (size <= 0) {
   if (size < 0) {
    if ((*__errno_location ()) == 4 || (*__errno_location ()) == 11)
     continue;
    perror("read");
   }
   break;
  }
  bufptr += size;
 }
 *bufptr++ = 0;
 close(pipefd[0]);
 waitpid(pid, &stat, 0);
 if (do_resize) {
  init_wsize();
  do_resize = 0;
  sigprocmask(2, &osset, ((void *)0));
  return -1;
 }
 if ((((signed char) ((((__extension__ (((union { __typeof(stat) __in; int __i; }) { .__in = (stat) }).__i))) & 0x7f) + 1) >> 1) > 0)) {
  printf("\finterrupted(%d)\n", (((__extension__ (((union { __typeof(stat) __in; int __i; }) { .__in = (stat) }).__i))) & 0x7f));
  exit(1);
 }
 sigpending(&sset);
 if (sigismember(&sset, 2)) {
  printf("\finterrupted\n");
  exit(1);
 }
 sigprocmask(2, &osset, ((void *)0));
 return ((((__extension__ (((union { __typeof(stat) __in; int __i; }) { .__in = (stat) }).__i))) & 0xff00) >> 8);
}
static void search_conf(void)
{
 struct symbol **sym_arr;
 int stat;
 struct gstr res;
again:
 cprint_init();
 cprint("--title");
 cprint(gettext("Search Configuration Parameter"));
 cprint("--inputbox");
 cprint(gettext("Enter CONFIG_ (sub)string to search for (omit CONFIG_)"));
 cprint("10");
 cprint("75");
 cprint("");
 stat = exec_conf();
 if (stat < 0)
  goto again;
 switch (stat) {
 case 0:
  break;
 case 1:
  show_helptext(gettext("Search Configuration"), search_help);
  goto again;
 default:
  return;
 }
 sym_arr = sym_re_search(input_buf);
 res = get_relations_str(sym_arr);
 free(sym_arr);
 show_textbox(gettext("Search Results"), str_get(&res), 0, 0);
 str_free(&res);
}
static void build_conf(struct menu *menu)
{
 struct symbol *sym;
 struct property *prop;
 struct menu *child;
 int type, tmp, doint = 2;
 tristate val;
 char ch;
 if (!menu_is_visible(menu))
  return;
 sym = menu->sym;
 prop = menu->prompt;
 if (!sym) {
  if (prop && menu != current_menu) {
   const char *prompt = menu_get_prompt(menu);
   switch (prop->type) {
   case P_MENU:
    child_count++;
    cprint("m%p", menu);
    if (single_menu_mode) {
     cprint1("%s%*c%s",
      menu->data ? "-->" : "++>",
      indent + 1, ' ', prompt);
    } else
     cprint1("   %*c%s  --->", indent + 1, ' ', prompt);
    cprint_done();
    if (single_menu_mode && menu->data)
     goto conf_childs;
    return;
   default:
    if (prompt) {
     child_count++;
     cprint(":%p", menu);
     cprint("---%*c%s", indent + 1, ' ', prompt);
    }
   }
  } else
   doint = 0;
  goto conf_childs;
 }
 type = sym_get_type(sym);
 if (sym_is_choice(sym)) {
  struct symbol *def_sym = sym_get_choice_value(sym);
  struct menu *def_menu = ((void *)0);
  child_count++;
  for (child = menu->list; child; child = child->next) {
   if (menu_is_visible(child) && child->sym == def_sym)
    def_menu = child;
  }
  val = sym_get_tristate_value(sym);
  if (sym_is_changable(sym)) {
   cprint("t%p", menu);
   switch (type) {
   case S_BOOLEAN:
    cprint1("[%c]", val == no ? ' ' : '*');
    break;
   case S_TRISTATE:
    switch (val) {
    case yes: ch = '*'; break;
    case mod: ch = 'M'; break;
    default: ch = ' '; break;
    }
    cprint1("<%c>", ch);
    break;
   }
  } else {
   cprint("%c%p", def_menu ? 't' : ':', menu);
   cprint1("   ");
  }
  cprint1("%*c%s", indent + 1, ' ', menu_get_prompt(menu));
  if (val == yes) {
   if (def_menu) {
    cprint1(" (%s)", menu_get_prompt(def_menu));
    cprint1("  --->");
    cprint_done();
    if (def_menu->list) {
     indent += 2;
     build_conf(def_menu);
     indent -= 2;
    }
   } else
    cprint_done();
   return;
  }
  cprint_done();
 } else {
  if (menu == current_menu) {
   cprint(":%p", menu);
   cprint("---%*c%s", indent + 1, ' ', menu_get_prompt(menu));
   goto conf_childs;
  }
  child_count++;
  val = sym_get_tristate_value(sym);
  if (sym_is_choice_value(sym) && val == yes) {
   cprint(":%p", menu);
   cprint1("   ");
  } else {
   switch (type) {
   case S_BOOLEAN:
    cprint("t%p", menu);
    if (sym_is_changable(sym))
     cprint1("[%c]", val == no ? ' ' : '*');
    else
     cprint1("---");
    break;
   case S_TRISTATE:
    cprint("t%p", menu);
    switch (val) {
    case yes: ch = '*'; break;
    case mod: ch = 'M'; break;
    default: ch = ' '; break;
    }
    if (sym_is_changable(sym))
     cprint1("<%c>", ch);
    else
     cprint1("---");
    break;
   default:
    cprint("s%p", menu);
    tmp = cprint1("(%s)", sym_get_string_value(sym));
    tmp = indent - tmp + 4;
    if (tmp < 0)
     tmp = 0;
    cprint1("%*c%s%s", tmp, ' ', menu_get_prompt(menu),
     (sym_has_value(sym) || !sym_is_changable(sym)) ?
     "" : " (NEW)");
    cprint_done();
    goto conf_childs;
   }
  }
  cprint1("%*c%s%s", indent + 1, ' ', menu_get_prompt(menu),
   (sym_has_value(sym) || !sym_is_changable(sym)) ?
   "" : " (NEW)");
  if (menu->prompt->type == P_MENU) {
   cprint1("  --->");
   cprint_done();
   return;
  }
  cprint_done();
 }
conf_childs:
 indent += doint;
 for (child = menu->list; child; child = child->next)
  build_conf(child);
 indent -= doint;
}
static void conf(struct menu *menu)
{
 struct menu *submenu;
 const char *prompt = menu_get_prompt(menu);
 struct symbol *sym;
 char active_entry[40];
 int stat, type, i;
 unlink("lxdialog.scrltmp");
 active_entry[0] = 0;
 while (1) {
  cprint_init();
  cprint("--title");
  cprint("%s", prompt ? prompt : gettext("Main Menu"));
  cprint("--menu");
  cprint(gettext(menu_instructions));
  cprint("%d", rows);
  cprint("%d", cols);
  cprint("%d", rows - 10);
  cprint("%s", active_entry);
  current_menu = menu;
  build_conf(menu);
  if (!child_count)
   break;
  if (menu == &rootmenu) {
   cprint(":");
   cprint("--- ");
   cprint("L");
   cprint(gettext("    Load an Alternate Configuration File"));
   cprint("S");
   cprint(gettext("    Save Configuration to an Alternate File"));
  }
  stat = exec_conf();
  if (stat < 0)
   continue;
  if (stat == 1 || stat == 255)
   break;
  type = input_buf[0];
  if (!type)
   continue;
  for (i = 0; input_buf[i] && !((*__ctype_b_loc ())[(int) ((input_buf[i]))] & (unsigned short int) _ISspace); i++)
   ;
  if (i >= sizeof(active_entry))
   i = sizeof(active_entry) - 1;
  input_buf[i] = 0;
  strcpy(active_entry, input_buf);
  sym = ((void *)0);
  submenu = ((void *)0);
  if (sscanf(input_buf + 1, "%p", &submenu) == 1)
   sym = submenu->sym;
  switch (stat) {
  case 0:
   switch (type) {
   case 'm':
    if (single_menu_mode)
     submenu->data = (void *) (long) !submenu->data;
    else
     conf(submenu);
    break;
   case 't':
    if (sym_is_choice(sym) && sym_get_tristate_value(sym) == yes)
     conf_choice(submenu);
    else if (submenu->prompt->type == P_MENU)
     conf(submenu);
    break;
   case 's':
    conf_string(submenu);
    break;
   case 'L':
    conf_load();
    break;
   case 'S':
    conf_save();
    break;
   }
   break;
  case 2:
   if (sym)
    show_help(submenu);
   else
    show_helptext("README", gettext(mconf_readme));
   break;
  case 3:
   if (type == 't') {
    if (sym_set_tristate_value(sym, yes))
     break;
    if (sym_set_tristate_value(sym, mod))
     show_textbox(((void *)0), setmod_text, 6, 74);
   }
   break;
  case 4:
   if (type == 't')
    sym_set_tristate_value(sym, no);
   break;
  case 5:
   if (type == 't')
    sym_set_tristate_value(sym, mod);
   break;
  case 6:
   if (type == 't')
    sym_toggle_tristate_value(sym);
   else if (type == 'm')
    conf(submenu);
   break;
  case 7:
   search_conf();
   break;
  }
 }
}
static void show_textbox(const char *title, const char *text, int r, int c)
{
 int fd;
 fd = creat(".help.tmp", 0777);
 write(fd, text, strlen(text));
 close(fd);
 show_file(".help.tmp", title, r, c);
 unlink(".help.tmp");
}
static void show_helptext(const char *title, const char *text)
{
 show_textbox(title, text, 0, 0);
}
static void show_help(struct menu *menu)
{
 struct gstr help = str_new();
 struct symbol *sym = menu->sym;
 if (sym->help)
 {
  if (sym->name) {
   str_printf(&help, "CONFIG_%s:\n\n", sym->name);
   str_append(&help, gettext(sym->help));
   str_append(&help, "\n");
  }
 } else {
  str_append(&help, nohelp_text);
 }
 get_symbol_str(&help, sym);
 show_helptext(menu_get_prompt(menu), str_get(&help));
 str_free(&help);
}
static void show_file(const char *filename, const char *title, int r, int c)
{
 do {
  cprint_init();
  if (title) {
   cprint("--title");
   cprint("%s", title);
  }
  cprint("--textbox");
  cprint("%s", filename);
  cprint("%d", r ? r : rows);
  cprint("%d", c ? c : cols);
 } while (exec_conf() < 0);
}
static void conf_choice(struct menu *menu)
{
 const char *prompt = menu_get_prompt(menu);
 struct menu *child;
 struct symbol *active;
 int stat;
 active = sym_get_choice_value(menu->sym);
 while (1) {
  cprint_init();
  cprint("--title");
  cprint("%s", prompt ? prompt : gettext("Main Menu"));
  cprint("--radiolist");
  cprint(gettext(radiolist_instructions));
  cprint("15");
  cprint("70");
  cprint("6");
  current_menu = menu;
  for (child = menu->list; child; child = child->next) {
   if (!menu_is_visible(child))
    continue;
   cprint("%p", child);
   cprint("%s", menu_get_prompt(child));
   if (child->sym == sym_get_choice_value(menu->sym))
    cprint("ON");
   else if (child->sym == active)
    cprint("SELECTED");
   else
    cprint("OFF");
  }
  stat = exec_conf();
  switch (stat) {
  case 0:
   if (sscanf(input_buf, "%p", &child) != 1)
    break;
   sym_set_tristate_value(child->sym, yes);
   return;
  case 1:
   if (sscanf(input_buf, "%p", &child) == 1) {
    show_help(child);
    active = child->sym;
   } else
    show_help(menu);
   break;
  case 255:
   return;
  }
 }
}
static void conf_string(struct menu *menu)
{
 const char *prompt = menu_get_prompt(menu);
 int stat;
 while (1) {
  cprint_init();
  cprint("--title");
  cprint("%s", prompt ? prompt : gettext("Main Menu"));
  cprint("--inputbox");
  switch (sym_get_type(menu->sym)) {
  case S_INT:
   cprint(gettext(inputbox_instructions_int));
   break;
  case S_HEX:
   cprint(gettext(inputbox_instructions_hex));
   break;
  case S_STRING:
   cprint(gettext(inputbox_instructions_string));
   break;
  default:
               ;
  }
  cprint("10");
  cprint("75");
  cprint("%s", sym_get_string_value(menu->sym));
  stat = exec_conf();
  switch (stat) {
  case 0:
   if (sym_set_string_value(menu->sym, input_buf))
    return;
   show_textbox(((void *)0), gettext("You have made an invalid entry."), 5, 43);
   break;
  case 1:
   show_help(menu);
   break;
  case 255:
   return;
  }
 }
}
static void conf_load(void)
{
 int stat;
 while (1) {
  cprint_init();
  cprint("--inputbox");
  cprint(load_config_text);
  cprint("11");
  cprint("55");
  cprint("%s", filename);
  stat = exec_conf();
  switch(stat) {
  case 0:
   if (!input_buf[0])
    return;
   if (!conf_read(input_buf))
    return;
   show_textbox(((void *)0), gettext("File does not exist!"), 5, 38);
   break;
  case 1:
   show_helptext(gettext("Load Alternate Configuration"), load_config_help);
   break;
  case 255:
   return;
  }
 }
}
static void conf_save(void)
{
 int stat;
 while (1) {
  cprint_init();
  cprint("--inputbox");
  cprint(save_config_text);
  cprint("11");
  cprint("55");
  cprint("%s", filename);
  stat = exec_conf();
  switch(stat) {
  case 0:
   if (!input_buf[0])
    return;
   if (!conf_write(input_buf))
    return;
   show_textbox(((void *)0), gettext("Can't create file!  Probably a nonexistent directory."), 5, 60);
   break;
  case 1:
   show_helptext(gettext("Save Alternate Configuration"), save_config_help);
   break;
  case 255:
   return;
  }
 }
}
static void conf_cleanup(void)
{
 tcsetattr(1, 2, &ios_org);
 unlink(".help.tmp");
 unlink("lxdialog.scrltmp");
}
int main(int ac, char **av)
{
 struct symbol *sym;
 char *mode;
 int stat;
 setlocale(__LC_ALL, "");
 bindtextdomain("linux", "/usr/share/locale");
 textdomain("linux");
 conf_parse(av[1]);
 conf_read(((void *)0));
 sym = sym_lookup("KERNELVERSION", 0);
 sym_calc_value(sym);
 sprintf(menu_backtitle, gettext("BusyBox %s Configuration"),
  sym_get_string_value(sym));
 mode = getenv("MENUCONFIG_MODE");
 if (mode) {
  if (!strcasecmp(mode, "single_menu"))
   single_menu_mode = 1;
 }
 tcgetattr(1, &ios_org);
 atexit(conf_cleanup);
 init_wsize();
 conf(&rootmenu);
 do {
  cprint_init();
  cprint("--yesno");
  cprint(gettext("Do you wish to save your new configuration?"));
  cprint("5");
  cprint("60");
  stat = exec_conf();
 } while (stat < 0);
 if (stat == 0) {
  if (conf_write(((void *)0))) {
   fprintf(stderr, gettext("\n\n" "Error during writing of the configuration.\n" "Your configuration changes were NOT saved." "\n\n"));
   return 1;
  }
  printf(gettext("\n\n" "*** End of configuration.\n" "*** Execute 'make' to build the project or try 'make help'." "\n\n"));
 } else {
  fprintf(stderr, gettext("\n\n" "Your configuration changes were NOT saved." "\n\n"));
 }
 return 0;
}
