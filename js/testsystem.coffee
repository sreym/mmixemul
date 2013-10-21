shared = window
shared.regs = new shared.Registers(256)
shared.mem = new shared.Memory(1024)
shared.proc = new shared.MMIXProcessor(mem, regs)

programHexCode = '';

getByteNameBySize  = (s) ->
  switch s
    when 8 then "OctaByte"
    when 4 then "TetraByte"
    when 2 then "Wyde"
    when 1 then "Byte"

getErrorText = (res, task, ext) ->
  str = if res is true then "" else "Error! "
  switch task.cmd
    when "get"
      str += "Expected #{getByteNameBySize(task.size)} at ##{task.addr.toString(16)} with value 0x#{task.val.toString(16)}. "
      str += "Found value 0x#{ext.value.toString(16)}." if not res
    when "set"
      str += "Setting #{getByteNameBySize(task.size)} at ##{task.addr.toString(16)} with value 0x#{task.val.toString(16)}. "
    when "load"
      str += "Loading program. "
    when "go"
      str += "Execution. "
    when "reg"
      str += "Fill registry with #{task.val} values. "
    when "mem"
      str += "Fill memory with #{task.val} values. "
    else
      str += "Unknown command identifier."
  return str

shared.goTask = (task, source, itCallBack) ->
  programHexCode = source
  i = 0

  while i < task.length
    ext = {}
    try
      r = cmd[task[i].cmd](task[i], ext)
    catch e
      r = false
      console.log "error! with cmd = " + task[i].cmd
    text = getErrorText(r, task[i], ext)
    itCallBack(r, task[i], ext, text)
    i++


cmd = {}
cmd.load = (obj) ->
  len = programHexCode.length
  alert "wrong line"  unless len % 8 is 0
  i = 0

  while i < len / 8
    shared.mem.setTetra i * 4, parseInt(programHexCode.substr(i * 8, 8), 16)
    i++
  true

cmd.get = (obj, ext) ->
  switch obj.size
    when 8
      ext.value = shared.mem.getOcta(obj.addr)
      if obj.val instanceof shared.OctaByte
        return ext.value.cmpu(obj.val) is 0
      else
        return ext.value.cmpu(new shared.OctaByte(0, obj.val)) is 0
    when 4
      ext.value = shared.mem.getTetra(obj.addr)
      return ext.value is obj.val
    when 2
      ext.value = shared.mem.getWyde(obj.addr)
      return ext.value is obj.val
    when 1
      ext.value = shared.mem.getByte(obj.addr)
      return ext.value is obj.val
  true

cmd.go = (obj) ->
  shared.proc.run()
  true

cmd.set = (obj) ->
  switch obj.size
    when 8
      if obj.val instanceof shared.OctaByte
        shared.mem.setOcta obj.addr, obj.val
      else
        shared.mem.setOcta obj.addr, new shared.OctaByte(0, obj.val)
    when 4
      shared.mem.setTetra obj.addr, obj.val
    when 2
      shared.mem.setWyde obj.addr, obj.val
    when 1
      shared.mem.setByte obj.addr, obj.val
  true

cmd.reg = (obj) ->
  switch obj.val
    when "random"
      i = 0

      while i < shared.regs.size()
        shared.regs.setOcta i, new shared.OctaByte(Math.floor(Math.random() * Math.pow(2, 32)), Math.floor(Math.random() * Math.pow(2, 32)))
        i++
    when "inc"
      numI = 0
      octaByte = undefined
      i = 0

      while i < 256
        j = 0

        while j < 8
          octaByte = shared.regs.getOcta(i)
          octaByte.setByte j, numI
          shared.regs.setOcta i, octaByte
          numI++
          j++
        i++
    else
      throw "Unknown val for reg"
  true

cmd.mem = (obj) ->
  switch obj.val
    when "random"
      i = 0

      while i < shared.mem.size()
        shared.mem.setByte i, Math.floor(Math.random() * 255)
        i++
    when "inc"
      i = 0

      while i < 1024
        shared.mem.setByte i, i % 256
        i++
    else
      throw "Unknown val for mem"
  true