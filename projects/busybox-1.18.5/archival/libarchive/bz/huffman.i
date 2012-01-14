static
void DOWNHEAP1(int32_t *heap, int32_t *weight, int32_t nHeap)
{
 int32_t zz, yy, tmp;
 zz = 1;
 tmp = heap[zz];
 while (1) {
  yy = zz << 1;
  if (yy > nHeap)
   break;
  if (yy < nHeap
   && weight[heap[yy + 1]] < weight[heap[yy]])
   yy++;
  if (weight[tmp] < weight[heap[yy]])
   break;
  heap[zz] = heap[yy];
  zz = yy;
 }
 heap[zz] = tmp;
}
static
void BZ2_hbMakeCodeLengths(EState *s,
  uint8_t *len,
  int32_t *freq,
  int32_t alphaSize,
  int32_t maxLen)
{
 int32_t nNodes, nHeap, n1, n2, i, j, k;
 Bool tooLong;
 for (i = 0; i < alphaSize; i++)
  (s->BZ2_hbMakeCodeLengths__weight)[i+1] = (freq[i] == 0 ? 1 : freq[i]) << 8;
 while (1) {
  nNodes = alphaSize;
  nHeap = 0;
  (s->BZ2_hbMakeCodeLengths__heap)[0] = 0;
  (s->BZ2_hbMakeCodeLengths__weight)[0] = 0;
  (s->BZ2_hbMakeCodeLengths__parent)[0] = -2;
  for (i = 1; i <= alphaSize; i++) {
   (s->BZ2_hbMakeCodeLengths__parent)[i] = -1;
   nHeap++;
   (s->BZ2_hbMakeCodeLengths__heap)[nHeap] = i;
   { int32_t zz, tmp; zz = nHeap; tmp = (s->BZ2_hbMakeCodeLengths__heap)[zz]; while ((s->BZ2_hbMakeCodeLengths__weight)[tmp] < (s->BZ2_hbMakeCodeLengths__weight)[(s->BZ2_hbMakeCodeLengths__heap)[zz >> 1]]) { (s->BZ2_hbMakeCodeLengths__heap)[zz] = (s->BZ2_hbMakeCodeLengths__heap)[zz >> 1]; zz >>= 1; } (s->BZ2_hbMakeCodeLengths__heap)[zz] = tmp; };
  }
  AssertH(nHeap < (BZ_MAX_ALPHA_SIZE+2), 2001);
  while (nHeap > 1) {
   n1 = (s->BZ2_hbMakeCodeLengths__heap)[1]; (s->BZ2_hbMakeCodeLengths__heap)[1] = (s->BZ2_hbMakeCodeLengths__heap)[nHeap]; nHeap--; DOWNHEAP1((s->BZ2_hbMakeCodeLengths__heap), (s->BZ2_hbMakeCodeLengths__weight), nHeap);
   n2 = (s->BZ2_hbMakeCodeLengths__heap)[1]; (s->BZ2_hbMakeCodeLengths__heap)[1] = (s->BZ2_hbMakeCodeLengths__heap)[nHeap]; nHeap--; DOWNHEAP1((s->BZ2_hbMakeCodeLengths__heap), (s->BZ2_hbMakeCodeLengths__weight), nHeap);
   nNodes++;
   (s->BZ2_hbMakeCodeLengths__parent)[n1] = (s->BZ2_hbMakeCodeLengths__parent)[n2] = nNodes;
   (s->BZ2_hbMakeCodeLengths__weight)[nNodes] = ((((s->BZ2_hbMakeCodeLengths__weight)[n1]) & 0xffffff00)+(((s->BZ2_hbMakeCodeLengths__weight)[n2]) & 0xffffff00)) | (1 + (((((s->BZ2_hbMakeCodeLengths__weight)[n1]) & 0x000000ff)) > ((((s->BZ2_hbMakeCodeLengths__weight)[n2]) & 0x000000ff)) ? ((((s->BZ2_hbMakeCodeLengths__weight)[n1]) & 0x000000ff)) : ((((s->BZ2_hbMakeCodeLengths__weight)[n2]) & 0x000000ff))));
   (s->BZ2_hbMakeCodeLengths__parent)[nNodes] = -1;
   nHeap++;
   (s->BZ2_hbMakeCodeLengths__heap)[nHeap] = nNodes;
   { int32_t zz, tmp; zz = nHeap; tmp = (s->BZ2_hbMakeCodeLengths__heap)[zz]; while ((s->BZ2_hbMakeCodeLengths__weight)[tmp] < (s->BZ2_hbMakeCodeLengths__weight)[(s->BZ2_hbMakeCodeLengths__heap)[zz >> 1]]) { (s->BZ2_hbMakeCodeLengths__heap)[zz] = (s->BZ2_hbMakeCodeLengths__heap)[zz >> 1]; zz >>= 1; } (s->BZ2_hbMakeCodeLengths__heap)[zz] = tmp; };
  }
  AssertH(nNodes < (BZ_MAX_ALPHA_SIZE * 2), 2002);
  tooLong = False;
  for (i = 1; i <= alphaSize; i++) {
   j = 0;
   k = i;
   while ((s->BZ2_hbMakeCodeLengths__parent)[k] >= 0) {
    k = (s->BZ2_hbMakeCodeLengths__parent)[k];
    j++;
   }
   len[i-1] = j;
   if (j > maxLen)
    tooLong = True;
  }
  if (!tooLong)
   break;
  for (i = 1; i <= alphaSize; i++) {
   j = (s->BZ2_hbMakeCodeLengths__weight)[i] >> 8;
   j = 1 + (j / 2);
   (s->BZ2_hbMakeCodeLengths__weight)[i] = j << 8;
  }
 }
}
static
void BZ2_hbAssignCodes(int32_t *code,
  uint8_t *length,
  int32_t minLen,
  int32_t maxLen,
  int32_t alphaSize)
{
 int32_t n, vec, i;
 vec = 0;
 for (n = minLen; n <= maxLen; n++) {
  for (i = 0; i < alphaSize; i++) {
   if (length[i] == n) {
    code[i] = vec;
    vec++;
   };
  }
  vec <<= 1;
 }
}
