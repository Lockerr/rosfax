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

get_images = ->
  ids = $.map($(".processing"), (n, i) -> n.id ).unique()
  if ids.length > 0
    console.log ids

    $.ajax
      url: '/assets/processed'
      data: {assets: ids, size: 'thumb'}
      complete: (data) ->
        data = $.parseJSON(data.responseText)

        if data.keys.length == 0
          if $(".processing").length > 0
            console.log 'last diff ==========================================='
            console.log arrayDiff( ids, data.keys)
            console.log 'last diff ==========================================='

        else
          for i in data.keys
            setTimeout(( -> refresh_image(1000, data.assets[i], i)), 1000)

refresh_image = (refresh_rate, src, id) ->
  setTimeout(( ->
          $(".processing[id=#{id}]").attr('src', src)
          $(".processing[id=#{id}]").removeClass('processing')
        ), 5000)

$(document).ready ->


    refresh_loop = (refresh_rate) ->
        console.log(refresh_rate)
        get_images()
        setTimeout((-> refresh_loop(refresh_rate) if $('.processing').length > 0), refresh_rate)


    refresh_rate = 2000
    setTimeout((-> refresh_loop(refresh_rate)), refresh_rate)
