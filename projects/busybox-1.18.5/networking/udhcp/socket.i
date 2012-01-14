
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
typedef long unsigned int size_t;
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

typedef __socklen_t socklen_t;
enum __socket_type
{
  SOCK_STREAM = 1,
  SOCK_DGRAM = 2,
  SOCK_RAW = 3,
  SOCK_RDM = 4,
  SOCK_SEQPACKET = 5,
  SOCK_DCCP = 6,
  SOCK_PACKET = 10,
  SOCK_CLOEXEC = 02000000,
  SOCK_NONBLOCK = 04000
};
typedef unsigned short int sa_family_t;
struct sockaddr
  {
    sa_family_t sa_family;
    char sa_data[14];
  };
struct sockaddr_storage
  {
    sa_family_t ss_family;
    unsigned long int __ss_align;
    char __ss_padding[(128 - (2 * sizeof (unsigned long int)))];
  };
enum
  {
    MSG_OOB = 0x01,
    MSG_PEEK = 0x02,
    MSG_DONTROUTE = 0x04,
    MSG_CTRUNC = 0x08,
    MSG_PROXY = 0x10,
    MSG_TRUNC = 0x20,
    MSG_DONTWAIT = 0x40,
    MSG_EOR = 0x80,
    MSG_WAITALL = 0x100,
    MSG_FIN = 0x200,
    MSG_SYN = 0x400,
    MSG_CONFIRM = 0x800,
    MSG_RST = 0x1000,
    MSG_ERRQUEUE = 0x2000,
    MSG_NOSIGNAL = 0x4000,
    MSG_MORE = 0x8000,
    MSG_WAITFORONE = 0x10000,
    MSG_CMSG_CLOEXEC = 0x40000000
  };
struct msghdr
  {
    void *msg_name;
    socklen_t msg_namelen;
    struct iovec *msg_iov;
    size_t msg_iovlen;
    void *msg_control;
    size_t msg_controllen;
    int msg_flags;
  };
struct cmsghdr
  {
    size_t cmsg_len;
    int cmsg_level;
    int cmsg_type;
    __extension__ unsigned char __cmsg_data [];
  };
extern struct cmsghdr *__cmsg_nxthdr (struct msghdr *__mhdr,
          struct cmsghdr *__cmsg) __attribute__ ((__nothrow__));
enum
  {
    SCM_RIGHTS = 0x01

  };
struct linger
  {
    int l_onoff;
    int l_linger;
  };

extern int recvmmsg (int __fd, struct mmsghdr *__vmessages,
       unsigned int __vlen, int __flags,
       __const struct timespec *__tmo);
extern int sendmmsg (int __fd, struct mmsghdr *__vmessages,
       unsigned int __vlen, int __flags);

struct osockaddr
  {
    unsigned short int sa_family;
    unsigned char sa_data[14];
  };
enum
{
  SHUT_RD = 0,
  SHUT_WR,
  SHUT_RDWR
};
extern int socket (int __domain, int __type, int __protocol) __attribute__ ((__nothrow__));
extern int socketpair (int __domain, int __type, int __protocol,
         int __fds[2]) __attribute__ ((__nothrow__));
extern int bind (int __fd, __const struct sockaddr * __addr, socklen_t __len)
     __attribute__ ((__nothrow__));
extern int getsockname (int __fd, struct sockaddr *__restrict __addr,
   socklen_t *__restrict __len) __attribute__ ((__nothrow__));
extern int connect (int __fd, __const struct sockaddr * __addr, socklen_t __len);
extern int getpeername (int __fd, struct sockaddr *__restrict __addr,
   socklen_t *__restrict __len) __attribute__ ((__nothrow__));
extern ssize_t send (int __fd, __const void *__buf, size_t __n, int __flags);
extern ssize_t recv (int __fd, void *__buf, size_t __n, int __flags);
extern ssize_t sendto (int __fd, __const void *__buf, size_t __n,
         int __flags, __const struct sockaddr * __addr,
         socklen_t __addr_len);
extern ssize_t recvfrom (int __fd, void *__restrict __buf, size_t __n,
    int __flags, struct sockaddr *__restrict __addr,
    socklen_t *__restrict __addr_len);
extern ssize_t sendmsg (int __fd, __const struct msghdr *__message,
   int __flags);
extern ssize_t recvmsg (int __fd, struct msghdr *__message, int __flags);
extern int getsockopt (int __fd, int __level, int __optname,
         void *__restrict __optval,
         socklen_t *__restrict __optlen) __attribute__ ((__nothrow__));
extern int setsockopt (int __fd, int __level, int __optname,
         __const void *__optval, socklen_t __optlen) __attribute__ ((__nothrow__));
extern int listen (int __fd, int __n) __attribute__ ((__nothrow__));
extern int accept (int __fd, struct sockaddr *__restrict __addr,
     socklen_t *__restrict __addr_len);
extern int shutdown (int __fd, int __how) __attribute__ ((__nothrow__));
extern int sockatmark (int __fd) __attribute__ ((__nothrow__));
extern int isfdtype (int __fd, int __fdtype) __attribute__ ((__nothrow__));

struct if_nameindex
  {
    unsigned int if_index;
    char *if_name;
  };
enum
  {
    IFF_UP = 0x1,
    IFF_BROADCAST = 0x2,
    IFF_DEBUG = 0x4,
    IFF_LOOPBACK = 0x8,
    IFF_POINTOPOINT = 0x10,
    IFF_NOTRAILERS = 0x20,
    IFF_RUNNING = 0x40,
    IFF_NOARP = 0x80,
    IFF_PROMISC = 0x100,
    IFF_ALLMULTI = 0x200,
    IFF_MASTER = 0x400,
    IFF_SLAVE = 0x800,
    IFF_MULTICAST = 0x1000,
    IFF_PORTSEL = 0x2000,
    IFF_AUTOMEDIA = 0x4000,
    IFF_DYNAMIC = 0x8000
  };
struct ifaddr
  {
    struct sockaddr ifa_addr;
    union
      {
 struct sockaddr ifu_broadaddr;
 struct sockaddr ifu_dstaddr;
      } ifa_ifu;
    struct iface *ifa_ifp;
    struct ifaddr *ifa_next;
  };
struct ifmap
  {
    unsigned long int mem_start;
    unsigned long int mem_end;
    unsigned short int base_addr;
    unsigned char irq;
    unsigned char dma;
    unsigned char port;
  };
struct ifreq
  {
    union
      {
 char ifrn_name[16];
      } ifr_ifrn;
    union
      {
 struct sockaddr ifru_addr;
 struct sockaddr ifru_dstaddr;
 struct sockaddr ifru_broadaddr;
 struct sockaddr ifru_netmask;
 struct sockaddr ifru_hwaddr;
 short int ifru_flags;
 int ifru_ivalue;
 int ifru_mtu;
 struct ifmap ifru_map;
 char ifru_slave[16];
 char ifru_newname[16];
 __caddr_t ifru_data;
      } ifr_ifru;
  };
struct ifconf
  {
    int ifc_len;
    union
      {
 __caddr_t ifcu_buf;
 struct ifreq *ifcu_req;
      } ifc_ifcu;
  };

extern unsigned int if_nametoindex (__const char *__ifname) __attribute__ ((__nothrow__));
extern char *if_indextoname (unsigned int __ifindex, char *__ifname) __attribute__ ((__nothrow__));
extern struct if_nameindex *if_nameindex (void) __attribute__ ((__nothrow__));
extern void if_freenameindex (struct if_nameindex *__ptr) __attribute__ ((__nothrow__));

struct sockaddr_ll
  {
    unsigned short int sll_family;
    unsigned short int sll_protocol;
    int sll_ifindex;
    unsigned short int sll_hatype;
    unsigned char sll_pkttype;
    unsigned char sll_halen;
    unsigned char sll_addr[8];
  };
struct packet_mreq
  {
    int mr_ifindex;
    unsigned short int mr_type;
    unsigned short int mr_alen;
    unsigned char mr_address[8];
  };
typedef __signed__ char __s8;
typedef unsigned char __u8;
typedef __signed__ short __s16;
typedef unsigned short __u16;
typedef __signed__ int __s32;
typedef unsigned int __u32;
__extension__ typedef __signed__ long long __s64;
__extension__ typedef unsigned long long __u64;
typedef unsigned short umode_t;
typedef struct {
 unsigned long fds_bits [(1024/(8 * sizeof(unsigned long)))];
} __kernel_fd_set;
typedef void (*__kernel_sighandler_t)(int);
typedef int __kernel_key_t;
typedef int __kernel_mqd_t;
typedef unsigned long __kernel_ino_t;
typedef unsigned int __kernel_mode_t;
typedef unsigned long __kernel_nlink_t;
typedef long __kernel_off_t;
typedef int __kernel_pid_t;
typedef int __kernel_ipc_pid_t;
typedef unsigned int __kernel_uid_t;
typedef unsigned int __kernel_gid_t;
typedef unsigned long __kernel_size_t;
typedef long __kernel_ssize_t;
typedef long __kernel_ptrdiff_t;
typedef long __kernel_time_t;
typedef long __kernel_suseconds_t;
typedef long __kernel_clock_t;
typedef int __kernel_timer_t;
typedef int __kernel_clockid_t;
typedef int __kernel_daddr_t;
typedef char * __kernel_caddr_t;
typedef unsigned short __kernel_uid16_t;
typedef unsigned short __kernel_gid16_t;
typedef long long __kernel_loff_t;
typedef struct {
 int val[2];
} __kernel_fsid_t;
typedef unsigned short __kernel_old_uid_t;
typedef unsigned short __kernel_old_gid_t;
typedef __kernel_uid_t __kernel_uid32_t;
typedef __kernel_gid_t __kernel_gid32_t;
typedef unsigned long __kernel_old_dev_t;
typedef __u16 __le16;
typedef __u16 __be16;
typedef __u32 __le32;
typedef __u32 __be32;
typedef __u64 __le64;
typedef __u64 __be64;
typedef __u16 __sum16;
typedef __u32 __wsum;
struct ethhdr {
 unsigned char h_dest[6];
 unsigned char h_source[6];
 __be16 h_proto;
} __attribute__((packed));

struct ether_addr
{
  u_int8_t ether_addr_octet[6];
} __attribute__ ((__packed__));
struct ether_header
{
  u_int8_t ether_dhost[6];
  u_int8_t ether_shost[6];
  u_int16_t ether_type;
} __attribute__ ((__packed__));
