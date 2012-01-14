static NOINLINE unsigned
do_compress(const uint8_t* in, unsigned in_len,
  uint8_t* out, unsigned* out_len,
  void* wrkmem)
{
 register const uint8_t* ip;
 uint8_t* op;
 const uint8_t* const in_end = in + in_len;
 const uint8_t* const ip_end = in + in_len - M2_MAX_LEN - 5;
 const uint8_t* ii;
 const void* *const dict = (const void**) wrkmem;
 op = out;
 ip = in;
 ii = ip;
 ip += 4;
 for (;;) {
  register const uint8_t* m_pos;
  unsigned m_off;
  unsigned m_len;
  unsigned dindex;
  D_INDEX1(dindex,ip);
  GINDEX(m_pos,m_off,dict,dindex,in);
  if (LZO_CHECK_MPOS_NON_DET(m_pos,m_off,in,ip,M4_MAX_OFFSET))
   goto literal;
  if (m_off <= M2_MAX_OFFSET || m_pos[3] == ip[3])
   goto try_match;
  D_INDEX2(dindex,ip);
  GINDEX(m_pos,m_off,dict,dindex,in);
  if (LZO_CHECK_MPOS_NON_DET(m_pos,m_off,in,ip,M4_MAX_OFFSET))
   goto literal;
  if (m_off <= M2_MAX_OFFSET || m_pos[3] == ip[3])
   goto try_match;
  goto literal;
 try_match:
  if (m_pos[0] != ip[0] || m_pos[1] != ip[1])
  {
  } else {
   if (m_pos[2] == ip[2]) {
     goto match;
   }
   else {
   }
  }
 literal:
  UPDATE_I(dict, 0, dindex, ip, in);
  ++ip;
  if (ip >= ip_end)
   break;
  continue;
match:
  UPDATE_I(dict, 0, dindex, ip, in);
  if (pd(ip, ii) > 0) {
   register unsigned t = pd(ip, ii);
   if (t <= 3) {
    assert(op - 2 > out);
    op[-2] |= (uint8_t)(t);
   }
   else if (t <= 18)
    *op++ = (uint8_t)(t - 3);
   else {
    register unsigned tt = t - 18;
    *op++ = 0;
    while (tt > 255) {
     tt -= 255;
     *op++ = 0;
    }
    assert(tt > 0);
    *op++ = (uint8_t)(tt);
   }
   do *op++ = *ii++; while (--t > 0);
  }
  assert(ii == ip);
  ip += 3;
  if (m_pos[3] != *ip++ || m_pos[4] != *ip++ || m_pos[5] != *ip++
   || m_pos[6] != *ip++ || m_pos[7] != *ip++ || m_pos[8] != *ip++
  ) {
   --ip;
   m_len = pd(ip, ii);
   assert(m_len >= 3);
   assert(m_len <= M2_MAX_LEN);
   if (m_off <= M2_MAX_OFFSET) {
    m_off -= 1;
   }
   else if (m_off <= M3_MAX_OFFSET) {
    m_off -= 1;
    *op++ = (uint8_t)(M3_MARKER | (m_len - 2));
    goto m3_m4_offset;
   } else {
   }
  }
  else {
   {
    const uint8_t* end = in_end;
    const uint8_t* m = m_pos + M2_MAX_LEN + 1;
    while (ip < end && *m == *ip)
     m++, ip++;
    m_len = pd(ip, ii);
   }
   assert(m_len > M2_MAX_LEN);
   if (m_off <= M3_MAX_OFFSET) {
    m_off -= 1;
    if (m_len <= 33)
     *op++ = (uint8_t)(M3_MARKER | (m_len - 2));
    else {
     m_len -= 33;
     *op++ = M3_MARKER | 0;
     goto m3_m4_len;
    }
   } else {
    m_off -= 0x4000;
    assert(m_off > 0);
    assert(m_off <= 0x7fff);
    if (m_len <= M4_MAX_LEN)
     *op++ = (uint8_t)(M4_MARKER | ((m_off & 0x4000) >> 11) | (m_len - 2));
    else {
     m_len -= M4_MAX_LEN;
     *op++ = (uint8_t)(M4_MARKER | ((m_off & 0x4000) >> 11));
 m3_m4_len:
     while (m_len > 255) {
      m_len -= 255;
      *op++ = 0;
     }
     assert(m_len > 0);
     *op++ = (uint8_t)(m_len);
    }
   }
 m3_m4_offset:
   *op++ = (uint8_t)((m_off & 63) << 2);
   *op++ = (uint8_t)(m_off >> 6);
  }
  ii = ip;
  if (ip >= ip_end)
   break;
 }
 *out_len = pd(op, out);
 return pd(in_end, ii);
}
int DO_COMPRESS(const uint8_t* in, unsigned in_len,
  uint8_t* out, unsigned* out_len,
  void* wrkmem)
{
 uint8_t* op = out;
 unsigned t;
 if (in_len <= M2_MAX_LEN + 5)
  t = in_len;
 else {
  t = do_compress(in,in_len,op,out_len,wrkmem);
  op += *out_len;
 }
 if (t > 0) {
  const uint8_t* ii = in + in_len - t;
  if (op == out && t <= 238)
   *op++ = (uint8_t)(17 + t);
  else if (t <= 3)
   op[-2] |= (uint8_t)(t);
  else if (t <= 18)
   *op++ = (uint8_t)(t - 3);
  else {
   unsigned tt = t - 18;
   *op++ = 0;
   while (tt > 255) {
    tt -= 255;
    *op++ = 0;
   }
   assert(tt > 0);
   *op++ = (uint8_t)(tt);
  }
  do *op++ = *ii++; while (--t > 0);
 }
 *op++ = M4_MARKER | 1;
 *op++ = 0;
 *op++ = 0;
 *out_len = pd(op, out);
 return 0;
}
