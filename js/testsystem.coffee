shared = window
shared.regs = new shared.Registers(256)
shared.mem = new shared.Memory(1024)
shared.proc = new shared.MMIXProcessor(mem, regs)

# loading program
getAnswerLI = (res, task, ext) ->
  text = undefined
  switch task.cmd
    when "set"
    else
      text = "<li>" + JSON.stringify(task) + "</li>"
  tli = $(text)
  tli.addClass "resItem"
  if res
    tli.addClass "ok"
  else
    tli.addClass "wrong"
  tli
shared.goTask = (i, j) ->
  task = shared.tasks[i][j]
  res = $("#results")
  res.empty()
  i = 0

  while i < task.length
    try
      ext = {}
      r = cmd[task[i].cmd](task[i], ext)
      res.append getAnswerLI(r, task[i], ext)
    catch e
      alert "error! with cmd = " + task[i].cmd
    i++
cmd = {}
cmd.load = (obj) ->
  src = $("#program")[0].value.replace(/[^0-9A-Fa-f]/g, "")
  len = src.length
  alert "wrong line"  unless len % 8 is 0
  i = 0

  while i < len / 8
    shared.mem.setTetra i * 4, parseInt(src.substr(i * 8, 8), 16)
    i++
  true

cmd.get = (obj) ->
  switch obj.size
    when 8
      if obj.val instanceof shared.OctaByte
        return shared.mem.getOcta(obj.addr).cmpu(obj.val) is 0
      else
        return shared.mem.getOcta(obj.addr).cmpu(new shared.OctaByte(0, obj.val)) is 0
    when 4
      return shared.mem.getTetra(obj.addr) is obj.val
    when 2
      return shared.mem.getWyde(obj.addr) is obj.val
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