#= require jquery.min
#= require jquery_ujs
#= require twitter/bootstrap
#= require lib/masked
#= require lib/select2dropdown

$(document).ready ->

  $('.free').live 'mouseenter', ->
    $(@).find('.alert-success').fadeIn(200)
    $(@).find('.alert-success').addClass('active')
  $('.free').live 'mouseleave', ->
    $(@).find('.alert-success').fadeOut(200)
    $(@).find('.alert-success').removeClass('active')

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
    if $('#move_schedule.btn.active').length > 0
      console.log 'moving schedule'
      $.ajax
        type: 'put'
        url: "/schedules/#{$('.schedule').attr('id')}.json"
        data: {schedule:$(@).data()}
        success: ->
          console.log 'moving return success'
          free = $('.alert-success.active').parent()
          free_alert = $('.alert-success.active')
          booked_alert = $('.alert-error')
          booked = booked_alert.parent()
          booked.append(free_alert)
          booked.removeClass('booked')
          booked.addClass('free')
          free.append(booked_alert)
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



