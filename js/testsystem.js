// Generated by CoffeeScript 1.6.3
(function() {
  var cmd, getByteNameBySize, getErrorText, programHexCode, shared;

  shared = window;

  shared.regs = new shared.Registers(256);

  shared.mem = new shared.Memory(1024);

  shared.proc = new shared.MMIXProcessor(mem, regs);

  programHexCode = '';

  getByteNameBySize = function(s) {
    switch (s) {
      case 8:
        return "OctaByte";
      case 4:
        return "TetraByte";
      case 2:
        return "Wyde";
      case 1:
        return "Byte";
    }
  };

  getErrorText = function(res, task, ext) {
    var str;
    str = res === true ? "" : "Error! ";
    switch (task.cmd) {
      case "get":
        str += "Expected " + (getByteNameBySize(task.size)) + " at #" + (task.addr.toString(16)) + " with value 0x" + (task.val.toString(16)) + ". ";
        if (!res) {
          str += "Found value 0x" + (ext.value.toString(16)) + ".";
        }
        break;
      case "set":
        str += "Setting " + (getByteNameBySize(task.size)) + " at #" + (task.addr.toString(16)) + " with value 0x" + (task.val.toString(16)) + ". ";
        break;
      case "load":
        str += "Loading program. ";
        break;
      case "go":
        str += "Execution. ";
        break;
      case "reg":
        str += "Fill registry with " + task.val + " values. ";
        break;
      case "mem":
        str += "Fill memory with " + task.val + " values. ";
        break;
      default:
        str += "Unknown command identifier.";
    }
    return str;
  };

  shared.goTask = function(task, source, itCallBack) {
    var e, ext, i, r, text, _results;
    programHexCode = source;
    i = 0;
    _results = [];
    while (i < task.length) {
      ext = {};
      try {
        r = cmd[task[i].cmd](task[i], ext);
      } catch (_error) {
        e = _error;
        r = false;
        console.log("error! with cmd = " + task[i].cmd);
      }
      text = getErrorText(r, task[i], ext);
      itCallBack(r, task[i], ext, text);
      _results.push(i++);
    }
    return _results;
  };

  cmd = {};

  cmd.load = function(obj) {
    var i, len;
    len = programHexCode.length;
    if (len % 8 !== 0) {
      alert("wrong line");
    }
    i = 0;
    while (i < len / 8) {
      shared.mem.setTetra(i * 4, parseInt(programHexCode.substr(i * 8, 8), 16));
      i++;
    }
    return true;
  };

  cmd.get = function(obj, ext) {
    switch (obj.size) {
      case 8:
        ext.value = shared.mem.getOcta(obj.addr);
        if (obj.val instanceof shared.OctaByte) {
          return ext.value.cmpu(obj.val) === 0;
        } else {
          return ext.value.cmpu(new shared.OctaByte(0, obj.val)) === 0;
        }
        break;
      case 4:
        ext.value = shared.mem.getTetra(obj.addr);
        return ext.value === obj.val;
      case 2:
        ext.value = shared.mem.getWyde(obj.addr);
        return ext.value === obj.val;
      case 1:
        ext.value = shared.mem.getByte(obj.addr);
        return ext.value === obj.val;
    }
    return true;
  };

  cmd.go = function(obj) {
    shared.proc.run();
    return true;
  };

  cmd.set = function(obj) {
    switch (obj.size) {
      case 8:
        if (obj.val instanceof shared.OctaByte) {
          shared.mem.setOcta(obj.addr, obj.val);
        } else {
          shared.mem.setOcta(obj.addr, new shared.OctaByte(0, obj.val));
        }
        break;
      case 4:
        shared.mem.setTetra(obj.addr, obj.val);
        break;
      case 2:
        shared.mem.setWyde(obj.addr, obj.val);
        break;
      case 1:
        shared.mem.setByte(obj.addr, obj.val);
    }
    return true;
  };

  cmd.reg = function(obj) {
    var i, j, numI, octaByte;
    switch (obj.val) {
      case "random":
        i = 0;
        while (i < shared.regs.size()) {
          shared.regs.setOcta(i, new shared.OctaByte(Math.floor(Math.random() * Math.pow(2, 32)), Math.floor(Math.random() * Math.pow(2, 32))));
          i++;
        }
        break;
      case "inc":
        numI = 0;
        octaByte = void 0;
        i = 0;
        while (i < 256) {
          j = 0;
          while (j < 8) {
            octaByte = shared.regs.getOcta(i);
            octaByte.setByte(j, numI);
            shared.regs.setOcta(i, octaByte);
            numI++;
            j++;
          }
          i++;
        }
        break;
      default:
        throw "Unknown val for reg";
    }
    return true;
  };

  cmd.mem = function(obj) {
    var i;
    switch (obj.val) {
      case "random":
        i = 0;
        while (i < shared.mem.size()) {
          shared.mem.setByte(i, Math.floor(Math.random() * 255));
          i++;
        }
        break;
      case "inc":
        i = 0;
        while (i < 1024) {
          shared.mem.setByte(i, i % 256);
          i++;
        }
        break;
      default:
        throw "Unknown val for mem";
    }
    return true;
  };

}).call(this);

/*
//@ sourceMappingURL=testsystem.map
*/
