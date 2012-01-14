struct vt_mode {
 char mode;
 char waitv;
 short relsig;
 short acqsig;
 short frsig;
};
struct vt_stat {
 unsigned short v_active;
 unsigned short v_signal;
 unsigned short v_state;
};
struct vt_sizes {
 unsigned short v_rows;
 unsigned short v_cols;
 unsigned short v_scrollsize;
};
struct vt_consize {
 unsigned short v_rows;
 unsigned short v_cols;
 unsigned short v_vlin;
 unsigned short v_clin;
 unsigned short v_vcol;
 unsigned short v_ccol;
};
struct vt_event {
 unsigned int event;
 unsigned int oldev;
 unsigned int newev;
 unsigned int pad[4];
};
struct vt_setactivate {
 unsigned int console;
 struct vt_mode mode;
};