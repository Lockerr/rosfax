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
  
  $('.processing_image').spin()
    
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
        setTimeout(( -> refreshing = false), 1000)
        if data.keys.length == 0
          if $(".processing").length > 0
            true
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
          image.parent().spin(false)
          image.parent()
          

          $.each $('.photos img'), ->
            this.ondragstart = (event) ->
              window.dragged = event.target
        ), 5000)

@update_object = (object) ->
  container = $('#report.container')

  element       = $(object)
  change        = element.data('change')
  attribute     = element.data('attribute')
  place         = element.data('place')

  if attribute && place && change
    data             = container.data(attribute) || {}

    data[place] ||= {}
    data[place][change] = element.data(change)

  else if attribute && change
    data = container.data(attribute) || {}
    data[change] = element.data(change)

  else if attribute
    data = element.data(attribute)

  container.data(attribute, data)

@store_report = ->
  data = $('#report.container').data()
  report = new Object

  $.ajax
    type: 'PUT'
    data: {report: data}
    url: '/reports/' + $('#report.container').attr('report')

$(document).ready ->
  $('.photos').bind 'custom_change', ->

    unless refreshing
      refresh_loop = (refresh_rate) ->
          console.log("inside photos refresh loop #{refresh_rate}")
          get_images()

          setTimeout((-> refresh_loop(refresh_rate) if $('.processing').length > 0), refresh_rate)

      refresh_rate = 5000
      setTimeout((-> refresh_loop(refresh_rate)), refresh_rate)

  $('.photos').trigger 'custom_change'
  # unless window.location.hostname == '0.0.0.0' || window.location.hostname == "partners.lvh.me"
  # eye_fi_loop = ->
  #     update_eye_fi()
  #     setTimeout((-> eye_fi_loop(5000)), 5000)
  # setTimeout((-> eye_fi_loop(5000)), 5000)
jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()

  $('#report_table tr').click ->
    window.location = "/reports/#{$(@).data().report}/edit"


$(document).bind "drop dragover", (e) ->
  e.preventDefault()


$("body").on "touchstart.dropdown", (e) ->
  e.stopPropagation()
  e.preventDefault()


logger = ->
  oldConsoleLog = null
  pub = {}
  pub.enableLogger = enableLogger = ->
    return  unless oldConsoleLog?
    window["console"]["log"] = oldConsoleLog

  pub.disableLogger = disableLogger = ->
    oldConsoleLog = console.log
    window["console"]["log"] = ->

  pub
$(document).ready ->

  $('#move_schedule').click ->
    $('#schedule_block').removeClass('active')
  $('#schedule_block').click ->
    $('#move_schedule').removeClass('active')

  $('.blocked').live 'click', ->
    that = $(@)
    if $('#schedule_block.btn.active').length > 0
      $.ajax
        async: true
        type: 'delete'
        url: "/blocks/#{$(@).data('id')}.json"
        success: ->
          alert = that.find('.alert')
          alert.addClass('alert-success')
          alert.removeClass('alert-disabled')
          alert.html('Свободно')
          that.removeClass('blocked')
          that.addClass('free')
          alert.hide()

  $('.free').live 'click', ->
    that = this
    if $('#move_schedule.btn.active').length > 0
      console.log 'moving schedule'
      $.ajax
        type: 'put'
        url: "/schedules/#{$('.schedule').attr('id')}.json"
        data: {schedule:$(@).data()}
        success: ->
          console.log 'moving return success'
          free_alert = $(that).find('.alert')
          free = $(that)
          booked_alert = $('.alert-error')
          booked = booked_alert.parent()
          booked.append(free_alert)
          booked.removeClass('booked')
          booked.addClass('free')
          booked_alert.remove()
          free.html(JST['templates/calendar_booked'])
          free.removeClass('free')
          free.addClass('booked')
    else if $('#schedule_block.btn.active').length > 0
      $.ajax
        type: 'post'
        async: true
        url: "/schedules/#{$('.schedule').attr('id')}/blocks.js"
        data: {block:$(@).data()}


    else if $('.container.schedule').length == 0

      $.ajax
        type: 'get'
        url: '/schedules/new.js'
        data: {schedule:$(@).data()}

  $("input[name='xx[city]']").live 'change', ->

    $.ajax
      type: 'get'
      url: "/companies.js?city=#{$(@).val()}"
      $('.container#scheduler').empty()

  $("input[name='xx[center]']").live 'change', ->
    $('.container#scheduler').empty()
    city = $('input[name=city]').val()
    center = @.value
    $.ajax
      type: 'get'
      url: "/schedules.js?city=#{city}&center=#{center}"
      complete: (data) ->
        $('.container#scheduler').append(data.responseText)
        $('.container#scheduler').show()

  $('#schedule_phone').live 'change', ->
    if @.value.match /[\+\d\(\)\ ]{17}/
      $('.btn[disabled=disabled]').removeAttr('disabled')
    else
      $('#schedule_phone').parents('form').find('.btn').attr('disabled', '')

  $('#schedule_phone').live 'keyup', (e) ->
    if @.value.match /[\+\d\(\)\ ]{17}/
      $('.btn[disabled=disabled]').removeAttr('disabled')
    else
      $('#schedule_phone').parents('form').find('.btn').attr('disabled', '')

  $('.feedback').live 'click', ->
    $('.feedback-modal').modal('show')





