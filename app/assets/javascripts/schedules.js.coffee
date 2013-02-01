#= require jquery.min
#= require jquery_ujs
#= require twitter/bootstrap

$(document).ready ->

  $('.free').on 'mouseenter', ->
    $(@).find('.alert').fadeIn(200)
  $('.free').on 'mouseleave', ->
    $(@).find('.alert').fadeOut(200)

  $('.free').on 'click', ->
    $.ajax
      type: 'get'
      url: 'schedules/new.js'
      data: {schedule:{time: $(@).data('time'), date: $(@).data('date'), company: $(@).data('company')}}

  $('input[name=city]').on 'change', ->
    $.ajax
      type: 'get'
      url: "/companies.js?city=#{$(@).val()}"
      $('.container#scheduler').empty()

  $('input[name=center]').on 'change', ->
    $('.container#scheduler').empty()
    city = $('input[name=city]').val()
    center = $('input[name=center]').val()
    $.ajax
      type: 'get'
      url: "/schedules.js?city=#{city}&center=#{center}"
      complete: (data) ->
        $('.container#scheduler').append(data.responseText)
        $('.container#scheduler').show()

  $('#schedule_phone').on 'change', ->
    $('.btn[disabled=disabled]').removeAttr('disabled')



#!
# * Convert .select elements to Bootstrap Dropdown Group
# * Assumes jQuery and Bootstrap scripts already linked
# *
# * Expected markup:
# *
# *   <div id="someId" data-name="someName" class="select someClass">
# *     <div class="option selected" data-value="1"> Item 1 <i class="icon-ok"></i></div>
# *     <div class="option" data-value="2"> Item 2 <span>some html</span></div>
# *     <div class="option" data-value="3"> Item 3 <img src="little.img"></div>
# *   </div>
# *
# * Author: John Rocela 2012 <me@iamjamoy.com>
# * From: http://blog.iamjamoy.com/convert-select-boxes-to-a-fancy-html-dropdown
# *
# * Inspired by updates from Colin Faulkingham (https://gist.github.com/2320588)
# *                      and Frank Basti (http://jsfiddle.net/xuAQv/13)
# *
# * Modified: Ivan Novikov (http://github.com/NIA), Dec 2012
# * Changed: use classes on divs instead of select/option tags,
# *          thus allow arbitrary html inside options,
# *          propagate original element classes to buttons,
# *          fixed IE compatibility and rounded corners of first .btn,
# *          avoid using javascript: pseudo-protocol
# 
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

    $(".dropdown-menu.from-selector a").die('click')
    $(".dropdown-menu.from-selector a").live 'click', (e) ->
      select = $(@).parents('.btn-group')
      select.find("input[type=hidden]").val($(this).data("value")).change()
      select.find(".btn:eq(0)").html $(this).html()
      select.find("input[type=hidden]").trigger('selector_change')
      e.preventDefault()