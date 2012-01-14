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
typedef long unsigned int size_t;

typedef __time_t time_t;


struct timespec
  {
    __time_t tv_sec;
    long int tv_nsec;
  };
typedef __pid_t pid_t;
struct sched_param
  {
    int __sched_priority;
  };


struct __sched_param
  {
    int __sched_priority;
  };
typedef unsigned long int __cpu_mask;
typedef struct
{
  __cpu_mask __bits[1024 / (8 * sizeof (__cpu_mask))];
} cpu_set_t;

extern int __sched_cpucount (size_t __setsize, const cpu_set_t *__setp)
  __attribute__ ((__nothrow__));
extern cpu_set_t *__sched_cpualloc (size_t __count) __attribute__ ((__nothrow__)) ;
extern void __sched_cpufree (cpu_set_t *__set) __attribute__ ((__nothrow__));


extern int sched_setparam (__pid_t __pid, __const struct sched_param *__param)
     __attribute__ ((__nothrow__));
extern int sched_getparam (__pid_t __pid, struct sched_param *__param) __attribute__ ((__nothrow__));
extern int sched_setscheduler (__pid_t __pid, int __policy,
          __const struct sched_param *__param) __attribute__ ((__nothrow__));
extern int sched_getscheduler (__pid_t __pid) __attribute__ ((__nothrow__));
extern int sched_yield (void) __attribute__ ((__nothrow__));
extern int sched_get_priority_max (int __algorithm) __attribute__ ((__nothrow__));
extern int sched_get_priority_min (int __algorithm) __attribute__ ((__nothrow__));
extern int sched_rr_get_interval (__pid_t __pid, struct timespec *__t) __attribute__ ((__nothrow__));
