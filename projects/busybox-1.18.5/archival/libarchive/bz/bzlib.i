static
void prepare_new_block(EState* s)
{
 int i;
 s->nblock = 0;
 s->numZ = 0;
 s->state_out_pos = 0;
 BZ_INITIALISE_CRC(s->blockCRC);
 for (i = 0; i < 256; i++)
  s->inUse[i] = 0;
 s->blockNo++;
}
static
ALWAYS_INLINE
void init_RL(EState* s)
{
 s->state_in_ch = 256;
 s->state_in_len = 0;
}
static
int isempty_RL(EState* s)
{
 return (s->state_in_ch >= 256 || s->state_in_len <= 0);
}
static
void BZ2_bzCompressInit(bz_stream *strm, int blockSize100k)
{
 int32_t n;
 EState* s;
 s = xzalloc(sizeof(EState));
 s->strm = strm;
 n = 100000 * blockSize100k;
 s->arr1 = xmalloc(n * sizeof(uint32_t));
 s->mtfv = (uint16_t*)s->arr1;
 s->ptr = (uint32_t*)s->arr1;
 s->arr2 = xmalloc((n + BZ_N_OVERSHOOT) * sizeof(uint32_t));
 s->block = (uint8_t*)s->arr2;
 s->ftab = xmalloc(65537 * sizeof(uint32_t));
 s->crc32table = crc32_filltable(NULL, 1);
 s->state = BZ_S_INPUT;
 s->mode = BZ_M_RUNNING;
 s->blockSize100k = blockSize100k;
 s->nblockMAX = n - 19;
 strm->state = s;
 strm->total_out = 0;
 init_RL(s);
 prepare_new_block(s);
}
static
void add_pair_to_block(EState* s)
{
 int32_t i;
 uint8_t ch = (uint8_t)(s->state_in_ch);
 for (i = 0; i < s->state_in_len; i++) {
  BZ_UPDATE_CRC(s, s->blockCRC, ch);
 }
 s->inUse[s->state_in_ch] = 1;
 switch (s->state_in_len) {
  case 3:
   s->block[s->nblock] = (uint8_t)ch; s->nblock++;
  case 2:
   s->block[s->nblock] = (uint8_t)ch; s->nblock++;
  case 1:
   s->block[s->nblock] = (uint8_t)ch; s->nblock++;
   break;
  default:
   s->inUse[s->state_in_len - 4] = 1;
   s->block[s->nblock] = (uint8_t)ch; s->nblock++;
   s->block[s->nblock] = (uint8_t)ch; s->nblock++;
   s->block[s->nblock] = (uint8_t)ch; s->nblock++;
   s->block[s->nblock] = (uint8_t)ch; s->nblock++;
   s->block[s->nblock] = (uint8_t)(s->state_in_len - 4);
   s->nblock++;
   break;
 }
}
static
void flush_RL(EState* s)
{
 if (s->state_in_ch < 256) add_pair_to_block(s);
 init_RL(s);
}
static
void copy_input_until_stop(EState* s)
{
 {
  while (1) {
   if (s->strm->avail_in == 0) break;
   if (s->nblock >= s->nblockMAX) break;
   { uint32_t zchh = (uint32_t)(*(uint8_t*)(s->strm->next_in)); if (zchh != s->state_in_ch && s->state_in_len == 1) { uint8_t ch = (uint8_t)(s->state_in_ch); BZ_UPDATE_CRC(s, s->blockCRC, ch); s->inUse[s->state_in_ch] = 1; s->block[s->nblock] = (uint8_t)ch; s->nblock++; s->state_in_ch = zchh; } else if (zchh != s->state_in_ch || s->state_in_len == 255) { if (s->state_in_ch < 256) add_pair_to_block(s); s->state_in_ch = zchh; s->state_in_len = 1; } else { s->state_in_len++; } };
   s->strm->next_in++;
   s->strm->avail_in--;
  }
 }
}
static
void copy_output_until_stop(EState* s)
{
 while (1) {
  if (s->strm->avail_out == 0) break;
  if (s->state_out_pos >= s->numZ) break;
  *(s->strm->next_out) = s->zbits[s->state_out_pos];
  s->state_out_pos++;
  s->strm->avail_out--;
  s->strm->next_out++;
  s->strm->total_out++;
 }
}
static
void handle_compress(bz_stream *strm)
{
 EState* s = strm->state;
 while (1) {
  if (s->state == BZ_S_OUTPUT) {
                       copy_output_until_stop(s);
   if (s->state_out_pos < s->numZ) break;
   if (s->mode == BZ_M_FINISHING
    && s->strm->avail_in == 0
    && isempty_RL(s))
    break;
   prepare_new_block(s);
   s->state = BZ_S_INPUT;
  }
  if (s->state == BZ_S_INPUT) {
                      copy_input_until_stop(s);
   if (s->mode != BZ_M_RUNNING && s->strm->avail_in == 0) {
    flush_RL(s);
    BZ2_compressBlock(s, (s->mode == BZ_M_FINISHING));
    s->state = BZ_S_OUTPUT;
   } else
   if (s->nblock >= s->nblockMAX) {
    BZ2_compressBlock(s, 0);
    s->state = BZ_S_OUTPUT;
   } else
   if (s->strm->avail_in == 0) {
    break;
   }
  }
 }
}
static
int BZ2_bzCompress(bz_stream *strm, int action)
{
 EState* s;
 s = strm->state;
 switch (s->mode) {
  case BZ_M_RUNNING:
   if (action == BZ_RUN) {
                   handle_compress(strm);
    return BZ_RUN_OK;
   }
   else
                                {
    s->mode = BZ_M_FINISHING;
    goto case_BZ_M_FINISHING;
   }
 case_BZ_M_FINISHING:
  default:
                  handle_compress(strm);
   if (s->strm->avail_in > 0 || !isempty_RL(s) || s->state_out_pos < s->numZ)
    return BZ_FINISH_OK;
   return BZ_STREAM_END;
 }
}
static
void BZ2_bzCompressEnd(bz_stream *strm)
{
 EState* s;
 s = strm->state;
 free(s->arr1);
 free(s->arr2);
 free(s->ftab);
 free(s->crc32table);
 free(s);
}
