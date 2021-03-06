DEBUG = true

shared = window

class shared.Registers
  constructor: (num) ->
    @data = new Uint32Array(num * 2)
    @events = {}
  size: () ->
    @data.length / 2
  addEventListener: (eventName, f) ->
    if not @events[eventName]?
      @events[eventName] = new Array()
    @events[eventName].push(f)
  trigger: (eventName, data) ->
    if @events[eventName]?
      for f in @events[eventName]
        f.call(this, data)
  setOcta: (i, val) ->
    throw "val should be an instance of OctaByte" if DEBUG and not (val instanceof shared.OctaByte)
    hi = i * 2
    @data[hi] = val.hbyte
    @data[hi + 1] = val.lbyte
    oldval = new OctaByte(@data[hi], @data[hi + 1])
    @trigger 'set',
      val: val
      i: i
    return val
  getOcta: (i) ->
    hi = i * 2
    val = new OctaByte(@data[hi], @data[hi + 1])
    @trigger 'get',
      val: val
      i: i
    return val

class shared.MMIXProcessor
  OCTYPES:
    Rw: new Object()  # read-write Register and positive Wyde
    ra: new Object()  # readonly Register and wyde with Address
    rA: new Object()  # readonly Register and wyde with negative Address
    rh: new Object()  # readonly Register and Hexabyte with address
    rH: new Object()  # readonly Register and Hexabyte with negative address
    rrr: new Object() # three readonly Registers
    rrb: new Object() # two readonly Registers and Byte
    Rrr: new Object() # read-write Register and two readonly Registers
    Rrb: new Object() # read-write Register, then readonly Register and byte
    bbb: new Object() # three Bytes
    Ror: new Object() # read-write Register, then rOunding setting and readonly Register
    Rob: new Object() # read-write Register, then rOunding setting and byte
    Rbr: new Object() # read-write Register, then Byte and readonly Register
    Rbb: new Object() # read-write Register and two Bytes
    brr: new Object() # write constant octabye
    brb: new Object() # write constant octabye (immediate)

  addcomc: 0

  r:
    curEx: 0
    break: 0
    rE: 0.00001

  run: () ->
    @r.curEx = 0
    @r.break = 0
    while @r.break isnt 1
      oldCurEx = @r.curEx
      @execute(@mem.getTetra(@r.curEx))
      if @r.curEx is oldCurEx
        @r.curEx += 4


  constructor: (memory, registers) ->
    @mem = memory
    @regs = registers
    @coms = new Array(256) # commands
    @comstypes = new Array(256)
    @comsnames = new Array(256)

    mmixcoms = new shared.MMIXCommands(@mem, @regs, @)

    octypes = @OCTYPES

    @addcom(0x00, "trap",   octypes.bbb, mmixcoms.trap)
    @addcom(0x01, "fcmp",   octypes.Rrr, mmixcoms.fcmp)
    @addcom(0x02, "fun",    octypes.Rrr, mmixcoms.fun)
    @addcom(0x03, "feql",   octypes.Rrr, mmixcoms.feql)

    @addcom(0x04, "fadd",   octypes.Rrr, mmixcoms.fadd)
    @addcom(0x05, "fix",    octypes.Ror, mmixcoms.fix)
    @addcom(0x06, "fsub",   octypes.Rrr, mmixcoms.fsub)
    @addcom(0x07, "fixu",   octypes.Ror, mmixcoms.fixu)

    @addcom(0x08, "flot",   octypes.Ror, mmixcoms.flot)
    @addcom(0x09, "flot",   octypes.Rob, mmixcoms.flot)
    @addcom(0x0a, "flotu",  octypes.Ror, mmixcoms.flotu)
    @addcom(0x0b, "flotu",  octypes.Rob, mmixcoms.flotu)

    @addcom(0x0c, "sflot",  octypes.Ror, mmixcoms.sflot)
    @addcom(0x0d, "sflot",  octypes.Rob, mmixcoms.sflot)
    @addcom(0x0e, "sflotu", octypes.Ror, mmixcoms.sflotu)
    @addcom(0x0f, "sflotu", octypes.Rob, mmixcoms.sflotu)

    @addcom(0x10, "fmul",   octypes.Rrr, mmixcoms.fmul)
    @addcom(0x11, "fcmpe",  octypes.Rrr, mmixcoms.fcmpe)
    @addcom(0x12, "fune",   octypes.Rrr, mmixcoms.fune)
    @addcom(0x13, "feqle",  octypes.Rrr, mmixcoms.feqle)

    @addcom(0x14, "fdiv",   octypes.Rrr, mmixcoms.fdiv)
    @addcom(0x15, "fsqrt",  octypes.Ror, mmixcoms.fsqrt)
    @addcom(0x16, "frem",   octypes.Rrr, mmixcoms.frem)
    @addcom(0x17, "fint",   octypes.Ror, mmixcoms.fint)

    @addcom(0x18, "mul",    octypes.Rrr, mmixcoms.mul)
    @addcom(0x19, "mul",    octypes.Rrb, mmixcoms.mul)
    @addcom(0x1a, "mulu",   octypes.Rrr, mmixcoms.mulu)
    @addcom(0x1b, "mulu",   octypes.Rrb, mmixcoms.mulu)

    @addcom(0x20, "add",    octypes.Rrr, mmixcoms.add)
    @addcom(0x21, "add",    octypes.Rrb, mmixcoms.add)
    @addcom(0x22, "addu",   octypes.Rrr, mmixcoms.add)
    @addcom(0x23, "addu",   octypes.Rrb, mmixcoms.add)

    @addcom(0x24, "sub",    octypes.Rrr, mmixcoms.sub)
    @addcom(0x25, "sub",    octypes.Rrb, mmixcoms.sub)
    @addcom(0x26, "subu",   octypes.Rrr, mmixcoms.sub)
    @addcom(0x27, "subu",   octypes.Rrb, mmixcoms.sub)

    @addcom(0x30, "cmp",    octypes.Rrr, mmixcoms.cmp)
    @addcom(0x31, "cmp",    octypes.Rrb, mmixcoms.cmp)
    @addcom(0x32, "cmpu",   octypes.Rrr, mmixcoms.cmpu)
    @addcom(0x33, "cmpu",   octypes.Rrb, mmixcoms.cmpu)

    @addcom(0x34, "neg",    octypes.Rbr, mmixcoms.neg)
    @addcom(0x35, "neg",    octypes.Rbb, mmixcoms.neg)
    @addcom(0x36, "negu",   octypes.Rbr, mmixcoms.negu)
    @addcom(0x37, "negu",   octypes.Rbb, mmixcoms.negu)

    @addcom(0x40, "bn",     octypes.ra,  mmixcoms.bn)
    @addcom(0x41, "bn",     octypes.rA,  mmixcoms.bn)
    @addcom(0x42, "bz",     octypes.ra,  mmixcoms.bz)
    @addcom(0x43, "bz",     octypes.rA,  mmixcoms.bz)

    @addcom(0x44, "bp",     octypes.ra,  mmixcoms.bp)
    @addcom(0x45, "bp",     octypes.rA,  mmixcoms.bp)
    @addcom(0x46, "bod",    octypes.ra,  mmixcoms.bod)
    @addcom(0x47, "bod",    octypes.rA,  mmixcoms.bod)

    @addcom(0x48, "bnn",    octypes.ra,  mmixcoms.bnn)
    @addcom(0x49, "bnn",    octypes.rA,  mmixcoms.bnn)
    @addcom(0x4A, "bnz",    octypes.ra,  mmixcoms.bnz)
    @addcom(0x4B, "bnz",    octypes.rA,  mmixcoms.bnz)

    @addcom(0x4C, "bnp",    octypes.ra,  mmixcoms.bnp)
    @addcom(0x4D, "bnp",    octypes.rA,  mmixcoms.bnp)
    @addcom(0x4E, "bev",    octypes.ra,  mmixcoms.bev)
    @addcom(0x4F, "bev",    octypes.rA,  mmixcoms.bev)

    @addcom(0x50, "pbn",     octypes.ra,  mmixcoms.bn)
    @addcom(0x51, "pbn",     octypes.rA,  mmixcoms.bn)
    @addcom(0x52, "pbz",     octypes.ra,  mmixcoms.bz)
    @addcom(0x53, "pbz",     octypes.rA,  mmixcoms.bz)

    @addcom(0x54, "pbp",     octypes.ra,  mmixcoms.bp)
    @addcom(0x55, "pbp",     octypes.rA,  mmixcoms.bp)
    @addcom(0x56, "pbod",    octypes.ra,  mmixcoms.bod)
    @addcom(0x57, "pbod",    octypes.rA,  mmixcoms.bod)

    @addcom(0x58, "pbnn",    octypes.ra,  mmixcoms.bnn)
    @addcom(0x59, "pbnn",    octypes.rA,  mmixcoms.bnn)
    @addcom(0x5A, "pbnz",    octypes.ra,  mmixcoms.bnz)
    @addcom(0x5B, "pbnz",    octypes.rA,  mmixcoms.bnz)

    @addcom(0x5C, "pbnp",    octypes.ra,  mmixcoms.bnp)
    @addcom(0x5D, "pbnp",    octypes.rA,  mmixcoms.bnp)
    @addcom(0x5E, "pbev",    octypes.ra,  mmixcoms.bev)
    @addcom(0x5F, "pbev",    octypes.rA,  mmixcoms.bev)

    @addcom(0x60, "csn",     octypes.Rrr, mmixcoms.csn)
    @addcom(0x61, "csn",     octypes.Rrb, mmixcoms.csn)
    @addcom(0x62, "csz",     octypes.Rrr, mmixcoms.csz)
    @addcom(0x63, "csz",     octypes.Rrb, mmixcoms.csz)

    @addcom(0x64, "csp",     octypes.Rrr, mmixcoms.csp)
    @addcom(0x65, "csp",     octypes.Rrb, mmixcoms.csp)
    @addcom(0x66, "csod",    octypes.Rrr, mmixcoms.csod)
    @addcom(0x67, "csod",    octypes.Rrb, mmixcoms.csod)

    @addcom(0x68, "csnn",    octypes.Rrr, mmixcoms.csnn)
    @addcom(0x69, "csnn",    octypes.Rrb, mmixcoms.csnn)
    @addcom(0x6A, "csnz",    octypes.Rrr, mmixcoms.csnz)
    @addcom(0x6B, "csnz",    octypes.Rrb, mmixcoms.csnz)

    @addcom(0x6C, "csnp",    octypes.Rrr, mmixcoms.csnp)
    @addcom(0x6D, "csnp",    octypes.Rrb, mmixcoms.csnp)
    @addcom(0x6E, "csev",    octypes.Rrr, mmixcoms.csev)
    @addcom(0x6F, "csev",    octypes.Rrb, mmixcoms.csev)

    @addcom(0x70, "zsn",     octypes.Rrr, mmixcoms.zsn)
    @addcom(0x71, "zsn",     octypes.Rrb, mmixcoms.zsn)
    @addcom(0x72, "zsz",     octypes.Rrr, mmixcoms.zsz)
    @addcom(0x73, "zsz",     octypes.Rrb, mmixcoms.zsz)

    @addcom(0x74, "zsp",     octypes.Rrr, mmixcoms.zsp)
    @addcom(0x75, "zsp",     octypes.Rrb, mmixcoms.zsp)
    @addcom(0x76, "zsod",    octypes.Rrr, mmixcoms.zsod)
    @addcom(0x77, "zsod",    octypes.Rrb, mmixcoms.zsod)

    @addcom(0x78, "zsnn",    octypes.Rrr, mmixcoms.zsnn)
    @addcom(0x79, "zsnn",    octypes.Rrb, mmixcoms.zsnn)
    @addcom(0x7A, "zsnz",    octypes.Rrr, mmixcoms.zsnz)
    @addcom(0x7B, "zsnz",    octypes.Rrb, mmixcoms.zsnz)

    @addcom(0x7C, "zsnp",    octypes.Rrr, mmixcoms.zsnp)
    @addcom(0x7D, "zsnp",    octypes.Rrb, mmixcoms.zsnp)
    @addcom(0x7E, "zsev",    octypes.Rrr, mmixcoms.zsev)
    @addcom(0x7F, "zsev",    octypes.Rrb, mmixcoms.zsev)

    @addcom(0x80, "ldb",    octypes.Rrr, mmixcoms.ldb)
    @addcom(0x81, "ldb",    octypes.Rrb, mmixcoms.ldb)
    @addcom(0x82, "ldbu",   octypes.Rrr, mmixcoms.ldbu)
    @addcom(0x83, "ldbu",   octypes.Rrb, mmixcoms.ldbu)

    @addcom(0x84, "ldw",    octypes.Rrr, mmixcoms.ldw)
    @addcom(0x85, "ldw",    octypes.Rrb, mmixcoms.ldw)
    @addcom(0x86, "ldwu",   octypes.Rrr, mmixcoms.ldwu)
    @addcom(0x87, "ldwu",   octypes.Rrb, mmixcoms.ldwu)

    @addcom(0x88, "ldt",    octypes.Rrr, mmixcoms.ldt)
    @addcom(0x89, "ldt",    octypes.Rrb, mmixcoms.ldt)
    @addcom(0x8A, "ldtu",   octypes.Rrr, mmixcoms.ldtu)
    @addcom(0x8B, "ldtu",   octypes.Rrb, mmixcoms.ldtu)

    @addcom(0x8C, "ldo",    octypes.Rrr, mmixcoms.ldou)
    @addcom(0x8D, "ldo",    octypes.Rrb, mmixcoms.ldou)
    @addcom(0x8E, "ldou",   octypes.Rrr, mmixcoms.ldou)
    @addcom(0x8F, "ldou",   octypes.Rrb, mmixcoms.ldou)

    @addcom(0xA0, "stb",    octypes.rrr, mmixcoms.stb)
    @addcom(0xA1, "stb",    octypes.rrb, mmixcoms.stb)
    @addcom(0xA2, "stbu",   octypes.rrr, mmixcoms.stbu)
    @addcom(0xA3, "stbu",   octypes.rrb, mmixcoms.stbu)

    @addcom(0xA4, "stw",    octypes.rrr, mmixcoms.stw)
    @addcom(0xA5, "stw",    octypes.rrb, mmixcoms.stw)
    @addcom(0xA6, "stwu",   octypes.rrr, mmixcoms.stwu)
    @addcom(0xA7, "stwu",   octypes.rrb, mmixcoms.stwu)

    @addcom(0xA8, "stt",    octypes.rrr, mmixcoms.stt)
    @addcom(0xA9, "stt",    octypes.rrb, mmixcoms.stt)
    @addcom(0xAA, "sttu",   octypes.rrr, mmixcoms.sttu)
    @addcom(0xAB, "sttu",   octypes.rrb, mmixcoms.sttu)

    @addcom(0xAC, "sto",    octypes.rrr, mmixcoms.stou)
    @addcom(0xAD, "sto",    octypes.rrb, mmixcoms.stou)
    @addcom(0xAE, "stou",   octypes.rrr, mmixcoms.stou)
    @addcom(0xAF, "stou",   octypes.rrb, mmixcoms.stou)

    #@addcom(0xB0, "stsf",   octypes.rrr, mmixcoms.stsf)
    #@addcom(0xB1, "stsf",   octypes.rrb, mmixcoms.stsf)
    @addcom(0xB2, "stht",   octypes.rrr, mmixcoms.stht)
    @addcom(0xB3, "stht",   octypes.rrb, mmixcoms.stht)

    @addcom(0xB4, "stco",   octypes.brr, mmixcoms.stco)
    @addcom(0xB5, "stco",   octypes.brb, mmixcoms.stco)
    @addcom(0xB6, "stunc",  octypes.rrr, mmixcoms.stou)
    @addcom(0xB7, "stunc",  octypes.rrb, mmixcoms.stou)

    @addcom(0xC0, "or",     octypes.Rrr, mmixcoms.or)
    @addcom(0xC1, "or",     octypes.Rrb, mmixcoms.or)
    @addcom(0xC2, "orn",    octypes.Rrr, mmixcoms.orn)
    @addcom(0xC3, "orn",    octypes.Rrb, mmixcoms.orn)

    @addcom(0xC4, "nor",    octypes.Rrr, mmixcoms.nor)
    @addcom(0xC5, "nor",    octypes.Rrb, mmixcoms.nor)
    @addcom(0xC6, "xor",    octypes.Rrr, mmixcoms.xor)
    @addcom(0xC7, "xor",    octypes.Rrb, mmixcoms.xor)

    @addcom(0xC8, "and",    octypes.Rrr, mmixcoms.and)
    @addcom(0xC9, "and",    octypes.Rrb, mmixcoms.and)
    @addcom(0xCA, "andn",   octypes.Rrr, mmixcoms.andn)
    @addcom(0xCB, "andn",   octypes.Rrb, mmixcoms.andn)

    @addcom(0xCC, "nand",   octypes.Rrr, mmixcoms.nand)
    @addcom(0xCD, "nand",   octypes.Rrb, mmixcoms.nand)
    @addcom(0xCE, "nxor",   octypes.Rrr, mmixcoms.nxor)
    @addcom(0xCF, "nxor",   octypes.Rrb, mmixcoms.nxor)

    @addcom(0xE0, "seth",   octypes.Rw, mmixcoms.seth)
    @addcom(0xE1, "setmh",  octypes.Rw, mmixcoms.setmh)
    @addcom(0xE2, "setml",  octypes.Rw, mmixcoms.setml)
    @addcom(0xE3, "setl",   octypes.Rw, mmixcoms.setl)

    @addcom(0xE4, "inch",   octypes.Rw, mmixcoms.inch)
    @addcom(0xE5, "incmh",  octypes.Rw, mmixcoms.incmh)
    @addcom(0xE6, "incml",  octypes.Rw, mmixcoms.incml)
    @addcom(0xE7, "incl",   octypes.Rw, mmixcoms.incl)

    @addcom(0xE8, "orh",    octypes.Rw, mmixcoms.orh)
    @addcom(0xE9, "ormh",   octypes.Rw, mmixcoms.ormh)
    @addcom(0xEA, "orml",   octypes.Rw, mmixcoms.orml)
    @addcom(0xEB, "orl",    octypes.Rw, mmixcoms.orl)

    @addcom(0xEC, "andh",   octypes.Rw, mmixcoms.andh)
    @addcom(0xED, "andmh",  octypes.Rw, mmixcoms.andmh)
    @addcom(0xEE, "andml",  octypes.Rw, mmixcoms.andml)
    @addcom(0xEF, "andl",   octypes.Rw, mmixcoms.andl)

    @addcom(0xF0, "jmp",    octypes.rh, mmixcoms.jmp)
    @addcom(0xEF, "jmp",    octypes.rH, mmixcoms.jmp)



  addcom: (opcode, name, type, f) ->
    @coms[opcode] = f
    @comstypes[opcode] = type
    @comsnames[opcode] = name
    @addcomc++

  disassemble: (command) ->
    opcode = command >>> 24
    octypes = @OCTYPES
    if @comstypes[opcode] is octypes.Rw
      @comsnames[opcode] +
      " $" + shared.addLeadZero((command >>> 16 & 0xFF).toString(16).toUpperCase(),2) +
      " 0x" + shared.addLeadZero((command & 0xFFFF).toString(16).toUpperCase(),4)
    else if @comstypes[opcode] is octypes.ra or @comstypes[opcode] is octypes.rA
      @comsnames[opcode] +
      " $" + shared.addLeadZero((command >>> 16 & 0xFF).toString(16).toUpperCase(),2) +
      (if @comstypes[opcode] is octypes.ra then " @+" else " @-") + "4*0x" +
      shared.addLeadZero((command & 0xFFFF).toString(16).toUpperCase(),4)
    else if @comstypes[opcode] is octypes.rh or @comstypes[opcode] is octypes.rH
      @comsnames[opcode] +
      (if @comstypes[opcode] is octypes.rh then " @+" else " @-") + "4*0x" +
      shared.addLeadZero((command >>> 16 & 0xFF).toString(16).toUpperCase(),2) +
      shared.addLeadZero((command >>>  8 & 0xFF).toString(16).toUpperCase(),2) +
      shared.addLeadZero((command >>>  0 & 0xFF).toString(16).toUpperCase(),2)
    else if @comstypes[opcode] is octypes.rrr or @comstypes[opcode] is octypes.Rrr
      @comsnames[opcode] +
      " $" + shared.addLeadZero((command >>> 16 & 0xFF).toString(16).toUpperCase(),2) +
      " $" + shared.addLeadZero((command >>>  8 & 0xFF).toString(16).toUpperCase(),2) +
      " $" + shared.addLeadZero((command >>>  0 & 0xFF).toString(16).toUpperCase(),2)
    else if @comstypes[opcode] is octypes.rrb or @comstypes[opcode] is octypes.Rrb
      @comsnames[opcode] +
      " $" + shared.addLeadZero((command >>> 16 & 0xFF).toString(16).toUpperCase(),2) +
      " $" + shared.addLeadZero((command >>>  8 & 0xFF).toString(16).toUpperCase(),2) +
      " 0x" + shared.addLeadZero((command >>>  0 & 0xFF).toString(16).toUpperCase(),2)
    else if @comstypes[opcode] is octypes.bbb
      @comsnames[opcode] +
      " 0x" + shared.addLeadZero((command >>> 16 & 0xFF).toString(16).toUpperCase(),2) +
      " 0x" + shared.addLeadZero((command >>>  8 & 0xFF).toString(16).toUpperCase(),2) +
      " 0x" + shared.addLeadZero((command >>>  0 & 0xFF).toString(16).toUpperCase(),2)
    else if @comstypes[opcode] is octypes.Rob
      @comsnames[opcode] +
      " $" + shared.addLeadZero((command >>> 16 & 0xFF).toString(16).toUpperCase(),2) +
      (
        switch ((command >>>  8 & 0xFF))
          when 0 then ""
          when 1 then " ROUND_OFF"
          when 2 then " ROUND_UP"
          when 3 then " ROUND_DOWN"
          when 4 then " ROUND_NEAR"
          else " __WRONG__"
      ) + " 0x" + shared.addLeadZero((command >>>  0 & 0xFF).toString(16).toUpperCase(),2)
    else if @comstypes[opcode] is octypes.Ror
      @comsnames[opcode] +
      " $" + shared.addLeadZero((command >>> 16 & 0xFF).toString(16).toUpperCase(),2) +
      (
        switch ((command >>>  8 & 0xFF))
          when 0 then ""
          when 1 then " ROUND_OFF"
          when 2 then " ROUND_UP"
          when 3 then " ROUND_DOWN"
          when 4 then " ROUND_NEAR"
          else " __WRONG__"
      ) + " $" + shared.addLeadZero((command >>>  0 & 0xFF).toString(16).toUpperCase(),2)
    else if @comstypes[opcode] is octypes.Rbb
      @comsnames[opcode] +
      " $" + shared.addLeadZero((command >>> 16 & 0xFF).toString(16).toUpperCase(),2) +
      " 0x" + shared.addLeadZero((command >>>  8 & 0xFF).toString(16).toUpperCase(),2) +
      " 0x" + shared.addLeadZero((command >>>  0 & 0xFF).toString(16).toUpperCase(),2)
    else if @comstypes[opcode] is octypes.Rbr
      @comsnames[opcode] +
      " $" + shared.addLeadZero((command >>> 16 & 0xFF).toString(16).toUpperCase(),2) +
      " 0x" + shared.addLeadZero((command >>>  8 & 0xFF).toString(16).toUpperCase(),2) +
      " $" + shared.addLeadZero((command >>>  0 & 0xFF).toString(16).toUpperCase(),2)
    else if @comstypes[opcode] is octypes.brr
      @comsnames[opcode] +
      " 0x" + shared.addLeadZero((command >>> 16 & 0xFF).toString(16).toUpperCase(),2) +
      " $" + shared.addLeadZero((command >>>  8 & 0xFF).toString(16).toUpperCase(),2) +
      " $" + shared.addLeadZero((command >>>  0 & 0xFF).toString(16).toUpperCase(),2)
    else if @comstypes[opcode] is octypes.brb
      @comsnames[opcode] +
      " 0x" + shared.addLeadZero((command >>> 16 & 0xFF).toString(16).toUpperCase(),2) +
      " $" + shared.addLeadZero((command >>>  8 & 0xFF).toString(16).toUpperCase(),2) +
      " 0x" + shared.addLeadZero((command >>>  0 & 0xFF).toString(16).toUpperCase(),2)
    else
      "not implemented yet " + shared.addLeadZero(opcode.toString(16).toUpperCase(),2)

  execute: (command) ->
    opcode = command >>> 24
    octypes = @OCTYPES
    if @comstypes[opcode] is octypes.Rw
      $X_i = (command >>> 16) & 0xFF
      $X = @regs.getOcta($X_i)
      w = command & 0xFFFF
      @coms[opcode]($X, w)
      @regs.setOcta($X_i, $X)
    else if @comstypes[opcode] is octypes.ra or @comstypes[opcode] is octypes.rA
      $X_i = (command >>> 16) & 0xFF
      $X = @regs.getOcta($X_i)
      w = command & 0xFFFF
      if @comstypes[opcode] is octypes.rA
        w = -w;
      @coms[opcode]($X, w)
    else if @comstypes[opcode] is octypes.rh or @comstypes[opcode] is octypes.rH
      h = command & 0xFFFFFF
      if @comstypes[opcode] is octypes.rH
        h = -h;
      @coms[opcode](h)
    else if @comstypes[opcode] is octypes.rrr or @comstypes[opcode] is octypes.Rrr
      $X_i = (command >>> 16) & 0xFF
      $Y_i = (command >>>  8) & 0xFF
      $Z_i = (command >>>  0) & 0xFF
      $X = @regs.getOcta($X_i)
      $Y = @regs.getOcta($Y_i)
      $Z = @regs.getOcta($Z_i)
      @coms[opcode]($X, $Y, $Z)
      if @comstypes[opcode] is octypes.Rrr
        @regs.setOcta($X_i, $X)
    else if @comstypes[opcode] is octypes.rrb or @comstypes[opcode] is octypes.Rrb
      $X_i = (command >>> 16) & 0xFF
      $Y_i = (command >>>  8) & 0xFF
      Z    = (command >>>  0) & 0xFF
      $X = @regs.getOcta($X_i)
      $Y = @regs.getOcta($Y_i)
      @coms[opcode]($X, $Y, Z)
      if @comstypes[opcode] is octypes.Rrb
        @regs.setOcta($X_i, $X)
    else if @comstypes[opcode] is octypes.bbb
      X = (command >>> 16) & 0xFF
      Y = (command >>>  8) & 0xFF
      Z = (command >>>  0) & 0xFF
      @coms[opcode](X, Y, Z)
    else if @comstypes[opcode] is octypes.Ror
      $X_i = (command >>> 16) & 0xFF
      Y = (command >>>  8) & 0xFF
      $Z_i  = (command >>>  0) & 0xFF
      $X = @regs.getOcta($X_i)
      $Z = @regs.getOcta($Z_i)
      @coms[opcode]($X, Y, $Z)
      @regs.setOcta($X_i, $X)
    else if @comstypes[opcode] is octypes.Rob
      $X_i = (command >>> 16) & 0xFF
      Y = (command >>>  8) & 0xFF
      Z  = (command >>>  0) & 0xFF
      $X = @regs.getOcta($X_i)
      @coms[opcode]($X, Y, Z)
      @regs.setOcta($X_i, $X)
    else if @comstypes[opcode] is octypes.Rbr
      $X_i = (command >>> 16) & 0xFF
      Y = (command >>>  8) & 0xFF
      $Z_i = (command >>>  0) & 0xFF
      $X = @regs.getOcta($X_i)
      $Z = @regs.getOcta($Z_i)
      @coms[opcode]($X, Y, $Z)
      @regs.setOcta($X_i, $X)
    else if @comstypes[opcode] is octypes.Rbb
      $X_i = (command >>> 16) & 0xFF
      Y = (command >>>  8) & 0xFF
      Z = (command >>>  0) & 0xFF
      $X = @regs.getOcta($X_i)
      @coms[opcode]($X, Y, Z)
      @regs.setOcta($X_i, $X)
    else if @comstypes[opcode] is octypes.brr
      X = (command >>> 16) & 0xFF
      $Y_i = (command >>>  8) & 0xFF
      $Z_i = (command >>>  0) & 0xFF
      $Y = @regs.getOcta($Y_i)
      $Z = @regs.getOcta($Z_i)
      @coms[opcode](X, $Y, $Z)
    else if @comstypes[opcode] is octypes.brb
      X = (command >>> 16) & 0xFF
      $Y_i = (command >>>  8) & 0xFF
      Z = (command >>>  0) & 0xFF
      $Y = @regs.getOcta($Y_i)
      @coms[opcode](X, $Y, Z)
    else
      throw "not implemented"





