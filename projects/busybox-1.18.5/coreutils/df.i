struct _IO_FILE;

typedef struct _IO_FILE FILE;



struct mntent
  {
    char *mnt_fsname;
    char *mnt_dir;
    char *mnt_type;
    char *mnt_opts;
    int mnt_freq;
    int mnt_passno;
  };
extern FILE *setmntent (__const char *__file, __const char *__mode) __attribute__ ((__nothrow__));
extern struct mntent *getmntent (FILE *__stream) __attribute__ ((__nothrow__));
extern struct mntent *getmntent_r (FILE *__restrict __stream,
       struct mntent *__restrict __result,
       char *__restrict __buffer,
       int __bufsize) __attribute__ ((__nothrow__));
extern int addmntent (FILE *__restrict __stream,
        __const struct mntent *__restrict __mnt) __attribute__ ((__nothrow__));
extern int endmntent (FILE *__stream) __attribute__ ((__nothrow__));
extern char *hasmntopt (__const struct mntent *__mnt,
   __const char *__opt) __attribute__ ((__nothrow__));




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
struct statfs
  {
    long int f_type;
    long int f_bsize;
    __fsblkcnt_t f_blocks;
    __fsblkcnt_t f_bfree;
    __fsblkcnt_t f_bavail;
    __fsfilcnt_t f_files;
    __fsfilcnt_t f_ffree;
    __fsid_t f_fsid;
    long int f_namelen;
    long int f_frsize;
    long int f_flags;
    long int f_spare[4];
  };

extern int statfs (__const char *__file, struct statfs *__buf)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern int fstatfs (int __fildes, struct statfs *__buf)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2)));
