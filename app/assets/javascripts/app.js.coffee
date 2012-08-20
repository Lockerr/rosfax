Array::unique = ->
  output = {}
  output[@[key]] = @[key] for key in [0...@length]
  value for key, value of output

delay = (ms, func) -> setTimeout(func, ms)

arrayDiff = (a1, a2) ->
  o1 = {}
  o2 = {}
  diff = []
  i = undefined
  len = undefined
  k = undefined
  i = 0
  len = a1.length

  while i < len
    o1[a1[i]] = true
    i++
  i = 0
  len = a2.length

  while i < len
    o2[a2[i]] = true
    i++
  for k of o1
    diff.push k  unless k of o2
  for k of o2
    diff.push k  unless k of o1
  diff

refreshing = false
console.log "refreshing: #{refreshing}"

update_eye_fi = ->
  # ids = $("#eye-fi img").map((i) -> $("#eye-fi img")[i].id)
  ids = $.map($("#eye-fi img"), (n, i) -> n.id)
  $.ajax
    url: '/ftp/update_eye_fi'
    data: {ids: ids}
    success: (data) ->
      console.log data

      for id in data
        img = $ "<img alt='Missing' class='processing' draggable='true' height='66' id='#{id}' processing='#{id}' src='/assets/loading.gif' style='cursor: move;' width='96'>"
        $("#eye-fi").append(img)

      $('.photos').trigger 'change'




get_images = ->
  refreshing = true
  ids = $.map($(".processing"), (n, i) -> n.id ).unique()
  if ids.length > 0
    console.log ids

    $.ajax
      url: '/assets/processed'
      data: {assets: ids, size: 'thumb'}
      complete: (data) ->
        data = $.parseJSON(data.responseText)
        setTimeout(( -> refreshing = false), 1000)

        if data.keys.length == 0
          if $(".processing").length > 0
            console.log 'last diff ==========================================='
            console.log arrayDiff( ids, data.keys)
            console.log 'last diff ==========================================='

        else
          for i in data.keys
            setTimeout(( -> refresh_image(5000, data.assets[i], i)), 5000)

refresh_image = (refresh_rate, src, id) ->
  setTimeout(( ->
          $(".processing[id=#{id}]").attr('src', src)
          $(".processing[id=#{id}]").removeClass('processing')
          $.each $('.photos img'), ->
            this.ondragstart = (event) ->
              window.dragged = event.target
        ), 115000)

$(document).ready ->
  $.each $('.tab-content.second'), ->
    $(this).children().first().addClass('active')
  $.each $('.nav-tabs'), ->
    $(this).children().first().addClass('active')



  $('.photos').live 'custom_change', ->
    console.log "refreshing: #{refreshing}"
    unless refreshing
      refresh_loop = (refresh_rate) ->
          console.log("inside photos refresh loop #{refresh_rate}")
          get_images()

          setTimeout((-> refresh_loop(refresh_rate) if $('.processing').length > 0), refresh_rate)


      refresh_rate = 5000
      setTimeout((-> refresh_loop(refresh_rate)), refresh_rate)

  $('.photos').trigger 'custom_change'

  eye_fi_loop = ->
      update_eye_fi()
      setTimeout((-> eye_fi_loop(5000)), 5000)
  setTimeout((-> eye_fi_loop(5000)), 5000)


