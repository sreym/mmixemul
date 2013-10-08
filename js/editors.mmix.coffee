$ = jQuery

shared = window

getEditItem = (block_div) ->
  editing = block_div.data('editing')
  i = editing / 2 / block_div.data("options").sbsize | 0
  j = editing / 2 % block_div.data("options").sbsize | 0
  $(block_div.find("div.line:nth-child(#{i + 1}) span.item")[j])

updateEditView = (block_div) ->
  editing = block_div.data('editing')
  if (editing isnt false)
    item = getEditItem(block_div)
    block_div.find("span.editing").removeClass("editing")
    item.addClass("editing")
    item_text = item.text().trim()
    if editing % 2  is 0
      item.html("<span class='cur'>#{item_text[0]}</span>#{item_text[1]}")
    else
      item.html("#{item_text[0]}<span class='cur'>#{item_text[1]}</span>")
  else
    block_div.find("span.editing").removeClass("editing")

plusEditing = (block_div, i) ->
  console.log i
  nval = block_div.data('editing') + i
  if 0 <= nval < block_div.data("options").size * 2
    block_div.data('editing', nval)
  else
    stopEdit(block_div)
  updateEditView(block_div)


pushToEdit = (block_div, val) ->
  if 48 <= val <= 57 or 65 <= val <= 70 or 96 <= val <= 105
    val -= if val < 58 then 48 else if val > 95 then 96 else 55
    item = getEditItem(block_div)
    editing = block_div.data('editing')
    if editing % 2  is 0
      item.html("#{val.toString(16)}#{item.text()[1]}")
    else
      item.html("#{item.text()[0]}#{val.toString(16)}")
    block_div.trigger("push", [editing, val])
    plusEditing(block_div, 1)

stopEdit = (block_div) ->
  if (block_div.data('editing') isnt false)
    block_div.data('editing', false)
    updateEditView(block_div)

startEdit = (block_div, i, j) ->
  block_div.data('editing', (i * block_div.data("options").sbsize + j) * 2)
  updateEditView(block_div)

$.fn.hexeditor = (options) ->
  defaults =
    size : 64
    sbsize : 4
    numberIsLine : false
    getByte: (i,j) -> 0
    postLine: (i) -> ""
  options = $.extend(defaults, options)

  getLineNum = (i, options) ->
    if options.numberIsLine
      shared.addLeadZero(i.toString(16), Math.ceil(Math.log(options.size / options.sbsize) / Math.log(16)))
    else
      shared.addLeadZero((i * options.sbsize).toString(16), Math.ceil(Math.log(options.size) / Math.log(16)))

  shared.hexEditors = new Array() if not shared.hexEditors?

  this.each () ->
    block_div = $(this)
    block_div.data("options", options)
    shared.hexEditors.push(block_div)
    block_div.addClass("hexEditor")
    block_div.data('editing', false)
    sbnum = Math.ceil( options.size / options.sbsize )

    for i in [0...sbnum]
      line_div = $("<div class='line'></div>")
      line_num = $("<span class='num'>#{getLineNum(i, options)}</span>")
      line_div.append(line_num);

      for j in [0...options.sbsize]
        line_item = $("<span class='item'>#{shared.addLeadZero(options.getByte(i, j).toString(16), 2)}</span>")
        line_div.append(line_item)
      line_div.append(options.postLine.call(block_div, i))
      block_div.append(line_div)

    block_div.find("span.item").click((e) ->
      el = $(this)
      if el.hasClass("editing")
        stopEdit(block_div)
      else
        stopEdit(block_i) for block_i in shared.hexEditors
        startEdit(block_div, el.parent().prevAll("div.line").length, el.prevAll('span.item').length)
    )

    $(document).keydown( (e) ->
      if block_div.data("editing") isnt false
        switch(e.keyCode)
          when 9
            if e.shiftKey
              plusEditing(block_div,
                Math.floor(
                  (block_div.data('editing') - options.sbsize * 2) / (options.sbsize * 2)
                ) * (options.sbsize * 2) - block_div.data('editing')
              )
            else
              plusEditing(block_div,
                Math.floor(
                  (block_div.data('editing') + options.sbsize * 2) / (options.sbsize * 2)
                ) * (options.sbsize * 2) - block_div.data('editing')
              )
            e.preventDefault()
          when 27 then stopEdit(block_div)
          when 8
            plusEditing(block_div, -1)
            e.preventDefault()
          when 37
            plusEditing(block_div,
              if e.shiftKey then -2 else -1
            )
            e.preventDefault()
          when 38
            plusEditing(block_div, -2 * options.sbsize)
            e.preventDefault()
          when 39
            plusEditing(block_div,
              if e.shiftKey then 2 else 1
            )
            e.preventDefault()
          when 40
            plusEditing(block_div, 2 * options.sbsize)
            e.preventDefault()
          else pushToEdit(block_div, e.keyCode)
    )

$.fn.mmixmemeditor = (options) ->
  defaults =
    size : 1024
    sbsize : 4
    numberIsLine : false
    data : null
  options = $.extend(defaults, options)
  throw "Data is undefined." if options.data is null
  options.size = options.data.size()
  options.getByte = (i,j) ->
    options.data.getByte(i * options.sbsize + j)

  obj = this

  options.data.addEventListener("set", (data) ->
    if obj.data("editing") is false
      i = data.i / options.sbsize | 0
      j = data.i % options.sbsize | 0
      line_div = obj.find("div.line:nth-child(#{i + 1})")
      line_div2 = obj.find("div.line:nth-child(#{i + 2})")
      line_items = line_div.find(".item")
      v = data.val
      switch(data.size)
        when 1
          $(line_items[j]).text(shared.addLeadZero((v & 0xFF).toString(16),2))
        when 2
          $(line_items[j + 0]).text(shared.addLeadZero((v >>> 8).toString(16),2))
          $(line_items[j + 1]).text(shared.addLeadZero((v & 0xFF).toString(16),2))
        when 4
          for t in [0...4]
            $(line_items[j + t]).text(shared.addLeadZero(((v >>> (24 - t * 8)) & 0xFF).toString(16),2))
        when 8
          line_items2 = line_div2.find(".item")
          for t in [0...4]
            $(line_items[j + t]).text(shared.addLeadZero((v.getByte(t)).toString(16),2))
            $(line_items2[j + t]).text(shared.addLeadZero((v.getByte(4 + t)).toString(16),2))
        else throw "Wrong size."
      line_div.addClass('updated')
      if data.size is 8
        line_div2.addClass('updated')
      setTimeout(
        ()->
          line_div.removeClass('updated')
          line_div2.removeClass('updated')
        1000
      )
  )

  this.hexeditor(options)
  this.on("push", (e, i, val) ->
    byteNum = i / 2 | 0
    byteSh = i % 2 | 0
    byteVal = options.data.getByte(byteNum)
    if byteSh is 0
      byteVal = (byteVal & 0x0F) ^ ((val & 0xF) << 4)
    else
      byteVal = (byteVal & 0xF0) ^ (val & 0xF)
    options.data.setByte(byteNum, byteVal)
  )

$.fn.mmixregeditor = (options) ->
  defaults =
    size : 2048
    sbsize : 8
    numberIsLine : true
    data : null
  options = $.extend(defaults, options)
  throw "Data is undefined." if options.data is null
  options.size = options.data.size() * 8
  options.getByte = (i,j) ->
    options.data.getOcta(i).getByte(j)

  obj = this

  options.data.addEventListener("set", (data) ->
    if obj.data("editing") is false
      line_div = obj.find("div.line:nth-child(#{data.i + 1})")
      line_items = line_div.find(".item")
      for i in [0...8]
        $(line_items[i]).text(shared.addLeadZero(data.val.getByte(i).toString(16),2))

      line_div.addClass('updated')
      setTimeout(
        ()->line_div.removeClass('updated')
        2000
      )
  )

  options.data.addEventListener("get", (data) ->
    if obj.data("editing") is false
      line_div = obj.find("div.line:nth-child(#{data.i + 1})")

      line_div.addClass('updated_reading')
      setTimeout(
        ()->line_div.removeClass('updated_reading')
        2000
      )
  )

  this.hexeditor(options)
  this.on("push", (e, i, val) ->
    regNum = i / (2 * options.sbsize) | 0
    regVal = options.data.getOcta(regNum)
    wydeNum = (i / 4 | 0) % 4 | 0
    byteSh = i % 4 | 0
    wydeVal = regVal.get(wydeNum)

    wydeVal = (wydeVal & ~(0xF000 >>> (byteSh * 4))) ^ ((val & 0xF) << (3 - byteSh) * 4)

    regVal.set(wydeNum, wydeVal)
    options.data.setOcta(regNum, regVal)
  )
