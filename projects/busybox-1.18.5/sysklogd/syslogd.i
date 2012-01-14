typedef unsigned short int sa_family_t;

struct sockaddr_un
  {
    sa_family_t sun_family;
    char sun_path[108];
  };

typedef long unsigned int size_t;

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


struct iovec
  {
    void *iov_base;
    size_t iov_len;
  };
extern ssize_t readv (int __fd, __const struct iovec *__iovec, int __count)
  ;
extern ssize_t writev (int __fd, __const struct iovec *__iovec, int __count)
  ;
extern ssize_t preadv (int __fd, __const struct iovec *__iovec, int __count,
         __off_t __offset) ;
extern ssize_t pwritev (int __fd, __const struct iovec *__iovec, int __count,
   __off_t __offset) ;

enum {
 MAX_READ = CONFIG_FEATURE_SYSLOGD_READ_BUFFER_SIZE,
 DNS_WAIT_SEC = 2 * 60,
};
struct shbuf_ds {
 int32_t size;
 int32_t tail;
 char data[1];
};
struct init_globals {
 const char *logFilePath; int logFD; int logLevel; IF_FEATURE_ROTATE_LOGFILE( unsigned logFileSize; unsigned logFileRotate; unsigned curFileSize; smallint isRegular; ) IF_FEATURE_IPC_SYSLOG( int shmid; int s_semid; int shm_size; struct sembuf SMwup[1]; struct sembuf SMwdn[3]; )
};
struct globals {
 const char *logFilePath; int logFD; int logLevel; IF_FEATURE_ROTATE_LOGFILE( unsigned logFileSize; unsigned logFileRotate; unsigned curFileSize; smallint isRegular; ) IF_FEATURE_IPC_SYSLOG( int shmid; int s_semid; int shm_size; struct sembuf SMwup[1]; struct sembuf SMwdn[3]; )
 time_t last_log_time;
 char *hostname;
 char recvbuf[MAX_READ * (1 + ENABLE_FEATURE_SYSLOGD_DUP)];
 char parsebuf[MAX_READ*2];
 char printbuf[MAX_READ*2 + 128];
};
static const struct init_globals init_data = {
 .logFilePath = "/var/log/messages",
 .logFD = -1,
 .logLevel = 8,
};
enum {
 OPTBIT_mark = 0,
 OPTBIT_nofork,
 OPTBIT_outfile,
 OPTBIT_loglevel,
 OPTBIT_small,
 IF_FEATURE_ROTATE_LOGFILE(OPTBIT_filesize ,)
 IF_FEATURE_ROTATE_LOGFILE(OPTBIT_rotatecnt ,)
 IF_FEATURE_REMOTE_LOG( OPTBIT_remotelog ,)
 IF_FEATURE_REMOTE_LOG( OPTBIT_locallog ,)
 IF_FEATURE_IPC_SYSLOG( OPTBIT_circularlog,)
 IF_FEATURE_SYSLOGD_DUP( OPTBIT_dup ,)
 OPT_mark = 1 << OPTBIT_mark ,
 OPT_nofork = 1 << OPTBIT_nofork ,
 OPT_outfile = 1 << OPTBIT_outfile ,
 OPT_loglevel = 1 << OPTBIT_loglevel,
 OPT_small = 1 << OPTBIT_small ,
 OPT_filesize = IF_FEATURE_ROTATE_LOGFILE((1 << OPTBIT_filesize )) + 0,
 OPT_rotatecnt = IF_FEATURE_ROTATE_LOGFILE((1 << OPTBIT_rotatecnt )) + 0,
 OPT_remotelog = IF_FEATURE_REMOTE_LOG( (1 << OPTBIT_remotelog )) + 0,
 OPT_locallog = IF_FEATURE_REMOTE_LOG( (1 << OPTBIT_locallog )) + 0,
 OPT_circularlog = IF_FEATURE_IPC_SYSLOG( (1 << OPTBIT_circularlog)) + 0,
 OPT_dup = IF_FEATURE_SYSLOGD_DUP( (1 << OPTBIT_dup )) + 0,
};
void ipcsyslog_cleanup(void);
void ipcsyslog_init(void);
void log_to_shmem(const char *msg);
static void log_locally(time_t now, char *msg)
{
 int len = strlen(msg);
 if ((*ptr_to_globals).logFD >= 0) {
  if (!now)
   now = time(((void *)0));
  if ((*ptr_to_globals).last_log_time != now) {
   (*ptr_to_globals).last_log_time = now;
   close((*ptr_to_globals).logFD);
   goto reopen;
  }
 } else {
 reopen:
  (*ptr_to_globals).logFD = open((*ptr_to_globals).logFilePath, O_WRONLY | O_CREAT
     | O_NOCTTY | O_APPEND | O_NONBLOCK,
     0666);
  if ((*ptr_to_globals).logFD < 0) {
   int fd = device_open(DEV_CONSOLE, O_WRONLY | O_NOCTTY | O_NONBLOCK);
   if (fd < 0)
    fd = 2;
   full_write(fd, msg, len);
   if (fd != 2)
    close(fd);
   return;
  }
 }
   full_write((*ptr_to_globals).logFD, msg, len);
}
static void parse_fac_prio_20(int pri, char *res20)
{
 const CODE *c_pri, *c_fac;
 if (pri != 0) {
  c_fac = facilitynames;
  while (c_fac->c_name) {
   if (c_fac->c_val != (LOG_FAC(pri) << 3)) {
    c_fac++;
    continue;
   }
   c_pri = prioritynames;
   while (c_pri->c_name) {
    if (c_pri->c_val != LOG_PRI(pri)) {
     c_pri++;
     continue;
    }
    snprintf(res20, 20, "%s.%s",
      c_fac->c_name, c_pri->c_name);
    return;
   }
   break;
  }
  snprintf(res20, 20, "<%d>", pri);
 }
}
static void timestamp_and_log(int pri, char *msg, int len)
{
 char *timestamp;
 time_t now;
 if (len < 16 || msg[3] != ' ' || msg[6] != ' '
  || msg[9] != ':' || msg[12] != ':' || msg[15] != ' '
 ) {
  time(&now);
  timestamp = ctime(&now) + 4;
 } else {
  now = 0;
  timestamp = msg;
  msg += 16;
 }
 timestamp[15] = '\0';
 if (option_mask32 & OPT_small)
  sprintf((*ptr_to_globals).printbuf, "%s %s\n", timestamp, msg);
 else {
  char res[20];
  parse_fac_prio_20(pri, res);
  sprintf((*ptr_to_globals).printbuf, "%s %.64s %s %s\n", timestamp, (*ptr_to_globals).hostname, res, msg);
 }
 log_locally(now, (*ptr_to_globals).printbuf);
}
static void timestamp_and_log_internal(const char *msg)
{
 if (ENABLE_FEATURE_REMOTE_LOG && !(option_mask32 & OPT_locallog))
  return;
 timestamp_and_log(LOG_SYSLOG | LOG_INFO, (char*)msg, 0);
}
static void split_escape_and_log(char *tmpbuf, int len)
{
 char *p = tmpbuf;
 tmpbuf += len;
 while (p < tmpbuf) {
  char c;
  char *q = (*ptr_to_globals).parsebuf;
  int pri = (LOG_USER | LOG_NOTICE);
  if (*p == '<') {
   pri = bb_strtou(p + 1, &p, 10);
   if (*p == '>')
    p++;
   if (pri & ~(LOG_FACMASK | LOG_PRIMASK))
    pri = (LOG_USER | LOG_NOTICE);
  }
  while ((c = *p++)) {
   if (c == '\n')
    c = ' ';
   if (!(c & ~0x1f) && c != '\t') {
    *q++ = '^';
    c += '@';
   }
   *q++ = c;
  }
  *q = '\0';
  if (LOG_PRI(pri) < (*ptr_to_globals).logLevel)
   timestamp_and_log(pri, (*ptr_to_globals).parsebuf, q - (*ptr_to_globals).parsebuf);
 }
}
static NOINLINE int create_socket(void)
{
 struct sockaddr_un sunx;
 int sock_fd;
 char *dev_log_name;
 memset(&sunx, 0, sizeof(sunx));
 sunx.sun_family = AF_UNIX;
 strcpy(sunx.sun_path, "/dev/log");
 dev_log_name = xmalloc_follow_symlinks("/dev/log");
 if (dev_log_name) {
  safe_strncpy(sunx.sun_path, dev_log_name, sizeof(sunx.sun_path));
  free(dev_log_name);
 }
 unlink(sunx.sun_path);
 sock_fd = xsocket(AF_UNIX, SOCK_DGRAM, 0);
 xbind(sock_fd, (struct sockaddr *) &sunx, sizeof(sunx));
 chmod("/dev/log", 0666);
 return sock_fd;
}
static void do_syslogd(void) NORETURN;
static void do_syslogd(void)
{
 int sock_fd;
 signal_no_SA_RESTART_empty_mask(SIGTERM, record_signo);
 signal_no_SA_RESTART_empty_mask(SIGINT, record_signo);
 signal(SIGHUP, SIG_IGN);
 sock_fd = create_socket();
 if (ENABLE_FEATURE_IPC_SYSLOG && (option_mask32 & OPT_circularlog)) {
  ipcsyslog_init();
 }
 timestamp_and_log_internal("syslogd started: BusyBox v" BB_VER);
 while (!bb_got_signal) {
  ssize_t sz;







 read_again:
  sz = read(sock_fd, ((*ptr_to_globals).recvbuf), MAX_READ - 1);
  if (sz < 0) {
   if (!bb_got_signal)
    bb_perror_msg("read from /dev/log");
   break;
  }


  while (1) {
   if (sz == 0)
    goto read_again;







   if (((*ptr_to_globals).recvbuf)[sz-1] != '\0' && ((*ptr_to_globals).recvbuf)[sz-1] != '\n')
    break;
   sz--;
  }
  if (!ENABLE_FEATURE_REMOTE_LOG || (option_mask32 & OPT_locallog)) {
   ((*ptr_to_globals).recvbuf)[sz] = '\0';
   split_escape_and_log(((*ptr_to_globals).recvbuf), sz);
  }
 }
 timestamp_and_log_internal("syslogd exiting");
 puts("syslogd exiting");
 if (ENABLE_FEATURE_IPC_SYSLOG)
  ipcsyslog_cleanup();
 kill_myself_with_sig(bb_got_signal);
}
int syslogd_main(int argc, char **argv) MAIN_EXTERNALLY_VISIBLE;
int syslogd_main(int argc UNUSED_PARAM, char **argv)
{
 int opts;
 char *opt_m, *opt_l IF_FEATURE_ROTATE_LOGFILE(,*opt_s) IF_FEATURE_ROTATE_LOGFILE(,*opt_b) IF_FEATURE_IPC_SYSLOG( ,*opt_C = ((void *)0));
 do { SET_PTR_TO_GLOBALS(memcpy(xzalloc(sizeof((*ptr_to_globals))), &init_data, sizeof(init_data))); } while (0);
 opt_complementary = "=0" IF_FEATURE_REMOTE_LOG(":R::");
 opts = getopt32(argv, "m:nO:l:S" IF_FEATURE_ROTATE_LOGFILE("s:" ) IF_FEATURE_ROTATE_LOGFILE("b:" ) IF_FEATURE_REMOTE_LOG( "R:" ) IF_FEATURE_REMOTE_LOG( "L" ) IF_FEATURE_IPC_SYSLOG( "C::") IF_FEATURE_SYSLOGD_DUP( "D" ), &opt_m, &(*ptr_to_globals).logFilePath, &opt_l IF_FEATURE_ROTATE_LOGFILE(,&opt_s) IF_FEATURE_ROTATE_LOGFILE(,&opt_b) IF_FEATURE_REMOTE_LOG( ,&remoteAddrList) IF_FEATURE_IPC_SYSLOG( ,&opt_C));
 if (opts & OPT_loglevel)
  (*ptr_to_globals).logLevel = xatou_range(opt_l, 1, 8);
 if (ENABLE_FEATURE_REMOTE_LOG && !(opts & OPT_remotelog))
  option_mask32 |= OPT_locallog;
 (*ptr_to_globals).hostname = safe_gethostname();
 *strchrnul((*ptr_to_globals).hostname, '.') = '\0';
 if (!(opts & OPT_nofork)) {
  bb_daemonize_or_rexec(DAEMON_CHDIR_ROOT, argv);
 }
 write_pidfile("/var/run/syslogd.pid");
 do_syslogd();
}
