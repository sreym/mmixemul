// Generated by CoffeeScript 1.6.2
(function() {
  var shared;

  shared = window;

  test("getOcta, getTetra, getWyde, getByte", function() {
    var i, iStartAddr, mem, _i, _j, _k, _l, _m, _n, _o;

    mem = new shared.Memory(1024);
    iStartAddr = 16;
    mem.setOcta(iStartAddr, new shared.OctaByte(0x01234567, 0x89abcdef));
    for (i = _i = 0; _i < 8; i = ++_i) {
      equal(mem.getOcta(iStartAddr + i).toString().toLowerCase(), "0123456789ABCDEF".toLowerCase(), "getOcta [" + iStartAddr + " + " + i + "]");
    }
    equal(mem.getOcta(iStartAddr + 8).toString().toLowerCase(), "0000000000000000".toLowerCase(), "getOcta [" + (iStartAddr + 8) + " + 0]");
    for (i = _j = 0; _j < 4; i = ++_j) {
      equal(mem.getTetra(iStartAddr + i), 0x01234567, "getTetra [" + iStartAddr + " + " + i + "]");
    }
    for (i = _k = 0; _k < 4; i = ++_k) {
      equal(mem.getTetra(iStartAddr + 4 + i), 0x89abcdef, "getTetra [" + (iStartAddr + 4) + " + " + i + "]");
    }
    equal(mem.getTetra(iStartAddr + 8), 0, "getTetra [" + (iStartAddr + 8) + " + 0]");
    for (i = _l = 0; _l < 2; i = ++_l) {
      equal(mem.getWyde(iStartAddr + i), 0x0123, "getWyde [" + iStartAddr + " + " + i + "]");
    }
    for (i = _m = 0; _m < 2; i = ++_m) {
      equal(mem.getWyde(iStartAddr + 2 + i), 0x4567, "getWyde [" + (iStartAddr + 2) + " + " + i + "]");
    }
    for (i = _n = 0; _n < 2; i = ++_n) {
      equal(mem.getWyde(iStartAddr + 4 + i), 0x89ab, "getWyde [" + (iStartAddr + 4) + " + " + i + "]");
    }
    for (i = _o = 0; _o < 2; i = ++_o) {
      equal(mem.getWyde(iStartAddr + 6 + i), 0xcdef, "getWyde [" + (iStartAddr + 6) + " + " + i + "]");
    }
    equal(mem.getWyde(iStartAddr + 8), 0, "getWyde [" + (iStartAddr + 8) + " + 0]");
    equal(mem.getByte(iStartAddr + 0), 0x01, "getByte [" + iStartAddr + " + 0]");
    equal(mem.getByte(iStartAddr + 1), 0x23, "getByte [" + iStartAddr + " + 1]");
    equal(mem.getByte(iStartAddr + 2), 0x45, "getByte [" + iStartAddr + " + 2]");
    equal(mem.getByte(iStartAddr + 3), 0x67, "getByte [" + iStartAddr + " + 3]");
    equal(mem.getByte(iStartAddr + 4), 0x89, "getByte [" + iStartAddr + " + 4]");
    equal(mem.getByte(iStartAddr + 5), 0xab, "getByte [" + iStartAddr + " + 5]");
    equal(mem.getByte(iStartAddr + 6), 0xcd, "getByte [" + iStartAddr + " + 6]");
    equal(mem.getByte(iStartAddr + 7), 0xef, "getByte [" + iStartAddr + " + 7]");
    return equal(mem.getByte(iStartAddr + 8), 0x00, "getByte [" + (iStartAddr + 8) + " + 0]");
  });

  test("setOcta, setTetra, setWyde, setByte", function() {
    var i, iStartAddr, mem, _i, _j, _k, _l, _results;

    mem = new shared.Memory(1024);
    iStartAddr = 16;
    for (i = _i = 0; _i < 8; i = ++_i) {
      mem.setOcta(iStartAddr + i, new shared.OctaByte(0x01234567, 0x89abcdef));
      equal(mem.getOcta(iStartAddr + i).toString().toLowerCase(), "0123456789ABCDEF".toLowerCase(), "setOcta [" + iStartAddr + " + " + i + "]");
    }
    for (i = _j = 0; _j < 4; i = ++_j) {
      mem.setTetra(iStartAddr + i, 0xabcdef98 + i);
      equal(mem.getTetra(iStartAddr + i).toString(16).toLowerCase(), (0xabcdef98 + i).toString(16).toLowerCase(), "setTetra [" + iStartAddr + " + " + i + "]");
    }
    for (i = _k = 0; _k < 4; i = ++_k) {
      mem.setWyde(iStartAddr + i, 0xbc56 + i);
      equal(mem.getWyde(iStartAddr + i).toString(16).toLowerCase(), (0xbc56 + i).toString(16).toLowerCase(), "setWyde [" + iStartAddr + " + " + i + "]");
    }
    _results = [];
    for (i = _l = 0; _l < 4; i = ++_l) {
      mem.setByte(iStartAddr + i, 0xcd + i);
      _results.push(equal(mem.getByte(iStartAddr + i).toString(16).toLowerCase(), (0xcd + i).toString(16).toLowerCase(), "setByte [" + iStartAddr + " + " + i + "]"));
    }
    return _results;
  });

  test("ST*, LD*, SET* commands of MMIX machine", function() {
    var mem, proc, regs;

    regs = new shared.Registers(256);
    mem = new shared.Memory(1024);
    proc = new shared.MMIXProcessor(mem, regs);
    proc.regs.setOcta(5, new shared.OctaByte(0xFFFFFFFF, 0xFFFFFFFF));
    proc.execute(0xE0050123);
    equal(proc.regs.getOcta(5).toString().toLowerCase(), "0123000000000000".toLowerCase(), "seth");
    proc.execute(0xE1054567);
    equal(proc.regs.getOcta(5).toString().toLowerCase(), "0000456700000000".toLowerCase(), "setmh");
    proc.execute(0xE20589AB);
    equal(proc.regs.getOcta(5).toString().toLowerCase(), "0000000089ab0000".toLowerCase(), "setml");
    proc.execute(0xE305CDEF);
    equal(proc.regs.getOcta(5).toString().toLowerCase(), "000000000000cdef".toLowerCase(), "setl");
    proc.regs.setOcta(5, new shared.OctaByte(0x01234567, 0x89abcdef));
    proc.execute(0xE3020001);
    proc.execute(0xE3030002);
    proc.execute(0xAC050203);
    equal(proc.mem.getOcta(5).toString().toLowerCase(), "0123456789ABCDEF".toLowerCase(), "stou");
    proc.execute(0x8F010203);
    return equal(proc.regs.getOcta(1).toString().toLowerCase(), "0123456789ABCDEF".toLowerCase(), "ldoui");
  });

}).call(this);

/*
//@ sourceMappingURL=st_ld_set.map
*/