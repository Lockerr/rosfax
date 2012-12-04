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


@store_point = (element) ->
  data = element.data()

  if data.id
    $.ajax
      url: "/points/#{data.id}.json"
      type: 'PUT'
      data: {point: data}
  else
    $.ajax
      url: '/points.json'
      type: 'POST'
      data: {point: data}
      success: (response) ->
        $(element).parents('.object').data('id', response.id)
        $(element).data('id', response.id)
        $(element).siblings().data('id', response.id)
        if elements = $(element).find('.btn')
          for element in elements
            $(element).data('id', response.id)




get_images = ->
  $('.processing_image').activity()
  console.log 'refreshing is set to true'
  refreshing = true
  ids = $.map($(".processing"), (n, i) -> n.id ).unique()
  if ids.length > 0
    console.log ids
    size = 
    $.ajax
      url: '/assets/processed'
      data: {assets: ids, size: 'thumb'}
      complete: (data) ->
        data = $.parseJSON(data.responseText)
        console.log 'refreshing is set to false'
        setTimeout(( -> refreshing = false), 1000)

        if data.keys.length == 0
          if $(".processing").length > 0
            console.log 'last diff ==========================================='
            console.log arrayDiff( ids, data.keys)
            console.log 'last diff ==========================================='

        else
          for i in data.keys
            setTimeout(( -> refresh_image(5000, data.assets[i], i)), 5000)
  else
    refreshing = false

refresh_image = (refresh_rate, src, id) ->
  setTimeout(( ->
          image = $(".processing[id=#{id}]")
          image.attr('src', src)
          image.removeClass('processing')
          image.parent().removeClass('processing_image')
          image.parent().activity(false)
          image.parent()
          

          $.each $('.photos img'), ->
            this.ondragstart = (event) ->
              window.dragged = event.target
        ), 5000)

@update_object = (object) ->
  container = $('#report.container')

  element       = $(object)
  change        = element.data('change')
  attribute      = element.data('attribute')
  place           = element.data('place')

  if attribute && place && change
    data             = container.data(attribute) || {}

    data[place] ||= {}
    data[place][change] = element.data(change)

    console.log "Changing #{attribute}[#{place}][#{change}] = #{data[place][change]} to"


  else if attribute && change
    data = container.data(attribute) || {}
    data[change] = element.data(change)

    console.log "Changing #{attribute}[#{change}] = #{data[change]} to"
  else if attribute
    data = element.data(attribute)

    console.log "Changing #{attribute}= #{element.data(attribute)} to"

  container.data(attribute, data)
  

# @store_attribute(element) = ->
#   data = $('#report.container').data()

@store_report = ->
  data = $('#report.container').data()
  report = new Object

  $.ajax
    type: 'PUT'
    data: {report: data}
    url: '/reports/' + $('#report.container').attr('report')

$(document).ready ->

  
 
  $('.photos').bind 'custom_change', ->
      
    console.log "refreshing: #{refreshing}"
    unless refreshing
    
      refresh_loop = (refresh_rate) ->
          console.log("inside photos refresh loop #{refresh_rate}")
          get_images()

          setTimeout((-> refresh_loop(refresh_rate) if $('.processing').length > 0), refresh_rate)

      refresh_rate = 5000
      setTimeout((-> refresh_loop(refresh_rate)), refresh_rate)

  $('.photos').trigger 'custom_change'
  unless window.location.hostname == '0.0.0.0' || window.location.hostname == "partners.lvh.me"
    eye_fi_loop = ->
        update_eye_fi()
        setTimeout((-> eye_fi_loop(5000)), 5000)
    setTimeout((-> eye_fi_loop(5000)), 5000)

  $('.feedback').mouseenter(->
    
    $('.alert').toggleClass('alert-success').toggleClass('alert-error')
  ).mouseleave ->
    $('.alert').toggleClass('alert-success').toggleClass('alert-error')