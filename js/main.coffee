shared = window

$ = jQuery

$().ready () ->
  shared.regs = new shared.Registers(256)
  shared.mem = new shared.Memory(1024)
  for i in [0...1024]
    shared.mem.setByte(i, i % 256)
  numI = 0
  for i in [0...256]
    for j in [0...8]
      octaByte = shared.regs.getOcta(i)
      octaByte.setByte(j, numI)
      shared.regs.setOcta(i, octaByte)
      numI++
  shared.proc = new shared.MMIXProcessor(mem, regs)

  $('#memed').mmixmemeditor(
    data: shared.mem
    postLine: (i) ->
      "<span class='desc' view='asm'>#{shared.proc.disassemble(shared.mem.getTetra(i * 4))} (asm)</span>"
  )

  linetypes = ["asm", "uint32", "int32", "float", "bool", "ascii"]

  updateMemHexLine = (line) ->
    linetype = line.attr("view")
    i = line.parent().prevAll("div.line").length * 4
    linetext = "";
    switch(linetype)
      when "asm" then linetext = (shared.proc.disassemble(shared.mem.getTetra(i)))
      when "uint32" then linetext = (shared.mem.getTetra(i))
      when "int32"
        val = shared.mem.getTetra(i)
        val = -(0xFFFFFFFF - val + 1) if val >= 0x80000000
        linetext = val
      when "ascii"
        val = shared.mem.getTetra(i)
        unless ((val >>> 24) & 0xFF) < 32 then lA = String.fromCharCode((val >>> 24) & 0xFF) else lA = '◦'
        unless ((val >>> 16) & 0xFF) < 32 then lB = String.fromCharCode((val >>> 16) & 0xFF) else lB = '◦'
        unless ((val >>> 8)  & 0xFF) < 32 then lC = String.fromCharCode((val >>> 8)  & 0xFF) else lC = '◦'
        unless ((val >>> 0)  & 0xFF) < 32 then lD = String.fromCharCode((val >>> 0)  & 0xFF) else lD = '◦'
        linetext = lA + lB + lC + lD
      when "float"
        val = shared.mem.getOcta(i)
        linetext = val.getDouble()
      when "bool"
        val = shared.mem.getTetra(i)
        linetext = val.toString(2)
      else linetext = "not implemented yet"
    line.html("<span class='data'>" + linetext + "</span> <span class='type'>(" + linetype + ")</span>")

  shared.mem.addEventListener("set", (data) ->
    if data.size is 8
      line = $($('#memed').find(".desc")[data.i / 4 | 0])
      updateMemHexLine(line)
      line = $($('#memed').find(".desc")[(data.i / 4 | 0) + 1])
      updateMemHexLine(line)
    else
      line = $($('#memed').find(".desc")[data.i / 4 | 0])
      updateMemHexLine(line)
  )

  $('#memed').find(".desc").click((e)->
    line = $(this)
    ind = linetypes.indexOf(line.attr("view"))
    if ind >=0
      if e.shiftKey
        line.attr("view", linetypes[(ind + 1) % linetypes.length])
      else
        line.attr("view", linetypes[if ind - 1 < 0 then ind - 1 + linetypes.length else ind - 1])
    updateMemHexLine(line)
  )



  $('#reged').mmixregeditor(
    data: shared.regs
  )

  $('#goButton').click(()->
    try
      $("#memed .wrongCommand").removeClass("wrongCommand")
      $("#memed .finishLineNum").removeClass("finishLineNum")
      shared.proc.run()
      $($("#memed .num")[shared.proc.r.curEx / 4 | 0]).addClass("finishLineNum")
    catch e
      if e == "not implemented"
        $($("#memed .num")[shared.proc.r.curEx / 4 | 0]).addClass("wrongCommand")
      else
        throw e
  )

  toggleRawEditor = () ->
    $('#rawEditor').toggle()

  $('#rawEditButton').click( ()->
    toggleRawEditor()
    size = shared.mem.size() / 4 | 0
    rtext = $('#rawText')[0]
    rtext.value = ""
    for i in [0...size]
      rtext.value += shared.addLeadZero(shared.mem.getTetra(i * 4).toString(16),8) + "\n"
  )

  $('#rawEditor_save').click( ()->
    size = shared.mem.size() / 4 | 0
    src = $('#rawText')[0].value.replace(/[^0-9A-Fa-f]/gi, "")
    if (src.length / 8 | 0) isnt size or src.length % 8 isnt 0
      alert "wrong line"
      throw "wrong line"

    for i in [0...size]
      shared.mem.setTetra(i * 4, parseInt(src.substr(i * 8, 8), 16) )

    toggleRawEditor()
  )

  $('#rawEditor_cancel').click( ()->
    toggleRawEditor()
  )

  $(document.body).scroll



