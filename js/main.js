// Generated by CoffeeScript 1.6.2
(function() {
  var $, shared;

  shared = window;

  $ = jQuery;

  $().ready(function() {
    var i, j, linetypes, numI, octaByte, toggleRawEditor, updateMemHexLine, _i, _j, _k;

    shared.regs = new shared.Registers(256);
    shared.mem = new shared.Memory(1024);
    for (i = _i = 0; _i < 1024; i = ++_i) {
      shared.mem.setByte(i, i % 256);
    }
    numI = 0;
    for (i = _j = 0; _j < 256; i = ++_j) {
      for (j = _k = 0; _k < 8; j = ++_k) {
        octaByte = shared.regs.getOcta(i);
        octaByte.setByte(j, numI);
        shared.regs.setOcta(i, octaByte);
        numI++;
      }
    }
    shared.proc = new shared.MMIXProcessor(mem, regs);
    $('#memed').mmixmemeditor({
      data: shared.mem,
      postLine: function(i) {
        return "<span class='desc' view='asm'>" + (shared.proc.disassemble(shared.mem.getTetra(i * 4))) + " (asm)</span>";
      }
    });
    linetypes = ["asm", "uint32", "int32", "double", "bool", "ascii"];
    updateMemHexLine = function(line) {
      var lA, lB, lC, lD, linetext, linetype, val;

      linetype = line.attr("view");
      i = line.parent().prevAll("div.line").length * 4;
      linetext = "";
      switch (linetype) {
        case "asm":
          linetext = shared.proc.disassemble(shared.mem.getTetra(i));
          break;
        case "uint32":
          linetext = shared.mem.getTetra(i);
          break;
        case "int32":
          val = shared.mem.getTetra(i);
          if (val >= 0x80000000) {
            val = -(0xFFFFFFFF - val + 1);
          }
          linetext = val;
          break;
        case "ascii":
          val = shared.mem.getTetra(i);
          if (!(((val >>> 24) & 0xFF) < 32)) {
            lA = String.fromCharCode((val >>> 24) & 0xFF);
          } else {
            lA = '◦';
          }
          if (!(((val >>> 16) & 0xFF) < 32)) {
            lB = String.fromCharCode((val >>> 16) & 0xFF);
          } else {
            lB = '◦';
          }
          if (!(((val >>> 8) & 0xFF) < 32)) {
            lC = String.fromCharCode((val >>> 8) & 0xFF);
          } else {
            lC = '◦';
          }
          if (!(((val >>> 0) & 0xFF) < 32)) {
            lD = String.fromCharCode((val >>> 0) & 0xFF);
          } else {
            lD = '◦';
          }
          linetext = lA + lB + lC + lD;
          break;
        case "double":
          val = shared.mem.getOcta(i);
          linetext = val.getDouble();
          break;
        case "bool":
          val = shared.mem.getTetra(i);
          linetext = val.toString(2);
          break;
        default:
          linetext = "not implemented yet";
      }
      return line.html("<span class='data'>" + linetext + "</span> <span class='type'>(" + linetype + ")</span>");
    };
    shared.mem.addEventListener("set", function(data) {
      var line;

      if (data.size === 8) {
        line = $($('#memed').find(".desc")[data.i / 4 | 0]);
        updateMemHexLine(line);
        line = $($('#memed').find(".desc")[(data.i / 4 | 0) + 1]);
        return updateMemHexLine(line);
      } else {
        line = $($('#memed').find(".desc")[data.i / 4 | 0]);
        return updateMemHexLine(line);
      }
    });
    $('#memed').find(".desc").click(function(e) {
      var ind, line;

      line = $(this);
      ind = linetypes.indexOf(line.attr("view"));
      if (ind >= 0) {
        if (e.shiftKey) {
          line.attr("view", linetypes[(ind + 1) % linetypes.length]);
        } else {
          line.attr("view", linetypes[ind - 1 < 0 ? ind - 1 + linetypes.length : ind - 1]);
        }
      }
      return updateMemHexLine(line);
    });
    $('#reged').mmixregeditor({
      data: shared.regs
    });
    $('#goButton').click(function() {
      var e;

      try {
        $("#memed .wrongCommand").removeClass("wrongCommand");
        $("#memed .finishLineNum").removeClass("finishLineNum");
        shared.proc.run();
        return $($("#memed .num")[shared.proc.r.curEx / 4 | 0]).addClass("finishLineNum");
      } catch (_error) {
        e = _error;
        if (e === "not implemented") {
          return $($("#memed .num")[shared.proc.r.curEx / 4 | 0]).addClass("wrongCommand");
        } else {
          throw e;
        }
      }
    });
    toggleRawEditor = function() {
      $('#rawEditor').toggle();
      $('#memed').data('editing', false);
      return $('#reged').data('editing', false);
    };
    $('#rawEditButton').click(function() {
      var rtext, size, val, _l, _results;

      toggleRawEditor();
      size = shared.mem.size() / 4 | 0;
      rtext = $('#rawText')[0];
      rtext.value = "";
      _results = [];
      for (i = _l = 0; 0 <= size ? _l < size : _l > size; i = 0 <= size ? ++_l : --_l) {
        val = shared.mem.getTetra(i * 4);
        rtext.value += shared.addLeadZero(val.toString(16), 8) + "\n";
        if (val === 0) {
          break;
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    });
    $('#rawEditor_save').click(function() {
      var len, src, _l, _ref;

      src = $('#rawText')[0].value.replace(/[^0-9A-Fa-f]/gi, "");
      len = src.length;
      if (len % 8 !== 0) {
        alert("wrong line");
        throw "wrong line";
      }
      for (i = _l = 0, _ref = len / 8; 0 <= _ref ? _l < _ref : _l > _ref; i = 0 <= _ref ? ++_l : --_l) {
        shared.mem.setTetra(i * 4, parseInt(src.substr(i * 8, 8), 16));
      }
      return toggleRawEditor();
    });
    return $('#rawEditor_cancel').click(function() {
      return toggleRawEditor();
    });
  });

}).call(this);

/*
//@ sourceMappingURL=main.map
*/
