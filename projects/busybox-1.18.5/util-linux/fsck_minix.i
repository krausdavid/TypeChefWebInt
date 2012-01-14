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
