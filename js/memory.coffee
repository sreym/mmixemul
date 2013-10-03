DEBUG = true

shared = window

class shared.Memory
  # size in  (should be dividable for 4)
  constructor: (size) ->
    @data = new Uint32Array(size / 4)
    @events = {}
  size: () ->
    @data.length * 4
  addEventListener: (eventName, f) ->
    if not @events[eventName]?
      @events[eventName] = new Array()
    @events[eventName].push(f)
  trigger: (eventName, data) ->
    if @events[eventName]?
      for f in @events[eventName]
        f.call(this, data)
  # byte-wyde-tetra-octa setters
  setByte: (i, val) ->
    throw "val should be type of number" if DEBUG and typeof val isnt "number"
    val = val & 0xFF
    hi = i / 4 | 0
    li = 3 - (i % 4)
    shift = 8 * li | 0
    oldval = @data[hi]
    @data[hi] = (oldval & ~(0xFF << shift)) ^ ((val & 0xFF) << shift)
    @trigger 'set',
      i : i
      size: 1
      val: val
    return val & 0xFF
  setWyde: (i, val) ->
    throw "val should be type of number" if DEBUG and typeof val isnt "number"
    val = val & 0xFFFF
    hi = i / 4 | 0
    li = (i >>> 1) & 1
    oldval = @data[hi]
    shift = 16 * (1 - li)
    @data[hi] = (oldval & ~(0xFFFF << shift)) ^ ((val & 0xFFFF) << shift)
    @trigger 'set',
      i : i & ~0x1
      size: 2
      val: val
    return val & 0xFFFF
  setTetra: (i, val) ->
    throw "val should be type of number" if DEBUG and typeof val isnt "number"
    hi = i / 4 | 0
    oldval = @data[hi]
    @data[hi] = val
    @trigger 'set',
      i : i & ~0x3
      size: 4
      val: val
    return val
  setOcta: (i, val) ->
    throw "val should be instance of OctaByte" if DEBUG and not (val instanceof shared.OctaByte)
    hi = (i / 8 | 0) * 2
    @data[hi] = val.hbyte
    @data[hi + 1] = val.lbyte
    oldval = new OctaByte(@data[hi], @data[hi + 1])
    @trigger 'set',
      i : i & ~0x7
      size: 8
      val: val
    return val

  # byte-wyde-tetra-octa getters
  getByte: (i) ->
    hi = i / 4 | 0
    li = 3 - (i % 4)
    shift = 8 * li | 0
    val = (@data[hi] >>> shift) & 0xFF
    @trigger 'get',
      hi: hi
      li: li
      val: val
      size: 1
      i: i
    return val
  getWyde: (i) ->
    hi = i / 4 | 0
    li = (i >>> 1) & 1
    shift = 16 * (1 - li)
    val = (@data[hi] >>> shift) & 0xFFFF
    @trigger 'get',
      hi: hi
      li: li
      val: val
      size: 2
      i: i
    return val
  getTetra: (i) ->
    hi = i / 4 | 0
    @trigger 'get',
      hi: hi
      li: 0
      size: 4
      i: i
    return @data[hi]
  getOcta: (i) ->
    hi = (i / 8 | 0) * 2
    val = new OctaByte(@data[hi], @data[hi + 1])
    @trigger 'get',
      hi: hi
      li: hi + 1
      val: val
      size: 8
      i: i
    return val






