enum {
 SLEAZE_PORT = 31337,
 BIGSIZ = 8192,
 netfd = 3,
 ofd = 4,
};
struct globals {
 unsigned o_verbose;
 unsigned o_wait;
 unsigned wrote_out;
 unsigned wrote_net;
 struct len_and_sockaddr *ouraddr;
 struct len_and_sockaddr *themaddr;
 struct len_and_sockaddr remend;
 jmp_buf jbuf;
 fd_set ding1;
 fd_set ding2;
 char bigbuf_in[BIGSIZ];
 char bigbuf_net[BIGSIZ];
};
enum {
 OPT_h = (1 << 0),
 OPT_n = (1 << 1),
 OPT_p = (1 << 2),
 OPT_s = (1 << 3),
 OPT_u = (1 << 4),
 OPT_v = (1 << 5),
 OPT_w = (1 << 6),
 OPT_l = (1 << 7) * ENABLE_NC_SERVER,
 OPT_i = (1 << (7+ENABLE_NC_SERVER)) * ENABLE_NC_EXTRA,
 OPT_o = (1 << (8+ENABLE_NC_SERVER)) * ENABLE_NC_EXTRA,
 OPT_z = (1 << (9+ENABLE_NC_SERVER)) * ENABLE_NC_EXTRA,
};
static void catch(int sig)
{
 if (((*ptr_to_globals).o_verbose ) > 1)
  fprintf(stderr, "sent %u, rcvd %u\n", ((*ptr_to_globals).wrote_net ), ((*ptr_to_globals).wrote_out ));
 fprintf(stderr, "punt!\n");
 kill_myself_with_sig(sig);
}
static void unarm(void)
{
 signal(SIGALRM, SIG_IGN);
 alarm(0);
}
static void tmtravel(int sig UNUSED_PARAM)
{
 unarm();
 longjmp(((*ptr_to_globals).jbuf ), 1);
}
static void arm(unsigned secs)
{
 signal(SIGALRM, tmtravel);
 alarm(secs);
}
static unsigned findline(char *buf, unsigned siz)
{
 char * p;
 int x;
 if (!buf)
  return 0;
 if (siz > BIGSIZ)
  return 0;
 x = siz;
 for (p = buf; x > 0; x--) {
  if (*p == '\n') {
   x = (int) (p - buf);
   x++;
do { } while (0);
   return x;
  }
  p++;
 }
do { } while (0);
 return siz;
}
static int doexec(char **proggie) NORETURN;
static int doexec(char **proggie)
{
 xmove_fd(netfd, 0);
 dup2(0, 1);
 execvp(proggie[0], proggie);
 bb_perror_msg_and_die("can't execute '%s'", proggie[0]);
}
static int connect_w_timeout(int fd)
{
 int rr;
 arm(((*ptr_to_globals).o_wait ));
 if (setjmp(((*ptr_to_globals).jbuf )) == 0) {
  rr = connect(fd, &((*ptr_to_globals).themaddr )->u.sa, ((*ptr_to_globals).themaddr )->len);
  unarm();
 } else {
  rr = -1;
  errno = ETIMEDOUT;
 }
 return rr;
}
static void dolisten(void)
{
 int rr;
 if (!(option_mask32 & OPT_u))
  xlisten(netfd, 1);
 if (((*ptr_to_globals).o_verbose )) {
  char *addr;
  getsockname(netfd, &((*ptr_to_globals).ouraddr )->u.sa, &((*ptr_to_globals).ouraddr )->len);
  addr = xmalloc_sockaddr2dotted(&((*ptr_to_globals).ouraddr )->u.sa);
  fprintf(stderr, "listening on %s ...\n", addr);
  free(addr);
 }
 if ((option_mask32 & OPT_u)) {
  ((*ptr_to_globals).remend ).len = LSA_SIZEOF_SA;
  if (((*ptr_to_globals).themaddr )) {
   ((*ptr_to_globals).remend ) = *((*ptr_to_globals).themaddr );
   xconnect(netfd, &((*ptr_to_globals).themaddr )->u.sa, ((*ptr_to_globals).themaddr )->len);
  }
  arm(((*ptr_to_globals).o_wait ));
  if (setjmp(((*ptr_to_globals).jbuf )) == 0) {
   rr = recv_from_to(netfd, NULL, 0, MSG_PEEK,
    &((*ptr_to_globals).remend ).u.sa, &((*ptr_to_globals).ouraddr )->u.sa, ((*ptr_to_globals).ouraddr )->len);
   if (rr < 0)
    bb_perror_msg_and_die("recvfrom");
   unarm();
  } else
   bb_error_msg_and_die("timeout");
  if (!((*ptr_to_globals).themaddr ))
   xconnect(netfd, &((*ptr_to_globals).remend ).u.sa, ((*ptr_to_globals).ouraddr )->len);
 } else {
  arm(((*ptr_to_globals).o_wait ));
  if (setjmp(((*ptr_to_globals).jbuf )) == 0) {
 again:
   ((*ptr_to_globals).remend ).len = LSA_SIZEOF_SA;
   rr = accept(netfd, &((*ptr_to_globals).remend ).u.sa, &((*ptr_to_globals).remend ).len);
   if (rr < 0)
    bb_perror_msg_and_die("accept");
   if (((*ptr_to_globals).themaddr )) {
    int sv_port, port, r;
    sv_port = get_nport(&((*ptr_to_globals).remend ).u.sa);
    port = get_nport(&((*ptr_to_globals).themaddr )->u.sa);
    if (port == 0) {
     set_nport(&((*ptr_to_globals).remend ), 0);
    }
    r = memcmp(&((*ptr_to_globals).remend ).u.sa, &((*ptr_to_globals).themaddr )->u.sa, ((*ptr_to_globals).remend ).len);
    set_nport(&((*ptr_to_globals).remend ), sv_port);
    if (r != 0) {
     if (((*ptr_to_globals).o_verbose )) {
      char *remaddr = xmalloc_sockaddr2dotted(&((*ptr_to_globals).remend ).u.sa);
      bb_error_msg("connect from wrong ip/port %s ignored", remaddr);
      free(remaddr);
     }
     close(rr);
     goto again;
    }
   }
   unarm();
  } else
   bb_error_msg_and_die("timeout");
  xmove_fd(rr, netfd);
  getsockname(netfd, &((*ptr_to_globals).ouraddr )->u.sa, &((*ptr_to_globals).ouraddr )->len);
 }
 if (((*ptr_to_globals).o_verbose )) {
  char *lcladdr, *remaddr, *remhostname;
  lcladdr = xmalloc_sockaddr2dotted(&((*ptr_to_globals).ouraddr )->u.sa);
  remaddr = xmalloc_sockaddr2dotted(&((*ptr_to_globals).remend ).u.sa);
  remhostname = (option_mask32 & OPT_n) ? remaddr : xmalloc_sockaddr2host(&((*ptr_to_globals).remend ).u.sa);
  fprintf(stderr, "connect to %s from %s (%s)\n",
    lcladdr, remhostname, remaddr);
  free(lcladdr);
  free(remaddr);
  if (!(option_mask32 & OPT_n))
   free(remhostname);
 }
}
int udptest(void);
void oprint(int direction, unsigned char *p, unsigned bc);
static int readwrite(void)
{
 int rr;
 char *zp = zp;
 char *np = np;
 unsigned rzleft;
 unsigned rnleft;
 unsigned netretry;
 unsigned wretry;
 unsigned wfirst;
 FD_SET(netfd, &((*ptr_to_globals).ding1 ));
 netretry = 2;
 wfirst = 0;
 rzleft = rnleft = 0;
 if (0)
  sleep(0);
 errno = 0;
 while (FD_ISSET(netfd, &((*ptr_to_globals).ding1 ))) {
  wretry = 8200;
  if (wfirst) {
   wfirst = 0;
   goto shovel;
  }
  ((*ptr_to_globals).ding2 ) = ((*ptr_to_globals).ding1 );
  if (((*ptr_to_globals).o_wait )) {
   struct timeval tmp_timer;
   tmp_timer.tv_sec = ((*ptr_to_globals).o_wait );
   tmp_timer.tv_usec = 0;
   rr = select(netfd+1, &((*ptr_to_globals).ding2 ), NULL, NULL, &tmp_timer);
  } else
   rr = select(netfd+1, &((*ptr_to_globals).ding2 ), NULL, NULL, NULL);
  if (rr < 0 && errno != EINTR) {
   do { if (((*ptr_to_globals).o_verbose )) bb_perror_msg("select"); } while (0);
   close(netfd);
   return 1;
  }
  if (rr == 0) {
   if (!FD_ISSET(STDIN_FILENO, &((*ptr_to_globals).ding1 )))
    netretry--;
   if (!netretry) {
    if (((*ptr_to_globals).o_verbose ) > 1)
     fprintf(stderr, "net timeout\n");
    close(netfd);
    return 0;
   }
  }
  if (FD_ISSET(netfd, &((*ptr_to_globals).ding2 ))) {
   rr = read(netfd, ((*ptr_to_globals).bigbuf_net), BIGSIZ);
   if (rr <= 0) {
    if (rr < 0 && ((*ptr_to_globals).o_verbose ) > 1) {
     bb_perror_msg("net read");
    }
    FD_CLR(netfd, &((*ptr_to_globals).ding1 ));
    rzleft = 0;
   } else {
    rnleft = rr;
    np = ((*ptr_to_globals).bigbuf_net);
   }
do { } while (0);
  }
  if (rzleft)
   goto shovel;
  if (FD_ISSET(STDIN_FILENO, &((*ptr_to_globals).ding2 ))) {
   rr = read(STDIN_FILENO, ((*ptr_to_globals).bigbuf_in ), BIGSIZ);
   if (rr <= 0) {
    FD_CLR(STDIN_FILENO, &((*ptr_to_globals).ding1 ));
    close(STDIN_FILENO);
   } else {
    rzleft = rr;
    zp = ((*ptr_to_globals).bigbuf_in );
   }
  }
 shovel:
  if ((rzleft > 8200) || (rnleft > 8200)) {
   do { if (((*ptr_to_globals).o_verbose )) bb_error_msg("bogus buffers: %u, %u", rzleft, rnleft); } while (0);
   rzleft = rnleft = 0;
  }
  if (!wretry) {
   do { if (((*ptr_to_globals).o_verbose )) bb_error_msg("too many output retries"); } while (0);
   return 1;
  }
  if (rnleft) {
   rr = write(STDOUT_FILENO, np, rnleft);
   if (rr > 0) {
    if (0)
     oprint('<', (unsigned char *)np, rr);
    np += rr;
    rnleft -= rr;
    ((*ptr_to_globals).wrote_out ) += rr;
   }
do { } while (0);
  }
  if (rzleft) {
   if (0)
    rr = findline(zp, rzleft);
   else
    rr = rzleft;
   rr = write(netfd, zp, rr);
   if (rr > 0) {
    if (0)
     oprint('>', (unsigned char *)zp, rr);
    zp += rr;
    rzleft -= rr;
    ((*ptr_to_globals).wrote_net ) += rr;
   }
do { } while (0);
  }
  if (0) {
   sleep(0);
   errno = 0;
   continue;
  }
  if ((rzleft) || (rnleft)) {
   wretry--;
   goto shovel;
  }
 }
 close(netfd);
 return 0;
}
int nc_main(int argc, char **argv) MAIN_EXTERNALLY_VISIBLE;
int nc_main(int argc UNUSED_PARAM, char **argv)
{
 char *str_p, *str_s;
 IF_NC_EXTRA(char *str_i, *str_o;)
 char *themdotted = themdotted;
 char **proggie;
 int x;
 unsigned o_lport = 0;
 do { SET_PTR_TO_GLOBALS(xzalloc(sizeof((*ptr_to_globals)))); } while (0);
 bb_signals(0
  + (1 << SIGINT)
  + (1 << SIGQUIT)
  + (1 << SIGTERM)
  , catch);
 bb_signals(0
  + (1 << SIGPIPE)
  , SIG_IGN);
 proggie = argv;
 while (*++proggie) {
  if (strcmp(*proggie, "-e") == 0) {
   *proggie = NULL;
   proggie++;
   goto e_found;
  }
 }
 proggie = NULL;
 e_found:
 opt_complementary = "?2:vv:w+";
 getopt32(argv, "hnp:s:uvw:" IF_NC_SERVER("l")
   IF_NC_EXTRA("i:o:z"),
   &str_p, &str_s, &((*ptr_to_globals).o_wait )
   IF_NC_EXTRA(, &str_i, &str_o), &((*ptr_to_globals).o_verbose ));
 argv += optind;
 if (option_mask32 & OPT_p) {
  o_lport = bb_lookup_port(str_p, (option_mask32 & OPT_u) ? "udp" : "tcp", 0);
  if (!o_lport)
   bb_error_msg_and_die("bad local port '%s'", str_p);
 }
 if (argv[0]) {
  ((*ptr_to_globals).themaddr ) = xhost2sockaddr(argv[0],
   argv[1]
   ? bb_lookup_port(argv[1], (option_mask32 & OPT_u) ? "udp" : "tcp", 0)
   : 0);
 }
 x = ((option_mask32 & OPT_u) ? SOCK_DGRAM : SOCK_STREAM);
 if (option_mask32 & OPT_s) {
  ((*ptr_to_globals).ouraddr ) = xhost2sockaddr(str_s, o_lport);
  x = xsocket(((*ptr_to_globals).ouraddr )->u.sa.sa_family, x, 0);
 } else {
  x = xsocket_type(&((*ptr_to_globals).ouraddr ),
    (((*ptr_to_globals).themaddr ) ? ((*ptr_to_globals).themaddr )->u.sa.sa_family : AF_UNSPEC),
    x);
  if (o_lport)
   set_nport(((*ptr_to_globals).ouraddr ), htons(o_lport));
 }
 xmove_fd(x, netfd);
 setsockopt_reuseaddr(netfd);
 if ((option_mask32 & OPT_u))
  socket_want_pktinfo(netfd);
 if (!ENABLE_FEATURE_UNIX_LOCAL
  || 0
  || ((*ptr_to_globals).ouraddr )->u.sa.sa_family != AF_UNIX
 ) {
  xbind(netfd, &((*ptr_to_globals).ouraddr )->u.sa, ((*ptr_to_globals).ouraddr )->len);
 }
 FD_SET(STDIN_FILENO, &((*ptr_to_globals).ding1 ));
 if (proggie) {
  close(0);
  option_mask32 &= ~OPT_o;
 }
 if (0) {
  dolisten();
  if (proggie)
   doexec(proggie);
  x = readwrite();
 } else {
  if (!((*ptr_to_globals).themaddr ))
   bb_show_usage();
  ((*ptr_to_globals).remend ) = *((*ptr_to_globals).themaddr );
  if (((*ptr_to_globals).o_verbose ))
   themdotted = xmalloc_sockaddr2dotted(&((*ptr_to_globals).themaddr )->u.sa);
  x = connect_w_timeout(netfd);
  if (0 && x == 0 && (option_mask32 & OPT_u))
   x = udptest();
  if (x == 0) {
   if (((*ptr_to_globals).o_verbose ))
    fprintf(stderr, "%s (%s) open\n", argv[0], themdotted);
   if (proggie)
    doexec(proggie);
   if (!0)
    x = readwrite();
  } else {
   x = 1;
   if (((*ptr_to_globals).o_verbose ) > 1 || (((*ptr_to_globals).o_verbose ) && errno != ECONNREFUSED))
    bb_perror_msg("%s (%s)", argv[0], themdotted);
  }
 }
 if (((*ptr_to_globals).o_verbose ) > 1)
  fprintf(stderr, "sent %u, rcvd %u\n", ((*ptr_to_globals).wrote_net ), ((*ptr_to_globals).wrote_out ));
 return x;
}
