static
void BZ2_bsInitWrite(EState* s)
{
 s->bsLive = 0;
 s->bsBuff = 0;
}
static NOINLINE
void bsFinishWrite(EState* s)
{
 while (s->bsLive > 0) {
  s->zbits[s->numZ] = (uint8_t)(s->bsBuff >> 24);
  s->numZ++;
  s->bsBuff <<= 8;
  s->bsLive -= 8;
 }
}
static
void bsW(EState* s, int32_t n, uint32_t v)
{
 while (s->bsLive >= 8) {
  s->zbits[s->numZ] = (uint8_t)(s->bsBuff >> 24);
  s->numZ++;
  s->bsBuff <<= 8;
  s->bsLive -= 8;
 }
 s->bsBuff |= (v << (32 - s->bsLive - n));
 s->bsLive += n;
}
static
void bsPutU32(EState* s, unsigned u)
{
 bsW(s, 8, (u >> 24) & 0xff);
 bsW(s, 8, (u >> 16) & 0xff);
 bsW(s, 8, (u >> 8) & 0xff);
 bsW(s, 8, u & 0xff);
}
static
void bsPutU16(EState* s, unsigned u)
{
 bsW(s, 8, (u >> 8) & 0xff);
 bsW(s, 8, u & 0xff);
}
static
void makeMaps_e(EState* s)
{
 int i;
 s->nInUse = 0;
 for (i = 0; i < 256; i++) {
  if (s->inUse[i]) {
   s->unseqToSeq[i] = s->nInUse;
   s->nInUse++;
  }
 }
}
static NOINLINE
void generateMTFValues(EState* s)
{
 uint8_t yy[256];
 int32_t i, j;
 int32_t zPend;
 int32_t wr;
 int32_t EOB;
 uint32_t* ptr = s->ptr;
 uint8_t* block = s->block;
 uint16_t* mtfv = s->mtfv;
 makeMaps_e(s);
 EOB = s->nInUse+1;
 for (i = 0; i <= EOB; i++)
  s->mtfFreq[i] = 0;
 wr = 0;
 zPend = 0;
 for (i = 0; i < s->nInUse; i++)
  yy[i] = (uint8_t) i;
 for (i = 0; i < s->nblock; i++) {
  uint8_t ll_i;
  AssertD(wr <= i, "generateMTFValues(1)");
  j = ptr[i] - 1;
  if (j < 0)
   j += s->nblock;
  ll_i = s->unseqToSeq[block[j]];
  AssertD(ll_i < s->nInUse, "generateMTFValues(2a)");
  if (yy[0] == ll_i) {
   zPend++;
  } else {
   if (zPend > 0) {
    zPend--;
    while (1) {
     if (zPend & 1) {
      mtfv[wr] = BZ_RUNB; wr++;
      s->mtfFreq[BZ_RUNB]++;
     } else {
      mtfv[wr] = BZ_RUNA; wr++;
      s->mtfFreq[BZ_RUNA]++;
     }
     if (zPend < 2) break;
     zPend = (uint32_t)(zPend - 2) / 2;
    };
    zPend = 0;
   }
   {
    register uint8_t rtmp;
    register uint8_t* ryy_j;
    register uint8_t rll_i;
    rtmp = yy[1];
    yy[1] = yy[0];
    ryy_j = &(yy[1]);
    rll_i = ll_i;
    while (rll_i != rtmp) {
     register uint8_t rtmp2;
     ryy_j++;
     rtmp2 = rtmp;
     rtmp = *ryy_j;
     *ryy_j = rtmp2;
    };
    yy[0] = rtmp;
    j = ryy_j - &(yy[0]);
    mtfv[wr] = j+1;
    wr++;
    s->mtfFreq[j+1]++;
   }
  }
 }
 if (zPend > 0) {
  zPend--;
  while (1) {
   if (zPend & 1) {
    mtfv[wr] = BZ_RUNB;
    wr++;
    s->mtfFreq[BZ_RUNB]++;
   } else {
    mtfv[wr] = BZ_RUNA;
    wr++;
    s->mtfFreq[BZ_RUNA]++;
   }
   if (zPend < 2)
    break;
   zPend = (uint32_t)(zPend - 2) / 2;
  };
  zPend = 0;
 }
 mtfv[wr] = EOB;
 wr++;
 s->mtfFreq[EOB]++;
 s->nMTF = wr;
}
static NOINLINE
void sendMTFValues(EState* s)
{
 int32_t v, t, i, j, gs, ge, totc, bt, bc, iter;
 int32_t nSelectors, alphaSize, minLen, maxLen, selCtr;
 int32_t nGroups, nBytes;
 uint16_t cost[BZ_N_GROUPS];
 int32_t fave[BZ_N_GROUPS];
 uint16_t* mtfv = s->mtfv;
 alphaSize = s->nInUse + 2;
 for (t = 0; t < BZ_N_GROUPS; t++)
  for (v = 0; v < alphaSize; v++)
   s->len[t][v] = 15;
 AssertH(s->nMTF > 0, 3001);
 if (s->nMTF < 200) nGroups = 2; else
 if (s->nMTF < 600) nGroups = 3; else
 if (s->nMTF < 1200) nGroups = 4; else
 if (s->nMTF < 2400) nGroups = 5; else
 nGroups = 6;
 {
  int32_t nPart, remF, tFreq, aFreq;
  nPart = nGroups;
  remF = s->nMTF;
  gs = 0;
  while (nPart > 0) {
   tFreq = remF / nPart;
   ge = gs - 1;
   aFreq = 0;
   while (aFreq < tFreq && ge < alphaSize-1) {
    ge++;
    aFreq += s->mtfFreq[ge];
   }
   if (ge > gs
    && nPart != nGroups && nPart != 1
    && ((nGroups - nPart) % 2 == 1)
   ) {
    aFreq -= s->mtfFreq[ge];
    ge--;
   }
   for (v = 0; v < alphaSize; v++)
    if (v >= gs && v <= ge)
     s->len[nPart-1][v] = 0;
    else
     s->len[nPart-1][v] = 15;
   nPart--;
   gs = ge + 1;
   remF -= aFreq;
  }
 }
 for (iter = 0; iter < BZ_N_ITERS; iter++) {
  for (t = 0; t < nGroups; t++)
   fave[t] = 0;
  for (t = 0; t < nGroups; t++)
   for (v = 0; v < alphaSize; v++)
    s->sendMTFValues__rfreq[t][v] = 0;
  nSelectors = 0;
  totc = 0;
  gs = 0;
  while (1) {
   if (gs >= s->nMTF)
    break;
   ge = gs + BZ_G_SIZE - 1;
   if (ge >= s->nMTF)
    ge = s->nMTF-1;
   for (t = 0; t < nGroups; t++)
    cost[t] = 0;
   {
    for (i = gs; i <= ge; i++) {
     uint16_t icv = mtfv[i];
     for (t = 0; t < nGroups; t++)
      cost[t] += s->len[t][icv];
    }
   }
   bc = cost[0];
   bt = 0;
   for (t = 1 ; t < nGroups; t++) {
    if (cost[t] < bc) {
     bc = cost[t];
     bt = t;
    }
   }
   totc += bc;
   fave[bt]++;
   s->selector[nSelectors] = bt;
   nSelectors++;
   {
    while (gs <= ge) {
     s->sendMTFValues__rfreq[bt][mtfv[gs]]++;
     gs++;
    }
   }
  }
  for (t = 0; t < nGroups; t++)
   BZ2_hbMakeCodeLengths(s, &(s->len[t][0]), &(s->sendMTFValues__rfreq[t][0]), alphaSize, 17 );
 }
 AssertH(nGroups < 8, 3002);
 AssertH(nSelectors < 32768 && nSelectors <= (2 + (900000 / BZ_G_SIZE)), 3003);
 {
  uint8_t pos[BZ_N_GROUPS], ll_i, tmp2, tmp;
  for (i = 0; i < nGroups; i++)
   pos[i] = i;
  for (i = 0; i < nSelectors; i++) {
   ll_i = s->selector[i];
   j = 0;
   tmp = pos[j];
   while (ll_i != tmp) {
    j++;
    tmp2 = tmp;
    tmp = pos[j];
    pos[j] = tmp2;
   };
   pos[0] = tmp;
   s->selectorMtf[i] = j;
  }
 };
 for (t = 0; t < nGroups; t++) {
  minLen = 32;
  maxLen = 0;
  for (i = 0; i < alphaSize; i++) {
   if (s->len[t][i] > maxLen) maxLen = s->len[t][i];
   if (s->len[t][i] < minLen) minLen = s->len[t][i];
  }
  AssertH(!(maxLen > 17 ), 3004);
  AssertH(!(minLen < 1), 3005);
  BZ2_hbAssignCodes(&(s->sendMTFValues__code[t][0]), &(s->len[t][0]), minLen, maxLen, alphaSize);
 }
 {
  int inUse16 = 0;
  for (i = 0; i < 16; i++) {
   if (sizeof(long) <= 4) {
    inUse16 = inUse16*2 +
     ((*(uint32_t*)&(s->inUse[i * 16 + 0])
     | *(uint32_t*)&(s->inUse[i * 16 + 4])
     | *(uint32_t*)&(s->inUse[i * 16 + 8])
     | *(uint32_t*)&(s->inUse[i * 16 + 12])) != 0);
   } else {
    inUse16 = inUse16*2 +
     ((*(uint64_t*)&(s->inUse[i * 16 + 0])
     | *(uint64_t*)&(s->inUse[i * 16 + 8])) != 0);
   }
  }
  nBytes = s->numZ;
  bsW(s, 16, inUse16);
  inUse16 <<= (sizeof(int)*8 - 16);
  for (i = 0; i < 16; i++) {
   if (inUse16 < 0) {
    unsigned v16 = 0;
    for (j = 0; j < 16; j++)
     v16 = v16*2 + s->inUse[i * 16 + j];
    bsW(s, 16, v16);
   }
   inUse16 <<= 1;
  }
 }
 nBytes = s->numZ;
 bsW(s, 3, nGroups);
 bsW(s, 15, nSelectors);
 for (i = 0; i < nSelectors; i++) {
  for (j = 0; j < s->selectorMtf[i]; j++)
   bsW(s, 1, 1);
  bsW(s, 1, 0);
 }
 nBytes = s->numZ;
 for (t = 0; t < nGroups; t++) {
  int32_t curr = s->len[t][0];
  bsW(s, 5, curr);
  for (i = 0; i < alphaSize; i++) {
   while (curr < s->len[t][i]) { bsW(s, 2, 2); curr++; };
   while (curr > s->len[t][i]) { bsW(s, 2, 3); curr--; };
   bsW(s, 1, 0);
  }
 }
 nBytes = s->numZ;
 selCtr = 0;
 gs = 0;
 while (1) {
  if (gs >= s->nMTF)
   break;
  ge = gs + BZ_G_SIZE - 1;
  if (ge >= s->nMTF)
   ge = s->nMTF-1;
  AssertH(s->selector[selCtr] < nGroups, 3006);
  {
   uint8_t* s_len_sel_selCtr = &(s->len [s->selector[selCtr]][0]);
   int32_t* s_code_sel_selCtr = &(s->sendMTFValues__code[s->selector[selCtr]][0]);
   while (gs <= ge) {
    bsW(s,
     s_len_sel_selCtr[mtfv[gs]],
     s_code_sel_selCtr[mtfv[gs]]
    );
    gs++;
   }
  }
  selCtr++;
 }
 AssertH(selCtr == nSelectors, 3007);
}
static
void BZ2_compressBlock(EState* s, int is_last_block)
{
 if (s->nblock > 0) {
  BZ_FINALISE_CRC(s->blockCRC);
  s->combinedCRC = (s->combinedCRC << 1) | (s->combinedCRC >> 31);
  s->combinedCRC ^= s->blockCRC;
  if (s->blockNo > 1)
   s->numZ = 0;
  BZ2_blockSort(s);
 }
 s->zbits = &((uint8_t*)s->arr2)[s->nblock];
 if (s->blockNo == 1) {
  BZ2_bsInitWrite(s);
  bsPutU32(s, BZ_HDR_BZh0 + s->blockSize100k);
 }
 if (s->nblock > 0) {
  bsPutU32(s, 0x31415926);
  bsPutU16(s, 0x5359);
  bsPutU32(s, s->blockCRC);
  bsW(s, 1, 0);
  bsW(s, 24, s->origPtr);
  generateMTFValues(s);
  sendMTFValues(s);
 }
 if (is_last_block) {
  bsPutU32(s, 0x17724538);
  bsPutU16(s, 0x5090);
  bsPutU32(s, s->combinedCRC);
  bsFinishWrite(s);
 }
}
