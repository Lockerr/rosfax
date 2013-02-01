#= require jquery.min
#= require jquery_ujs
#= require twitter/bootstrap

$(document).ready ->

  $('.free').live 'mouseenter', ->
    $(@).find('.alert').fadeIn(200)
    $(@).find('.alert').addClass('active')
  $('.free').live 'mouseleave', ->
    $(@).find('.alert').fadeOut(200)
    $(@).find('.alert').removeClass('active')

  $('.free').live 'click', ->
    if $('#move_schedule.btn.active').length > 0
      console.log 'put'
      $.ajax
        type: 'put'
        url: "/schedules/#{$('.schedule').attr('id')}.json"
        data: {schedule:{time: $(@).data('time'), date: $(@).data('date')}}
        success: ->
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
        type: 'put'
        url: "/schedules/#{$('.schedule').attr('id')}/block.json"
        data: {schedule:{time: $(@).data('time'), date: $(@).data('date')}}


    else if $('.container.schedule').length == 0

      $.ajax
        type: 'get'
        url: '/schedules/new.js'
        data: {schedule:{time: $(@).data('time'), date: $(@).data('date'), company: $(@).data('company')}}

  $('input[name=city]').live 'change', ->

    $.ajax
      type: 'get'
      url: "/companies.js?city=#{$(@).val()}"
      $('.container#scheduler').empty()

  $('input[name=center]').live 'change', ->
    $('.container#scheduler').empty()
    city = $('input[name=city]').val()
    center = $('input[name=center]').val()
    $.ajax
      type: 'get'
      url: "/schedules.js?city=#{city}&center=#{center}"
      complete: (data) ->
        $('.container#scheduler').append(data.responseText)
        $('.container#scheduler').show()

  $('#schedule_phone').live 'change', ->
    $('.btn[disabled=disabled]').removeAttr('disabled')

jQuery ($) ->
  $(".select").each (i, e) ->
    unless $(e).data("convert") is "no"
      $(e).hide().removeClass "select"
      current = $(e).find(".option.selected").html() or "&nbsp;"
      val = $(e).find(".option.selected").data("value")
      name = $(e).data("name") or ""
      $(e).parent().append "<div class=\"btn-group\" id=\"select-group-" + i + "\" />"
      select = $("#select-group-" + i)
      select.html "<a class=\"btn " + $(e).attr("class") + "\" type=\"button\">" + current + "</a><a class=\"btn dropdown-toggle " + $(e).attr("class") + "\" data-toggle=\"dropdown\" href=\"#\"><span class=\"caret\"></span></a><ul class=\"dropdown-menu from-selector\"></ul><input type=\"hidden\" value=\"" + val + "\" name=\"" + name + "\" id=\"" + $(e).attr("id") + "\" class=\"" + $(e).attr("class") + "\" />"
      $(e).find(".option").each (o, q) ->
        select.find(".dropdown-menu").append "<li><a href=\"#\" data-value=\"" + $(q).data("value") + "\">" + $(q).html() + "</a></li>"
      $(e).remove()

    $(".dropdown-menu.from-selector a").die 'click'
    $(".dropdown-menu.from-selector a").live 'click', (e)->

      select = $(@).parents('.btn-group')
      select.find("input[type=hidden]").val($(this).data("value"))
      select.find(".btn:eq(0)").html $(this).html()
      select.find("input[type=hidden]").trigger('change')
      e.preventDefault()