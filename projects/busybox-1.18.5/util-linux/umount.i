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
