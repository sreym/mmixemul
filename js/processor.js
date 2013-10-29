// Generated by CoffeeScript 1.6.3
(function() {
  var DEBUG, shared;

  DEBUG = true;

  shared = window;

  shared.Registers = (function() {
    function Registers(num) {
      this.data = new Uint32Array(num * 2);
      this.events = {};
    }

    Registers.prototype.size = function() {
      return this.data.length / 2;
    };

    Registers.prototype.addEventListener = function(eventName, f) {
      if (this.events[eventName] == null) {
        this.events[eventName] = new Array();
      }
      return this.events[eventName].push(f);
    };

    Registers.prototype.trigger = function(eventName, data) {
      var f, _i, _len, _ref, _results;
      if (this.events[eventName] != null) {
        _ref = this.events[eventName];
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          f = _ref[_i];
          _results.push(f.call(this, data));
        }
        return _results;
      }
    };

    Registers.prototype.setOcta = function(i, val) {
      var hi, oldval;
      if (DEBUG && !(val instanceof shared.OctaByte)) {
        throw "val should be an instance of OctaByte";
      }
      hi = i * 2;
      this.data[hi] = val.hbyte;
      this.data[hi + 1] = val.lbyte;
      oldval = new OctaByte(this.data[hi], this.data[hi + 1]);
      this.trigger('set', {
        val: val,
        i: i
      });
      return val;
    };

    Registers.prototype.getOcta = function(i) {
      var hi, val;
      hi = i * 2;
      val = new OctaByte(this.data[hi], this.data[hi + 1]);
      this.trigger('get', {
        val: val,
        i: i
      });
      return val;
    };

    return Registers;

  })();

  shared.MMIXProcessor = (function() {
    MMIXProcessor.prototype.OCTYPES = {
      Rw: new Object(),
      ra: new Object(),
      rA: new Object(),
      rh: new Object(),
      rH: new Object(),
      rrr: new Object(),
      rrb: new Object(),
      Rrr: new Object(),
      Rrb: new Object(),
      bbb: new Object(),
      Ror: new Object(),
      Rob: new Object(),
      Rbr: new Object(),
      Rbb: new Object()
    };

    MMIXProcessor.prototype.addcomc = 0;

    MMIXProcessor.prototype.r = {
      curEx: 0,
      "break": 0,
      rE: 0.00001
    };

    MMIXProcessor.prototype.run = function() {
      var oldCurEx, _results;
      this.r.curEx = 0;
      this.r["break"] = 0;
      _results = [];
      while (this.r["break"] !== 1) {
        oldCurEx = this.r.curEx;
        this.execute(this.mem.getTetra(this.r.curEx));
        if (this.r.curEx === oldCurEx) {
          _results.push(this.r.curEx += 4);
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    function MMIXProcessor(memory, registers) {
      var mmixcoms, octypes;
      this.mem = memory;
      this.regs = registers;
      this.coms = new Array(256);
      this.comstypes = new Array(256);
      this.comsnames = new Array(256);
      mmixcoms = new shared.MMIXCommands(this.mem, this.regs, this);
      octypes = this.OCTYPES;
      this.addcom(0x00, "trap", octypes.bbb, mmixcoms.trap);
      this.addcom(0x01, "fcmp", octypes.Rrr, mmixcoms.fcmp);
      this.addcom(0x02, "fun", octypes.Rrr, mmixcoms.fun);
      this.addcom(0x03, "feql", octypes.Rrr, mmixcoms.feql);
      this.addcom(0x04, "fadd", octypes.Rrr, mmixcoms.fadd);
      this.addcom(0x05, "fix", octypes.Ror, mmixcoms.fix);
      this.addcom(0x06, "fsub", octypes.Rrr, mmixcoms.fsub);
      this.addcom(0x07, "fixu", octypes.Ror, mmixcoms.fixu);
      this.addcom(0x08, "flot", octypes.Ror, mmixcoms.flot);
      this.addcom(0x09, "flot", octypes.Rob, mmixcoms.flot);
      this.addcom(0x0a, "flotu", octypes.Ror, mmixcoms.flotu);
      this.addcom(0x0b, "flotu", octypes.Rob, mmixcoms.flotu);
      this.addcom(0x0c, "sflot", octypes.Ror, mmixcoms.sflot);
      this.addcom(0x0d, "sflot", octypes.Rob, mmixcoms.sflot);
      this.addcom(0x0e, "sflotu", octypes.Ror, mmixcoms.sflotu);
      this.addcom(0x0f, "sflotu", octypes.Rob, mmixcoms.sflotu);
      this.addcom(0x10, "fmul", octypes.Rrr, mmixcoms.fmul);
      this.addcom(0x11, "fcmpe", octypes.Rrr, mmixcoms.fcmpe);
      this.addcom(0x12, "fune", octypes.Rrr, mmixcoms.fune);
      this.addcom(0x13, "feqle", octypes.Rrr, mmixcoms.feqle);
      this.addcom(0x14, "fdiv", octypes.Rrr, mmixcoms.fdiv);
      this.addcom(0x15, "fsqrt", octypes.Ror, mmixcoms.fsqrt);
      this.addcom(0x16, "frem", octypes.Rrr, mmixcoms.frem);
      this.addcom(0x17, "fint", octypes.Ror, mmixcoms.fint);
      this.addcom(0x18, "mul", octypes.Rrr, mmixcoms.mul);
      this.addcom(0x19, "mul", octypes.Rrb, mmixcoms.mul);
      this.addcom(0x1a, "mulu", octypes.Rrr, mmixcoms.mulu);
      this.addcom(0x1b, "mulu", octypes.Rrb, mmixcoms.mulu);
      this.addcom(0x20, "add", octypes.Rrr, mmixcoms.add);
      this.addcom(0x21, "add", octypes.Rrb, mmixcoms.add);
      this.addcom(0x22, "addu", octypes.Rrr, mmixcoms.add);
      this.addcom(0x23, "addu", octypes.Rrb, mmixcoms.add);
      this.addcom(0x24, "sub", octypes.Rrr, mmixcoms.sub);
      this.addcom(0x25, "sub", octypes.Rrb, mmixcoms.sub);
      this.addcom(0x26, "subu", octypes.Rrr, mmixcoms.sub);
      this.addcom(0x27, "subu", octypes.Rrb, mmixcoms.sub);
      this.addcom(0x30, "cmp", octypes.Rrr, mmixcoms.cmp);
      this.addcom(0x31, "cmp", octypes.Rrb, mmixcoms.cmp);
      this.addcom(0x32, "cmpu", octypes.Rrr, mmixcoms.cmpu);
      this.addcom(0x33, "cmpu", octypes.Rrb, mmixcoms.cmpu);
      this.addcom(0x34, "neg", octypes.Rbr, mmixcoms.neg);
      this.addcom(0x35, "neg", octypes.Rbb, mmixcoms.neg);
      this.addcom(0x36, "negu", octypes.Rbr, mmixcoms.negu);
      this.addcom(0x37, "negu", octypes.Rbb, mmixcoms.negu);
      this.addcom(0x40, "bn", octypes.ra, mmixcoms.bn);
      this.addcom(0x41, "bn", octypes.rA, mmixcoms.bn);
      this.addcom(0x42, "bz", octypes.ra, mmixcoms.bz);
      this.addcom(0x43, "bz", octypes.rA, mmixcoms.bz);
      this.addcom(0x44, "bp", octypes.ra, mmixcoms.bp);
      this.addcom(0x45, "bp", octypes.rA, mmixcoms.bp);
      this.addcom(0x46, "bod", octypes.ra, mmixcoms.bod);
      this.addcom(0x47, "bod", octypes.rA, mmixcoms.bod);
      this.addcom(0x48, "bnn", octypes.ra, mmixcoms.bnn);
      this.addcom(0x49, "bnn", octypes.rA, mmixcoms.bnn);
      this.addcom(0x4A, "bnz", octypes.ra, mmixcoms.bnz);
      this.addcom(0x4B, "bnz", octypes.rA, mmixcoms.bnz);
      this.addcom(0x4C, "bnp", octypes.ra, mmixcoms.bnp);
      this.addcom(0x4D, "bnp", octypes.rA, mmixcoms.bnp);
      this.addcom(0x4E, "bev", octypes.ra, mmixcoms.bev);
      this.addcom(0x4F, "bev", octypes.rA, mmixcoms.bev);
      this.addcom(0x50, "pbn", octypes.ra, mmixcoms.bn);
      this.addcom(0x51, "pbn", octypes.rA, mmixcoms.bn);
      this.addcom(0x52, "pbz", octypes.ra, mmixcoms.bz);
      this.addcom(0x53, "pbz", octypes.rA, mmixcoms.bz);
      this.addcom(0x54, "pbp", octypes.ra, mmixcoms.bp);
      this.addcom(0x55, "pbp", octypes.rA, mmixcoms.bp);
      this.addcom(0x56, "pbod", octypes.ra, mmixcoms.bod);
      this.addcom(0x57, "pbod", octypes.rA, mmixcoms.bod);
      this.addcom(0x58, "pbnn", octypes.ra, mmixcoms.bnn);
      this.addcom(0x59, "pbnn", octypes.rA, mmixcoms.bnn);
      this.addcom(0x5A, "pbnz", octypes.ra, mmixcoms.bnz);
      this.addcom(0x5B, "pbnz", octypes.rA, mmixcoms.bnz);
      this.addcom(0x5C, "pbnp", octypes.ra, mmixcoms.bnp);
      this.addcom(0x5D, "pbnp", octypes.rA, mmixcoms.bnp);
      this.addcom(0x5E, "pbev", octypes.ra, mmixcoms.bev);
      this.addcom(0x5F, "pbev", octypes.rA, mmixcoms.bev);
      this.addcom(0x60, "csn", octypes.Rrr, mmixcoms.csn);
      this.addcom(0x61, "csn", octypes.Rrb, mmixcoms.csn);
      this.addcom(0x62, "csz", octypes.Rrr, mmixcoms.csz);
      this.addcom(0x63, "csz", octypes.Rrb, mmixcoms.csz);
      this.addcom(0x64, "csp", octypes.Rrr, mmixcoms.csp);
      this.addcom(0x65, "csp", octypes.Rrb, mmixcoms.csp);
      this.addcom(0x66, "csod", octypes.Rrr, mmixcoms.csod);
      this.addcom(0x67, "csod", octypes.Rrb, mmixcoms.csod);
      this.addcom(0x68, "csnn", octypes.Rrr, mmixcoms.csnn);
      this.addcom(0x69, "csnn", octypes.Rrb, mmixcoms.csnn);
      this.addcom(0x6A, "csnz", octypes.Rrr, mmixcoms.csnz);
      this.addcom(0x6B, "csnz", octypes.Rrb, mmixcoms.csnz);
      this.addcom(0x6C, "csnp", octypes.Rrr, mmixcoms.csnp);
      this.addcom(0x6D, "csnp", octypes.Rrb, mmixcoms.csnp);
      this.addcom(0x6E, "csev", octypes.Rrr, mmixcoms.csev);
      this.addcom(0x6F, "csev", octypes.Rrb, mmixcoms.csev);
      this.addcom(0x70, "zsn", octypes.Rrr, mmixcoms.zsn);
      this.addcom(0x71, "zsn", octypes.Rrb, mmixcoms.zsn);
      this.addcom(0x72, "zsz", octypes.Rrr, mmixcoms.zsz);
      this.addcom(0x73, "zsz", octypes.Rrb, mmixcoms.zsz);
      this.addcom(0x74, "zsp", octypes.Rrr, mmixcoms.zsp);
      this.addcom(0x75, "zsp", octypes.Rrb, mmixcoms.zsp);
      this.addcom(0x76, "zsod", octypes.Rrr, mmixcoms.zsod);
      this.addcom(0x77, "zsod", octypes.Rrb, mmixcoms.zsod);
      this.addcom(0x78, "zsnn", octypes.Rrr, mmixcoms.zsnn);
      this.addcom(0x79, "zsnn", octypes.Rrb, mmixcoms.zsnn);
      this.addcom(0x7A, "zsnz", octypes.Rrr, mmixcoms.zsnz);
      this.addcom(0x7B, "zsnz", octypes.Rrb, mmixcoms.zsnz);
      this.addcom(0x7C, "zsnp", octypes.Rrr, mmixcoms.zsnp);
      this.addcom(0x7D, "zsnp", octypes.Rrb, mmixcoms.zsnp);
      this.addcom(0x7E, "zsev", octypes.Rrr, mmixcoms.zsev);
      this.addcom(0x7F, "zsev", octypes.Rrb, mmixcoms.zsev);
      this.addcom(0x80, "ldb", octypes.Rrr, mmixcoms.ldb);
      this.addcom(0x81, "ldb", octypes.Rrb, mmixcoms.ldb);
      this.addcom(0x82, "ldbu", octypes.Rrr, mmixcoms.ldbu);
      this.addcom(0x83, "ldbu", octypes.Rrb, mmixcoms.ldbu);
      this.addcom(0x84, "ldw", octypes.Rrr, mmixcoms.ldw);
      this.addcom(0x85, "ldw", octypes.Rrb, mmixcoms.ldw);
      this.addcom(0x86, "ldwu", octypes.Rrr, mmixcoms.ldwu);
      this.addcom(0x87, "ldwu", octypes.Rrb, mmixcoms.ldwu);
      this.addcom(0x88, "ldt", octypes.Rrr, mmixcoms.ldt);
      this.addcom(0x89, "ldt", octypes.Rrb, mmixcoms.ldt);
      this.addcom(0x8A, "ldtu", octypes.Rrr, mmixcoms.ldtu);
      this.addcom(0x8B, "ldtu", octypes.Rrb, mmixcoms.ldtu);
      this.addcom(0x8C, "ldo", octypes.Rrr, mmixcoms.ldou);
      this.addcom(0x8D, "ldo", octypes.Rrb, mmixcoms.ldou);
      this.addcom(0x8E, "ldou", octypes.Rrr, mmixcoms.ldou);
      this.addcom(0x8F, "ldou", octypes.Rrb, mmixcoms.ldou);
      this.addcom(0xA0, "stb", octypes.rrr, mmixcoms.stb);
      this.addcom(0xA1, "stb", octypes.rrb, mmixcoms.stb);
      this.addcom(0xA2, "stbu", octypes.rrr, mmixcoms.stbu);
      this.addcom(0xA3, "stbu", octypes.rrb, mmixcoms.stbu);
      this.addcom(0xA4, "stw", octypes.rrr, mmixcoms.stw);
      this.addcom(0xA5, "stw", octypes.rrb, mmixcoms.stw);
      this.addcom(0xA6, "stwu", octypes.rrr, mmixcoms.stwu);
      this.addcom(0xA7, "stwu", octypes.rrb, mmixcoms.stwu);
      this.addcom(0xA8, "stt", octypes.rrr, mmixcoms.stt);
      this.addcom(0xA9, "stt", octypes.rrb, mmixcoms.stt);
      this.addcom(0xAA, "sttu", octypes.rrr, mmixcoms.sttu);
      this.addcom(0xAB, "sttu", octypes.rrb, mmixcoms.sttu);
      this.addcom(0xAC, "sto", octypes.rrr, mmixcoms.stou);
      this.addcom(0xAD, "sto", octypes.rrb, mmixcoms.stou);
      this.addcom(0xAE, "stou", octypes.rrr, mmixcoms.stou);
      this.addcom(0xAF, "stou", octypes.rrb, mmixcoms.stou);
      this.addcom(0xC0, "or", octypes.Rrr, mmixcoms.or);
      this.addcom(0xC1, "or", octypes.Rrb, mmixcoms.or);
      this.addcom(0xC2, "orn", octypes.Rrr, mmixcoms.orn);
      this.addcom(0xC3, "orn", octypes.Rrb, mmixcoms.orn);
      this.addcom(0xC4, "nor", octypes.Rrr, mmixcoms.nor);
      this.addcom(0xC5, "nor", octypes.Rrb, mmixcoms.nor);
      this.addcom(0xC6, "xor", octypes.Rrr, mmixcoms.xor);
      this.addcom(0xC7, "xor", octypes.Rrb, mmixcoms.xor);
      this.addcom(0xC8, "and", octypes.Rrr, mmixcoms.and);
      this.addcom(0xC9, "and", octypes.Rrb, mmixcoms.and);
      this.addcom(0xCA, "andn", octypes.Rrr, mmixcoms.andn);
      this.addcom(0xCB, "andn", octypes.Rrb, mmixcoms.andn);
      this.addcom(0xCC, "nand", octypes.Rrr, mmixcoms.nand);
      this.addcom(0xCD, "nand", octypes.Rrb, mmixcoms.nand);
      this.addcom(0xCE, "nxor", octypes.Rrr, mmixcoms.nxor);
      this.addcom(0xCF, "nxor", octypes.Rrb, mmixcoms.nxor);
      this.addcom(0xE0, "seth", octypes.Rw, mmixcoms.seth);
      this.addcom(0xE1, "setmh", octypes.Rw, mmixcoms.setmh);
      this.addcom(0xE2, "setml", octypes.Rw, mmixcoms.setml);
      this.addcom(0xE3, "setl", octypes.Rw, mmixcoms.setl);
      this.addcom(0xE4, "inch", octypes.Rw, mmixcoms.inch);
      this.addcom(0xE5, "incmh", octypes.Rw, mmixcoms.incmh);
      this.addcom(0xE6, "incml", octypes.Rw, mmixcoms.incml);
      this.addcom(0xE7, "incl", octypes.Rw, mmixcoms.incl);
      this.addcom(0xE8, "orh", octypes.Rw, mmixcoms.orh);
      this.addcom(0xE9, "ormh", octypes.Rw, mmixcoms.ormh);
      this.addcom(0xEA, "orml", octypes.Rw, mmixcoms.orml);
      this.addcom(0xEB, "orl", octypes.Rw, mmixcoms.orl);
      this.addcom(0xEC, "andh", octypes.Rw, mmixcoms.andh);
      this.addcom(0xED, "andmh", octypes.Rw, mmixcoms.andmh);
      this.addcom(0xEE, "andml", octypes.Rw, mmixcoms.andml);
      this.addcom(0xEF, "andl", octypes.Rw, mmixcoms.andl);
      this.addcom(0xF0, "jmp", octypes.rh, mmixcoms.jmp);
      this.addcom(0xEF, "jmp", octypes.rH, mmixcoms.jmp);
    }

    MMIXProcessor.prototype.addcom = function(opcode, name, type, f) {
      this.coms[opcode] = f;
      this.comstypes[opcode] = type;
      this.comsnames[opcode] = name;
      return this.addcomc++;
    };

    MMIXProcessor.prototype.disassemble = function(command) {
      var octypes, opcode;
      opcode = command >>> 24;
      octypes = this.OCTYPES;
      if (this.comstypes[opcode] === octypes.Rw) {
        return this.comsnames[opcode] + " $" + shared.addLeadZero((command >>> 16 & 0xFF).toString(16).toUpperCase(), 2) + " 0x" + shared.addLeadZero((command & 0xFFFF).toString(16).toUpperCase(), 4);
      } else if (this.comstypes[opcode] === octypes.ra || this.comstypes[opcode] === octypes.rA) {
        return this.comsnames[opcode] + " $" + shared.addLeadZero((command >>> 16 & 0xFF).toString(16).toUpperCase(), 2) + (this.comstypes[opcode] === octypes.ra ? " @+" : " @-") + "4*0x" + shared.addLeadZero((command & 0xFFFF).toString(16).toUpperCase(), 4);
      } else if (this.comstypes[opcode] === octypes.rh || this.comstypes[opcode] === octypes.rH) {
        return this.comsnames[opcode] + (this.comstypes[opcode] === octypes.rh ? " @+" : " @-") + "4*0x" + shared.addLeadZero((command >>> 16 & 0xFF).toString(16).toUpperCase(), 2) + shared.addLeadZero((command >>> 8 & 0xFF).toString(16).toUpperCase(), 2) + shared.addLeadZero((command >>> 0 & 0xFF).toString(16).toUpperCase(), 2);
      } else if (this.comstypes[opcode] === octypes.rrr || this.comstypes[opcode] === octypes.Rrr) {
        return this.comsnames[opcode] + " $" + shared.addLeadZero((command >>> 16 & 0xFF).toString(16).toUpperCase(), 2) + " $" + shared.addLeadZero((command >>> 8 & 0xFF).toString(16).toUpperCase(), 2) + " $" + shared.addLeadZero((command >>> 0 & 0xFF).toString(16).toUpperCase(), 2);
      } else if (this.comstypes[opcode] === octypes.rrb || this.comstypes[opcode] === octypes.Rrb) {
        return this.comsnames[opcode] + " $" + shared.addLeadZero((command >>> 16 & 0xFF).toString(16).toUpperCase(), 2) + " $" + shared.addLeadZero((command >>> 8 & 0xFF).toString(16).toUpperCase(), 2) + " 0x" + shared.addLeadZero((command >>> 0 & 0xFF).toString(16).toUpperCase(), 2);
      } else if (this.comstypes[opcode] === octypes.bbb) {
        return this.comsnames[opcode] + " 0x" + shared.addLeadZero((command >>> 16 & 0xFF).toString(16).toUpperCase(), 2) + " 0x" + shared.addLeadZero((command >>> 8 & 0xFF).toString(16).toUpperCase(), 2) + " 0x" + shared.addLeadZero((command >>> 0 & 0xFF).toString(16).toUpperCase(), 2);
      } else if (this.comstypes[opcode] === octypes.Rob) {
        return this.comsnames[opcode] + " $" + shared.addLeadZero((command >>> 16 & 0xFF).toString(16).toUpperCase(), 2) + ((function() {
          switch (command >>> 8 & 0xFF) {
            case 0:
              return "";
            case 1:
              return " ROUND_OFF";
            case 2:
              return " ROUND_UP";
            case 3:
              return " ROUND_DOWN";
            case 4:
              return " ROUND_NEAR";
            default:
              return " __WRONG__";
          }
        })()) + " 0x" + shared.addLeadZero((command >>> 0 & 0xFF).toString(16).toUpperCase(), 2);
      } else if (this.comstypes[opcode] === octypes.Ror) {
        return this.comsnames[opcode] + " $" + shared.addLeadZero((command >>> 16 & 0xFF).toString(16).toUpperCase(), 2) + ((function() {
          switch (command >>> 8 & 0xFF) {
            case 0:
              return "";
            case 1:
              return " ROUND_OFF";
            case 2:
              return " ROUND_UP";
            case 3:
              return " ROUND_DOWN";
            case 4:
              return " ROUND_NEAR";
            default:
              return " __WRONG__";
          }
        })()) + " $" + shared.addLeadZero((command >>> 0 & 0xFF).toString(16).toUpperCase(), 2);
      } else if (this.comstypes[opcode] === octypes.Rbb) {
        return this.comsnames[opcode] + " $" + shared.addLeadZero((command >>> 16 & 0xFF).toString(16).toUpperCase(), 2) + " 0x" + shared.addLeadZero((command >>> 8 & 0xFF).toString(16).toUpperCase(), 2) + " 0x" + shared.addLeadZero((command >>> 0 & 0xFF).toString(16).toUpperCase(), 2);
      } else if (this.comstypes[opcode] === octypes.Rbr) {
        return this.comsnames[opcode] + " $" + shared.addLeadZero((command >>> 16 & 0xFF).toString(16).toUpperCase(), 2) + " 0x" + shared.addLeadZero((command >>> 8 & 0xFF).toString(16).toUpperCase(), 2) + " $" + shared.addLeadZero((command >>> 0 & 0xFF).toString(16).toUpperCase(), 2);
      } else {
        return "not implemented yet " + shared.addLeadZero(opcode.toString(16).toUpperCase(), 2);
      }
    };

    MMIXProcessor.prototype.execute = function(command) {
      var $X, $X_i, $Y, $Y_i, $Z, $Z_i, X, Y, Z, h, octypes, opcode, w;
      opcode = command >>> 24;
      octypes = this.OCTYPES;
      if (this.comstypes[opcode] === octypes.Rw) {
        $X_i = (command >>> 16) & 0xFF;
        $X = this.regs.getOcta($X_i);
        w = command & 0xFFFF;
        this.coms[opcode]($X, w);
        return this.regs.setOcta($X_i, $X);
      } else if (this.comstypes[opcode] === octypes.ra || this.comstypes[opcode] === octypes.rA) {
        $X_i = (command >>> 16) & 0xFF;
        $X = this.regs.getOcta($X_i);
        w = command & 0xFFFF;
        if (this.comstypes[opcode] === octypes.rA) {
          w = -w;
        }
        return this.coms[opcode]($X, w);
      } else if (this.comstypes[opcode] === octypes.rh || this.comstypes[opcode] === octypes.rH) {
        h = command & 0xFFFFFF;
        if (this.comstypes[opcode] === octypes.rH) {
          h = -h;
        }
        return this.coms[opcode](h);
      } else if (this.comstypes[opcode] === octypes.rrr || this.comstypes[opcode] === octypes.Rrr) {
        $X_i = (command >>> 16) & 0xFF;
        $Y_i = (command >>> 8) & 0xFF;
        $Z_i = (command >>> 0) & 0xFF;
        $X = this.regs.getOcta($X_i);
        $Y = this.regs.getOcta($Y_i);
        $Z = this.regs.getOcta($Z_i);
        this.coms[opcode]($X, $Y, $Z);
        if (this.comstypes[opcode] === octypes.Rrr) {
          return this.regs.setOcta($X_i, $X);
        }
      } else if (this.comstypes[opcode] === octypes.rrb || this.comstypes[opcode] === octypes.Rrb) {
        $X_i = (command >>> 16) & 0xFF;
        $Y_i = (command >>> 8) & 0xFF;
        Z = (command >>> 0) & 0xFF;
        $X = this.regs.getOcta($X_i);
        $Y = this.regs.getOcta($Y_i);
        this.coms[opcode]($X, $Y, Z);
        if (this.comstypes[opcode] === octypes.Rrb) {
          return this.regs.setOcta($X_i, $X);
        }
      } else if (this.comstypes[opcode] === octypes.bbb) {
        X = (command >>> 16) & 0xFF;
        Y = (command >>> 8) & 0xFF;
        Z = (command >>> 0) & 0xFF;
        return this.coms[opcode](X, Y, Z);
      } else if (this.comstypes[opcode] === octypes.Ror) {
        $X_i = (command >>> 16) & 0xFF;
        Y = (command >>> 8) & 0xFF;
        $Z_i = (command >>> 0) & 0xFF;
        $X = this.regs.getOcta($X_i);
        $Z = this.regs.getOcta($Z_i);
        this.coms[opcode]($X, Y, $Z);
        return this.regs.setOcta($X_i, $X);
      } else if (this.comstypes[opcode] === octypes.Rob) {
        $X_i = (command >>> 16) & 0xFF;
        Y = (command >>> 8) & 0xFF;
        Z = (command >>> 0) & 0xFF;
        $X = this.regs.getOcta($X_i);
        this.coms[opcode]($X, Y, Z);
        return this.regs.setOcta($X_i, $X);
      } else if (this.comstypes[opcode] === octypes.Rbr) {
        $X_i = (command >>> 16) & 0xFF;
        Y = (command >>> 8) & 0xFF;
        $Z_i = (command >>> 0) & 0xFF;
        $X = this.regs.getOcta($X_i);
        $Z = this.regs.getOcta($Z_i);
        this.coms[opcode]($X, Y, $Z);
        return this.regs.setOcta($X_i, $X);
      } else if (this.comstypes[opcode] === octypes.Rbb) {
        $X_i = (command >>> 16) & 0xFF;
        Y = (command >>> 8) & 0xFF;
        Z = (command >>> 0) & 0xFF;
        $X = this.regs.getOcta($X_i);
        this.coms[opcode]($X, Y, Z);
        return this.regs.setOcta($X_i, $X);
      } else {
        throw "not implemented";
      }
    };

    return MMIXProcessor;

  })();

}).call(this);

/*
//@ sourceMappingURL=processor.map
*/
