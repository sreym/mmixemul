DEBUG = true

shared = window

shared.addLeadZero = (str, len) ->
  strRes = str
  while strRes.length < len
    strRes = "0" + strRes
  return strRes

class shared.OctaByte
  constructor: (hbyte, lbyte = null) ->
    if hbyte instanceof shared.OctaByte and lbyte is null
      @hbyte = hbyte.hbyte
      @lbyte = hbyte.lbyte
    else
      throw "hbyte should be type of number" if DEBUG and typeof hbyte isnt "number"
      throw "lbyte should be type of number" if DEBUG and typeof lbyte isnt "number"
      @hbyte = hbyte
      @lbyte = lbyte
  is_neg: () ->
    (@hbyte >>> 31) > 0
  setH: (val) ->
    @hbyte = @getMH() ^ (val << 16)
  setMH: (val) ->
    @hbyte = (@getH() << 16) ^ val
  setML: (val) ->
    @lbyte = @getL() ^ (val << 16)
  setL: (val) ->
    @lbyte = (@getML() << 16) ^ val
  set: (i, val) ->
    switch i
      when 0 then @setH(val)
      when 1 then @setMH(val)
      when 2 then @setML(val)
      when 3 then @setL(val)
  setByte: (i, val) ->
    wydeVal = @get(i / 2 | 0)
    if i % 2 == 0
      wydeVal = (wydeVal & 0x00FF) ^ ((val & 0xFF) << 8)
    else
      wydeVal = (wydeVal & 0xFF00) ^ (val & 0xFF)
    @set(i / 2 | 0, wydeVal)
  getH: () ->
    @hbyte >>> 16
  getMH: () ->
    @hbyte & ((1 << 16) - 1)
  getML: () ->
    @lbyte >>> 16
  getL: () ->
    @lbyte & ((1 << 16) - 1)
  get: (i) ->
    switch i
      when 0 then @getH()
      when 1 then @getMH()
      when 2 then @getML()
      when 3 then @getL()
  getByte: (i) ->
    wydeVal = @get(i / 2 | 0)
    if i % 2 == 0
      wydeVal >>> 8
    else
      wydeVal & 0xFF


  setFloat: (val) ->
    dArray = new Float32Array(1)
    dArray[0] = val

    dArray64 = new Float64Array(1)
    dArray64[0] = dArray[0]
    i8Array = new Uint8Array(dArray64.buffer)

    @hbyte = (i8Array[0] << 24) + (i8Array[1] << 16) + (i8Array[2] << 8) + (i8Array[3] << 0)
    @lbyte = (i8Array[4] << 24) + (i8Array[5] << 16) + (i8Array[6] << 8) + (i8Array[7] << 0)


  setInt: (val, signed = true) ->
    nVal = if val > 0 then val else -val
    @lbyte = nVal & 0xFFFFFFFF
    @hbyte = (nVal / (Math.pow(2, 32))) & 0xFFFFFFFF

    if signed and val < 0
        @assign(@neg().add(1))


  getDouble: () ->
    i8Array = new Uint8Array(8)
    i8Array[0] = (@hbyte >>> 24) && 0xFF
    i8Array[1] = (@hbyte >>> 16) && 0xFF
    i8Array[2] = (@hbyte >>>  8) && 0xFF
    i8Array[3] = (@hbyte >>>  0) && 0xFF
    i8Array[4] = (@lbyte >>> 24) && 0xFF
    i8Array[5] = (@lbyte >>> 16) && 0xFF
    i8Array[6] = (@lbyte >>>  8) && 0xFF
    i8Array[7] = (@lbyte >>>  0) && 0xFF
    return new Float64Array(i8Array.buffer)[0]

  setDouble: (val) ->
    dArray = new Float64Array(1)
    dArray[0] = val
    i8Array = new Uint8Array(dArray.buffer)
    @hbyte = (i8Array[0] << 24) + (i8Array[1] << 16) + (i8Array[2] << 8) + (i8Array[3] << 0)
    @lbyte = (i8Array[4] << 24) + (i8Array[5] << 16) + (i8Array[6] << 8) + (i8Array[7] << 0)

  add: (b, exc = null) ->
    if b instanceof shared.OctaByte
      nob = new shared.OctaByte((@hbyte >>> 0) + (b.hbyte >>> 0), (@lbyte >>> 0) + (b.lbyte >>> 0))
    else
      nob = new shared.OctaByte(@hbyte >>> 0, (@lbyte >>> 0) + (b >>> 0))
    if nob.lbyte > 0xFFFFFFFF
      nob.hbyte = nob.hbyte + 1
      nob.lbyte = (nob.lbyte & 0xFFFFFFFF) >>> 0
    if nob.hbyte > 0xFFFFFFFF
      nob.hbyte = nob.hbyte & 0xFFFFFFFF
      exc = "OctaByte overflow"
    return nob
  sub: (b, exc = null) ->
    if b instanceof shared.OctaByte
      bOct = new shared.OctaByte(b)
    else
      bOct = new shared.OctaByte(0, b)

    bOct.hbyte = (bOct.hbyte & 0xFFFFFFFF) ^ 0xFFFFFFFF
    bOct.lbyte = (bOct.lbyte & 0xFFFFFFFF) ^ 0xFFFFFFFF
    bOct = bOct.add(1)

    return @.add(bOct)

  or: (b) ->
    if b instanceof shared.OctaByte
      new shared.OctaByte(@.hbyte | b.hbyte, @.lbyte | b.lbyte)
    else
      new shared.OctaByte(@.hbyte, @.lbyte | b)

  and: (b) ->
    if b instanceof shared.OctaByte
      new shared.OctaByte(@.hbyte & b.hbyte, @.lbyte & b.lbyte)
    else
      new shared.OctaByte(@.hbyte, @.lbyte & b)

  xor: (b) ->
    if b instanceof shared.OctaByte
      new shared.OctaByte(@.hbyte ^ b.hbyte, @.lbyte ^ b.lbyte)
    else
      new shared.OctaByte(@.hbyte, @.lbyte ^ b)

  neg: () ->
    new shared.OctaByte(@.hbyte ^ 0xFFFFFFFF, @.lbyte ^ 0xFFFFFFFF)

  cmpu: (b) ->
    if @hbyte > b.hbyte then 1
    else if @hbyte < b.hbyte then -1
    else if @lbyte > b.lbyte then 1
    else if @lbyte < b.lbyte then -1
    else 0
  cmp: (b) ->
    if not @is_neg() and b.is_neg() then 1
    else if @is_neg() and not b.is_neg() then -1
    else if not b.is_neg() and not @is_neg() then @cmpu(b)
    else b.cmpu(@)
  assign: (b) ->
    @hbyte = b.hbyte
    @lbyte = b.lbyte
  toString: () ->
    h = shared.addLeadZero(@getH().toString(16) , 4)
    mh = shared.addLeadZero(@getMH().toString(16) , 4)
    ml = shared.addLeadZero(@getML().toString(16) , 4)
    l = shared.addLeadZero(@getL().toString(16) , 4)
    return h + mh + ml + l
