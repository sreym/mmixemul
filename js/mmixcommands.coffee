DEBUG = true

shared = window

class shared.MMIXCommands
  constructor: (memory, registers, processor) ->
    @mem = memory
    @regs = registers
    @processor = processor

  # 00 - 0F
  trap: (X, Y, Z) =>
    if X is Y is Z is 0
      @processor.r.break = 1

  fcmp: ($X, $Y, $Z) =>


  fun:  (X, Y, Z) =>

  feql: (X, Y, Z) =>

  fadd: ($X, $Y, $Z) =>
    $X.setDouble($Y.getDouble() + $Z.getDouble())

  fix:  (X, Y, Z) =>

  fsub: (X, Y, Z) =>
    $X.setDouble($Y.getDouble() - $Z.getDouble())

  fixu: (X, Y, Z) =>

  flot: (X, Y, Z) =>

  flotu: (X, Y, Z) =>

  sflot: (X, Y, Z) =>

  sflotu: (X, Y, Z) =>

  fmul: (X, Y, Z) =>
    $X.setDouble($Y.getDouble() * $Z.getDouble())

  fcmpe: (X, Y, Z) =>

  fune: (X, Y, Z) =>

  feqle: (X, Y, Z) =>

  fdiv: (X, Y, Z) =>
    $X.setDouble($Y.getDouble() / $Z.getDouble())


  fsqrt: (X, Y, Z) =>

  frem: (X, Y, Z) =>

  fint: (X, Y, Z) =>

  # 18 - 1F
  mulu: ($X, $Y_val, $Z_val, exc = null) =>
    if not $Z instanceof shared.OctaByte
      $Z = new shared.OctaByte(0, $Z_val)
    else
      $Z = new shared.OctaByte(0,0)
      $Z.assign($Z_val)
    $Y = new shared.OctaByte(0,0)
    $Y.assign($Y_val)

    x = [0, 0, 0, 0, 0, 0, 0, 0]
    y = new Uint32Array(4)
    z = new Uint32Array(4)


    y[0] = $Y.lbyte & 0xFFFF
    y[1] = ($Y.lbyte & 0xFFFF0000) >>> 16
    y[2] = $Y.hbyte & 0xFFFF
    y[3] = ($Y.hbyte & 0xFFFF0000) >>> 16

    z[0] = $Z.lbyte & 0xFFFF
    z[1] = ($Z.lbyte & 0xFFFF0000) >>> 16
    z[2] = $Z.hbyte & 0xFFFF
    z[3] = ($Z.hbyte & 0xFFFF0000) >>> 16

    for i in [0...4]
      for j in [0...4]
        x[i + j] = x[i + j] + y[i] * z[j]

    for i in [0...8]
      if x[i] > 0xFFFF
        x[i + 1] = x[i + 1] + ((x[i] / (1 << 16)) | 0)
        x[i] = x[i] & 0xFFFF


    $X.lbyte = x[0] ^ (x[1] << 16)
    $X.hbyte = x[2] ^ (x[3] << 16)

    if x[4] > 0 or x[5] > 0 or x[6] > 0 or x[7] > 0
      exc = "overflow"


  mul: ($X, $Y_val, $Z_val, exc = null) =>
    if not $Z instanceof shared.OctaByte
      $Z = new shared.OctaByte(0, $Z_val)
    else
      $Z = new shared.OctaByte(0,0)
      $Z.assign($Z_val)

    $Y = new shared.OctaByte(0,0)
    $Y.assign($Y_val)

    sign = ($Y.is_neg() and $Z.is_neg()) || (not $Y.is_neg() and not $Z.is_neg())
    $Y = $Y.neg().add(1) if $Y.is_neg()
    $Z = $Z.neg().add(1) if $Z.is_neg()

    @mulu($X, $Y, $Z, exc)

    if $X.hbyte > 0x7FFFFFFF
      exc = "overflow"
    $X.hbyte = $X.hbyte & 0x7FFFFFFF
    unless sign
      $X.assign($X.neg().add(1))

  # 20 - 27
  add: ($X, $Y, $Z) =>
    $X.assign($Y.add($Z))
  sub: ($X, $Y, $Z) =>
    $X.assign($Y.sub($Z))

  # 80 - 8F
  ldb: ($X, $Y, $Z) =>
    addr = $Y.add($Z)
    $X.lbyte = @mem.getByte(addr.lbyte)
    if ($X.lbyte >> 7) & 0x1 > 0
      $X.hbyte = 0xFFFFFFFF
      $X.lbyte = $X.lbyte ^ (0xFFFFFF << 8)
    else
      $X.hbyte = 0x0
  ldbu: ($X, $Y, $Z) =>
    addr = $Y.add($Z)
    $X.lbyte = @mem.getByte(addr.lbyte)
    $X.hbyte = 0x0

  ldw: ($X, $Y, $Z) =>
    addr = $Y.add($Z)
    $X.lbyte = @mem.getWyde(addr.lbyte)
    if ($X.lbyte >> 15) & 0x1 > 0
      $X.hbyte = 0xFFFFFFFF
      $X.lbyte = $X.lbyte ^ (0xFFFF << 16)
    else
      $X.hbyte = 0x0
  ldwu: ($X, $Y, $Z) =>
    addr = $Y.add($Z)
    $X.lbyte = @mem.getWyde(addr.lbyte)
    $X.hbyte = 0x0

  ldt: ($X, $Y, $Z) =>
    addr = $Y.add($Z)
    $X.lbyte = @mem.getTetra(addr.lbyte)
    if ($X.lbyte >> 31) & 0x1 > 0
      $X.hbyte = 0xFFFFFFFF
    else
      $X.hbyte = 0x0
  ldtu: ($X, $Y, $Z) =>
    addr = $Y.add($Z)
    $X.lbyte = @mem.getTetra(addr.lbyte)
    $X.hbyte = 0x0

  ldou: ($X, $Y, $Z) =>
    addr = $Y.add($Z)
    $X.assign(@mem.getOcta(addr.lbyte))

  # A0 - AF
  stb: ($X, $Y, $Z) =>
    addr = $Y.add($Z)
    @mem.setByte(addr.lbyte, $X.lbyte & 0xFF)
    if not ((($X.hbyte is 0) and (($X.lbyte >>> 8) is 0)) or ((~$X.hbyte is 0) and ((~$X.lbyte >>> 8) is 0)))
      excOfOverflow = 0
  stbu: ($X, $Y, $Z) =>
    addr = $Y.add($Z)
    @mem.setByte(addr, $X.lbyte & 0xFF)
  stw: ($X, $Y, $Z) =>
    addr = $Y.add($Z)
    @mem.setWyde(addr.lbyte, $X.lbyte & 0xFFFF)
    if not((($X.hbyte is 0) and (($X.lbyte >>> 16) is 0)) or ((~$X.hbyte is 0) and ((~$X.lbyte >>> 16) is 0)))
      excOfOverflow = 0
  stwu: ($X, $Y, $Z) =>
    addr = $Y.add($Z)
    @mem.setWyde(addr.lbyte, $X.lbyte & 0xFFFF)
  stt: ($X, $Y, $Z) =>
    addr = $Y.add($Z)
    @mem.setTetra(addr.lbyte, $X.lbyte & 0xFFFFFFFF)
    if not(($X.hbyte is 0) or (~$X.hbyte is 0))
      excOfOverflow = 0
  sttu: ($X, $Y, $Z) =>
    addr = $Y.add($Z)
    @mem.setTetra(addr.lbyte, $X.lbyte & 0xFFFFFFFF)
  stou: ($X, $Y, $Z) =>
    addr = $Y.add($Z)
    @mem.setOcta(addr.lbyte, $X)

  # C0 - CF
  or : ($X, $Y, $Z) => $X.assign($Y.or($Z))

  orn: ($X, $Y, $Z) => $X.assign($Y.or($Z.neg()))

  nor: ($X, $Y, $Z) => $X.assign($Y.or($Z).neg())

  xor: ($X, $Y, $Z) => $X.assign($Y.xor($Z))

  and: ($X, $Y, $Z) => $X.assign($Y.and($Z))

  andn: ($X, $Y, $Z) => $X.assign($Y.and($Z.neg()))

  nand: ($X, $Y, $Z) => $X.assign($Y.and($Z).neg())

  nxor: ($X, $Y, $Z) => $X.assign($Y.xor($Z).neg())

  # E0 - EF
  seth:  ($X, YZ) ->
    $X.setH(YZ)
    $X.setMH(0x0)
    $X.setML(0x0)
    $X.setL(0x0)
  setmh: ($X, YZ) ->
    $X.setH(0x0)
    $X.setMH(YZ)
    $X.setML(0x0)
    $X.setL(0x0)
  setml: ($X, YZ) ->
    $X.setH(0x0)
    $X.setMH(0x0)
    $X.setML(YZ)
    $X.setL(0x0)
  setl:  ($X, YZ) ->
    $X.setH(0x0)
    $X.setMH(0x0)
    $X.setML(0x0)
    $X.setL(YZ)

  inch:  ($X, YZ) -> $X.setH(($X.getH() + YZ) & 0xFFFF)
  incmh: ($X, YZ) -> $X.setMH(($X.getMH() + YZ) & 0xFFFF)
  incml: ($X, YZ) -> $X.setML(($X.getML() + YZ) & 0xFFFF)
  incl:  ($X, YZ) -> $X.setL(($X.getL() + YZ) & 0xFFFF)

  orh:  ($X, YZ) -> $X.setH($X.getH() | YZ)
  ormh: ($X, YZ) -> $X.setMH($X.getMH() | YZ)
  orml: ($X, YZ) -> $X.setML($X.getML() | YZ)
  orl:  ($X, YZ) -> $X.setL($X.getL() | YZ)

  andh:  ($X, YZ) -> $X.setH($X.getH() & !YZ)
  andmh: ($X, YZ) -> $X.setMH($X.getMH() & !YZ)
  andml: ($X, YZ) -> $X.setML($X.getML() & !YZ)
  andl:  ($X, YZ) -> $X.setL($X.getL() & !YZ)

