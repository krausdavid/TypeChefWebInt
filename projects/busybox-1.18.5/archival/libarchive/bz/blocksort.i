static
void mvswap(uint32_t* ptr, int32_t zzp1, int32_t zzp2, int32_t zzn)
{
 while (zzn > 0) {
  { int32_t zztmp = ptr[zzp1]; ptr[zzp1] = ptr[zzp2]; ptr[zzp2] = zztmp; };
  zzp1++;
  zzp2++;
  zzn--;
 }
}
static
ALWAYS_INLINE
int32_t mmin(int32_t a, int32_t b)
{
 return (a < b) ? a : b;
}
static
inline
void fallbackSimpleSort(uint32_t* fmap,
  uint32_t* eclass,
  int32_t lo,
  int32_t hi)
{
 int32_t i, j, tmp;
 uint32_t ec_tmp;
 if (lo == hi) return;
 if (hi - lo > 3) {
  for (i = hi-4; i >= lo; i--) {
   tmp = fmap[i];
   ec_tmp = eclass[tmp];
   for (j = i+4; j <= hi && ec_tmp > eclass[fmap[j]]; j += 4)
    fmap[j-4] = fmap[j];
   fmap[j-4] = tmp;
  }
 }
 for (i = hi-1; i >= lo; i--) {
  tmp = fmap[i];
  ec_tmp = eclass[tmp];
  for (j = i+1; j <= hi && ec_tmp > eclass[fmap[j]]; j++)
   fmap[j-1] = fmap[j];
  fmap[j-1] = tmp;
 }
}
static
void fallbackQSort3(uint32_t* fmap,
  uint32_t* eclass,
  int32_t loSt,
  int32_t hiSt)
{
 int32_t unLo, unHi, ltLo, gtHi, n, m;
 int32_t sp, lo, hi;
 uint32_t med, r, r3;
 int32_t stackLo[100];
 int32_t stackHi[100];
 r = 0;
 sp = 0;
 { stackLo[sp] = loSt; stackHi[sp] = hiSt; sp++; };
 while (sp > 0) {
  AssertH(sp < 100 - 1, 1004);
  { sp--; lo = stackLo[sp]; hi = stackHi[sp]; };
  if (hi - lo < 10) {
   fallbackSimpleSort(fmap, eclass, lo, hi);
   continue;
  }
  r = ((r * 7621) + 1) % 32768;
  r3 = r % 3;
  if (r3 == 0)
   med = eclass[fmap[lo]];
  else if (r3 == 1)
   med = eclass[fmap[(lo+hi)>>1]];
  else
   med = eclass[fmap[hi]];
  unLo = ltLo = lo;
  unHi = gtHi = hi;
  while (1) {
   while (1) {
    if (unLo > unHi) break;
    n = (int32_t)eclass[fmap[unLo]] - (int32_t)med;
    if (n == 0) {
     { int32_t zztmp = fmap[unLo]; fmap[unLo] = fmap[ltLo]; fmap[ltLo] = zztmp; };
     ltLo++;
     unLo++;
     continue;
    };
    if (n > 0) break;
    unLo++;
   }
   while (1) {
    if (unLo > unHi) break;
    n = (int32_t)eclass[fmap[unHi]] - (int32_t)med;
    if (n == 0) {
     { int32_t zztmp = fmap[unHi]; fmap[unHi] = fmap[gtHi]; fmap[gtHi] = zztmp; };
     gtHi--; unHi--;
     continue;
    };
    if (n < 0) break;
    unHi--;
   }
   if (unLo > unHi) break;
   { int32_t zztmp = fmap[unLo]; fmap[unLo] = fmap[unHi]; fmap[unHi] = zztmp; }; unLo++; unHi--;
  }
  AssertD(unHi == unLo-1, "fallbackQSort3(2)");
  if (gtHi < ltLo) continue;
  n = mmin(ltLo-lo, unLo-ltLo); mvswap(fmap, lo, unLo-n, n);
  m = mmin(hi-gtHi, gtHi-unHi); mvswap(fmap, unLo, hi-m+1, m);
  n = lo + unLo - ltLo - 1;
  m = hi - (gtHi - unHi) + 1;
  if (n - lo > hi - m) {
   { stackLo[sp] = lo; stackHi[sp] = n; sp++; };
   { stackLo[sp] = m; stackHi[sp] = hi; sp++; };
  } else {
   { stackLo[sp] = m; stackHi[sp] = hi; sp++; };
   { stackLo[sp] = lo; stackHi[sp] = n; sp++; };
  }
 }
}
static
void fallbackSort(uint32_t* fmap,
  uint32_t* eclass,
  uint32_t* bhtab,
  int32_t nblock)
{
 int32_t ftab[257];
 int32_t ftabCopy[256];
 int32_t H, i, j, k, l, r, cc, cc1;
 int32_t nNotDone;
 int32_t nBhtab;
 uint8_t* eclass8 = (uint8_t*)eclass;
 for (i = 0; i < 257; i++) ftab[i] = 0;
 for (i = 0; i < nblock; i++) ftab[eclass8[i]]++;
 for (i = 0; i < 256; i++) ftabCopy[i] = ftab[i];
 j = ftab[0];
 for (i = 1; i < 257; i++) {
  j += ftab[i];
  ftab[i] = j;
 }
 for (i = 0; i < nblock; i++) {
  j = eclass8[i];
  k = ftab[j] - 1;
  ftab[j] = k;
  fmap[k] = i;
 }
 nBhtab = 2 + ((uint32_t)nblock / 32);
 for (i = 0; i < nBhtab; i++) bhtab[i] = 0;
 for (i = 0; i < 256; i++) bhtab[(ftab[i]) >> 5] |= (1 << ((ftab[i]) & 31));
 for (i = 0; i < 32; i++) {
  bhtab[(nblock + 2*i) >> 5] |= (1 << ((nblock + 2*i) & 31));
  bhtab[(nblock + 2*i + 1) >> 5] &= ~(1 << ((nblock + 2*i + 1) & 31));
 }
 H = 1;
 while (1) {
  j = 0;
  for (i = 0; i < nblock; i++) {
   if ((bhtab[(i) >> 5] & (1 << ((i) & 31))))
    j = i;
   k = fmap[i] - H;
   if (k < 0)
    k += nblock;
   eclass[k] = j;
  }
  nNotDone = 0;
  r = -1;
  while (1) {
   k = r + 1;
   while ((bhtab[(k) >> 5] & (1 << ((k) & 31))) && ((k) & 0x01f))
    k++;
   if ((bhtab[(k) >> 5] & (1 << ((k) & 31)))) {
    while (bhtab[(k) >> 5] == 0xffffffff) k += 32;
    while ((bhtab[(k) >> 5] & (1 << ((k) & 31)))) k++;
   }
   l = k - 1;
   if (l >= nblock)
    break;
   while (!(bhtab[(k) >> 5] & (1 << ((k) & 31))) && ((k) & 0x01f))
    k++;
   if (!(bhtab[(k) >> 5] & (1 << ((k) & 31)))) {
    while (bhtab[(k) >> 5] == 0x00000000) k += 32;
    while (!(bhtab[(k) >> 5] & (1 << ((k) & 31)))) k++;
   }
   r = k - 1;
   if (r >= nblock)
    break;
   if (r > l) {
    nNotDone += (r - l + 1);
    fallbackQSort3(fmap, eclass, l, r);
    cc = -1;
    for (i = l; i <= r; i++) {
     cc1 = eclass[fmap[i]];
     if (cc != cc1) {
      bhtab[(i) >> 5] |= (1 << ((i) & 31));
      cc = cc1;
     };
    }
   }
  }
  H *= 2;
  if (H > nblock || nNotDone == 0)
   break;
 }
 j = 0;
 for (i = 0; i < nblock; i++) {
  while (ftabCopy[j] == 0)
   j++;
  ftabCopy[j]--;
  eclass8[fmap[i]] = (uint8_t)j;
 }
 AssertH(j < 256, 1005);
}
static
NOINLINE
int mainGtU(
  uint32_t i1,
  uint32_t i2,
  uint8_t* block,
  uint16_t* quadrant,
  uint32_t nblock,
  int32_t* budget)
{
 int32_t k;
 uint8_t c1, c2;
 uint16_t s1, s2;
 AssertD(i1 != i2, "mainGtU");
 { int nn = 12; do { c1 = block[i1]; c2 = block[i2]; if (c1 != c2) return (c1 > c2); i1++; i2++;; } while (--nn); }
 k = nblock + 8;
 do {
  { int nn = 8; do { c1 = block[i1]; c2 = block[i2]; if (c1 != c2) return (c1 > c2); s1 = quadrant[i1]; s2 = quadrant[i2]; if (s1 != s2) return (s1 > s2); i1++; i2++;; } while (--nn); }
  if (i1 >= nblock) i1 -= nblock;
  if (i2 >= nblock) i2 -= nblock;
  (*budget)--;
  k -= 8;
 } while (k >= 0);
 return False;
}
static
const int32_t incs[14] = {
 1, 4, 13, 40, 121, 364, 1093, 3280,
 9841, 29524, 88573, 265720,
 797161, 2391484
};
static
void mainSimpleSort(uint32_t* ptr,
  uint8_t* block,
  uint16_t* quadrant,
  int32_t nblock,
  int32_t lo,
  int32_t hi,
  int32_t d,
  int32_t* budget)
{
 int32_t i, j, h, bigN, hp;
 uint32_t v;
 bigN = hi - lo + 1;
 if (bigN < 2) return;
 hp = 0;
 while (incs[hp] < bigN) hp++;
 hp--;
 for (; hp >= 0; hp--) {
  h = incs[hp];
  i = lo + h;
  while (1) {
   if (i > hi) break;
   v = ptr[i];
   j = i;
   while (mainGtU(ptr[j-h]+d, v+d, block, quadrant, nblock, budget)) {
    ptr[j] = ptr[j-h];
    j = j - h;
    if (j <= (lo + h - 1)) break;
   }
   ptr[j] = v;
   i++;
   if (*budget < 0) return;
  }
 }
}
static
ALWAYS_INLINE
uint8_t mmed3(uint8_t a, uint8_t b, uint8_t c)
{
 uint8_t t;
 if (a > b) {
  t = a;
  a = b;
  b = t;
 };
 if (b > c) {
  b = c;
  if (a > b)
   b = a;
 }
 return b;
}
static NOINLINE
void mainQSort3(uint32_t* ptr,
  uint8_t* block,
  uint16_t* quadrant,
  int32_t nblock,
  int32_t loSt,
  int32_t hiSt,
  int32_t dSt,
  int32_t* budget)
{
 int32_t unLo, unHi, ltLo, gtHi, n, m, med;
 int32_t sp, lo, hi, d;
 int32_t stackLo[100];
 int32_t stackHi[100];
 int32_t stackD [100];
 int32_t nextLo[3];
 int32_t nextHi[3];
 int32_t nextD [3];
 sp = 0;
 { stackLo[sp] = loSt; stackHi[sp] = hiSt; stackD [sp] = dSt; sp++; };
 while (sp > 0) {
  AssertH(sp < 100 - 2, 1001);
  { sp--; lo = stackLo[sp]; hi = stackHi[sp]; d = stackD [sp]; };
  if (hi - lo < 20
   || d > (BZ_N_RADIX + BZ_N_QSORT)
  ) {
   mainSimpleSort(ptr, block, quadrant, nblock, lo, hi, d, budget);
   if (*budget < 0)
    return;
   continue;
  }
  med = (int32_t) mmed3(block[ptr[lo ] + d],
                        block[ptr[hi ] + d],
                        block[ptr[(lo+hi) >> 1] + d]);
  unLo = ltLo = lo;
  unHi = gtHi = hi;
  while (1) {
   while (1) {
    if (unLo > unHi)
     break;
    n = ((int32_t)block[ptr[unLo]+d]) - med;
    if (n == 0) {
     { int32_t zztmp = ptr[unLo]; ptr[unLo] = ptr[ltLo]; ptr[ltLo] = zztmp; };
     ltLo++;
     unLo++;
     continue;
    };
    if (n > 0) break;
    unLo++;
   }
   while (1) {
    if (unLo > unHi)
     break;
    n = ((int32_t)block[ptr[unHi]+d]) - med;
    if (n == 0) {
     { int32_t zztmp = ptr[unHi]; ptr[unHi] = ptr[gtHi]; ptr[gtHi] = zztmp; };
     gtHi--;
     unHi--;
     continue;
    };
    if (n < 0) break;
    unHi--;
   }
   if (unLo > unHi)
    break;
   { int32_t zztmp = ptr[unLo]; ptr[unLo] = ptr[unHi]; ptr[unHi] = zztmp; };
   unLo++;
   unHi--;
  }
  AssertD(unHi == unLo-1, "mainQSort3(2)");
  if (gtHi < ltLo) {
   { stackLo[sp] = lo; stackHi[sp] = hi; stackD [sp] = d + 1; sp++; };
   continue;
  }
  n = mmin(ltLo-lo, unLo-ltLo); mvswap(ptr, lo, unLo-n, n);
  m = mmin(hi-gtHi, gtHi-unHi); mvswap(ptr, unLo, hi-m+1, m);
  n = lo + unLo - ltLo - 1;
  m = hi - (gtHi - unHi) + 1;
  nextLo[0] = lo; nextHi[0] = n; nextD[0] = d;
  nextLo[1] = m; nextHi[1] = hi; nextD[1] = d;
  nextLo[2] = n+1; nextHi[2] = m-1; nextD[2] = d+1;
  if ((nextHi[0] - nextLo[0]) < (nextHi[1] - nextLo[1])) { int32_t tz; tz = nextLo[0]; nextLo[0] = nextLo[1]; nextLo[1] = tz; tz = nextHi[0]; nextHi[0] = nextHi[1]; nextHi[1] = tz; tz = nextD [0]; nextD [0] = nextD [1]; nextD [1] = tz; };
  if ((nextHi[1] - nextLo[1]) < (nextHi[2] - nextLo[2])) { int32_t tz; tz = nextLo[1]; nextLo[1] = nextLo[2]; nextLo[2] = tz; tz = nextHi[1]; nextHi[1] = nextHi[2]; nextHi[2] = tz; tz = nextD [1]; nextD [1] = nextD [2]; nextD [2] = tz; };
  if ((nextHi[0] - nextLo[0]) < (nextHi[1] - nextLo[1])) { int32_t tz; tz = nextLo[0]; nextLo[0] = nextLo[1]; nextLo[1] = tz; tz = nextHi[0]; nextHi[0] = nextHi[1]; nextHi[1] = tz; tz = nextD [0]; nextD [0] = nextD [1]; nextD [1] = tz; };
  AssertD ((nextHi[0] - nextLo[0]) >= (nextHi[1] - nextLo[1]), "mainQSort3(8)");
  AssertD ((nextHi[1] - nextLo[1]) >= (nextHi[2] - nextLo[2]), "mainQSort3(9)");
  { stackLo[sp] = nextLo[0]; stackHi[sp] = nextHi[0]; stackD [sp] = nextD[0]; sp++; };
  { stackLo[sp] = nextLo[1]; stackHi[sp] = nextHi[1]; stackD [sp] = nextD[1]; sp++; };
  { stackLo[sp] = nextLo[2]; stackHi[sp] = nextHi[2]; stackD [sp] = nextD[2]; sp++; };
 }
}
static NOINLINE
void mainSort(EState* state,
  uint32_t* ptr,
  uint8_t* block,
  uint16_t* quadrant,
  uint32_t* ftab,
  int32_t nblock,
  int32_t* budget)
{
 int32_t i, j, k, ss, sb;
 uint8_t c1;
 int32_t numQSorted;
 uint16_t s;
 Bool bigDone[256];
 memset(ftab, 0, 65537 * sizeof(ftab[0]));
 j = block[0] << 8;
 i = nblock - 1;
 for (; i >= 0; i--) {
  quadrant[i] = 0;
  j = (j >> 8) | (((uint16_t)block[i]) << 8);
  ftab[j]++;
 }
 for (i = 0; i < BZ_N_OVERSHOOT; i++) {
  block [nblock+i] = block[i];
  quadrant[nblock+i] = 0;
 }
 j = ftab[0];
 for (i = 1; i <= 65536; i++) {
  j += ftab[i];
  ftab[i] = j;
 }
 s = block[0] << 8;
 i = nblock - 1;
 for (; i >= 0; i--) {
  s = (s >> 8) | (block[i] << 8);
  j = ftab[s] - 1;
  ftab[s] = j;
  ptr[j] = i;
 }
 for (i = 0; i <= 255; i++) {
  bigDone [i] = False;
  (state->mainSort__runningOrder)[i] = i;
 }
 {
  int32_t vv;
  uint32_t h = 364;
  do {
   h = (h * 171) >> 9;
   for (i = h; i <= 255; i++) {
    vv = (state->mainSort__runningOrder)[i];
    j = i;
    while ((ftab[(((state->mainSort__runningOrder)[j-h])+1) << 8] - ftab[((state->mainSort__runningOrder)[j-h]) << 8]) > (ftab[((vv)+1) << 8] - ftab[(vv) << 8])) {
     (state->mainSort__runningOrder)[j] = (state->mainSort__runningOrder)[j-h];
     j = j - h;
     if (j <= (h - 1))
      goto zero;
    }
 zero:
    (state->mainSort__runningOrder)[j] = vv;
   }
  } while (h != 1);
 }
 numQSorted = 0;
 for (i = 0; i <= 255; i++) {
  ss = (state->mainSort__runningOrder)[i];
  for (j = 0; j <= 255; j++) {
   if (j != ss) {
    sb = (ss << 8) + j;
    if (!(ftab[sb] & (1 << 21))) {
     int32_t lo = ftab[sb] & (~((1 << 21)));
     int32_t hi = (ftab[sb+1] & (~((1 << 21)))) - 1;
     if (hi > lo) {
      mainQSort3(
       ptr, block, quadrant, nblock,
       lo, hi, BZ_N_RADIX, budget
      );
      if (*budget < 0) return;
      numQSorted += (hi - lo + 1);
     }
    }
    ftab[sb] |= (1 << 21);
   }
  }
  AssertH(!bigDone[ss], 1006);
  {
   for (j = 0; j <= 255; j++) {
    (state->mainSort__copyStart)[j] = ftab[(j << 8) + ss] & (~((1 << 21)));
    (state->mainSort__copyEnd) [j] = (ftab[(j << 8) + ss + 1] & (~((1 << 21)))) - 1;
   }
   for (j = ftab[ss << 8] & (~((1 << 21))); j < (state->mainSort__copyStart)[ss]; j++) {
    k = ptr[j] - 1;
    if (k < 0)
     k += nblock;
    c1 = block[k];
    if (!bigDone[c1])
     ptr[(state->mainSort__copyStart)[c1]++] = k;
   }
   for (j = (ftab[(ss+1) << 8] & (~((1 << 21)))) - 1; j > (state->mainSort__copyEnd)[ss]; j--) {
    k = ptr[j]-1;
    if (k < 0)
     k += nblock;
    c1 = block[k];
    if (!bigDone[c1])
     ptr[(state->mainSort__copyEnd)[c1]--] = k;
   }
  }
  AssertH(((state->mainSort__copyStart)[ss]-1 == (state->mainSort__copyEnd)[ss]) || ((state->mainSort__copyStart)[ss] == 0 && (state->mainSort__copyEnd)[ss] == nblock-1), 1007);
  for (j = 0; j <= 255; j++)
   ftab[(j << 8) + ss] |= (1 << 21);
  bigDone[ss] = True;
  if (i < 255) {
   int32_t bbStart = ftab[ss << 8] & (~((1 << 21)));
   int32_t bbSize = (ftab[(ss+1) << 8] & (~((1 << 21)))) - bbStart;
   int32_t shifts = 0;
   while ((bbSize >> shifts) > 65534) shifts++;
   for (j = bbSize-1; j >= 0; j--) {
    int32_t a2update = ptr[bbStart + j];
    uint16_t qVal = (uint16_t)(j >> shifts);
    quadrant[a2update] = qVal;
    if (a2update < BZ_N_OVERSHOOT)
     quadrant[a2update + nblock] = qVal;
   }
   AssertH(((bbSize-1) >> shifts) <= 65535, 1002);
  }
 }
}
static NOINLINE
void BZ2_blockSort(EState* s)
{
 enum { wfact = 30 };
 uint32_t* ptr = s->ptr;
 uint8_t* block = s->block;
 uint32_t* ftab = s->ftab;
 int32_t nblock = s->nblock;
 uint16_t* quadrant;
 int32_t budget;
 int32_t i;
 if (nblock < 10000) {
  fallbackSort(s->arr1, s->arr2, ftab, nblock);
 } else {
  i = nblock + BZ_N_OVERSHOOT;
  if (i & 1) i++;
  quadrant = (uint16_t*)(&(block[i]));
  budget = nblock * ((wfact-1) / 3);
  mainSort(s, ptr, block, quadrant, ftab, nblock, &budget);
  if (budget < 0) {
   fallbackSort(s->arr1, s->arr2, ftab, nblock);
  }
 }
 s->origPtr = -1;
 for (i = 0; i < s->nblock; i++)
  if (ptr[i] == 0) {
   s->origPtr = i;
   break;
  };
 AssertH(s->origPtr != -1, 1003);
}
