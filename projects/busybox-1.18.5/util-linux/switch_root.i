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

enum
{
  MS_RDONLY = 1,
  MS_NOSUID = 2,
  MS_NODEV = 4,
  MS_NOEXEC = 8,
  MS_SYNCHRONOUS = 16,
  MS_REMOUNT = 32,
  MS_MANDLOCK = 64,
  MS_DIRSYNC = 128,
  MS_NOATIME = 1024,
  MS_NODIRATIME = 2048,
  MS_BIND = 4096,
  MS_MOVE = 8192,
  MS_REC = 16384,
  MS_SILENT = 32768,
  MS_POSIXACL = 1 << 16,
  MS_UNBINDABLE = 1 << 17,
  MS_PRIVATE = 1 << 18,
  MS_SLAVE = 1 << 19,
  MS_SHARED = 1 << 20,
  MS_RELATIME = 1 << 21,
  MS_KERNMOUNT = 1 << 22,
  MS_I_VERSION = 1 << 23,
  MS_STRICTATIME = 1 << 24,
  MS_ACTIVE = 1 << 30,
  MS_NOUSER = 1 << 31
};

enum
{
  MNT_FORCE = 1,

  MNT_DETACH = 2,

  MNT_EXPIRE = 4,

  UMOUNT_NOFOLLOW = 8

};





extern int mount (__const char *__special_file, __const char *__dir,
    __const char *__fstype, unsigned long int __rwflag,
    __const void *__data) __attribute__ ((__nothrow__));


extern int umount (__const char *__special_file) __attribute__ ((__nothrow__));


extern int umount2 (__const char *__special_file, int __flags) __attribute__ ((__nothrow__));

