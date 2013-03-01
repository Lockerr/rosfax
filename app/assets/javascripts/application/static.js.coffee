#= require lib/masked
#= require lib/spin.min
#= require lib/spin
#= require jquery-ui
#= require lib/jquery.ui.datepicker-ru


jQuery.fn.forceNumeric = ->
  @each ->
    $(this).keydown (e) ->
      key = e.which or e.keyCode
      return true  if not e.shiftKey and not e.altKey and not e.ctrlKey and key >= 48 and key <= 57 or key >= 96 and key <= 105 or key is 8 or key is 9 or key is 13 or key is 35 or key is 36 or key is 37 or key is 39 or key is 46 or key is 45
      false


$(document).ready ->
  
  $('.hide_unchecked').click ->
    $('.unchecked').toggle(500)


  $.mask.definitions['~'] = "[AАBВСCEЕHНKКMМOОPРTТXХYУ]"
  
  $('input#report_car_gov_number').mask("~ 999 ~~ 99?9", {upcase: true})
  $('input#profile_phone').mask("+7(999) 999 99 99")
  $('input#report_car_vin').mask("*** ****** ****9999",{upcase: true})
  $('input#report_car_buyer_phone, input#report_car_seller_phone').mask("+7(999) 999 99 99")
  $('input#report_car_price').forceNumeric()
  
  $('.processing').parent().spin()

  $(' .nav-tabs.first li').click ->
    appendUploader($("#{$(@).find('a').attr('href')}.tab-pane .nav-tabs li.active a").first().attr('href'))

  $(' .nav-tabs.second li').click ->
    appendUploader($(@).find('a').attr('href'))

  $( ".pick_date" ).datepicker({showOn: ".add-on",changeMonth: true,changeYear: true})

  $('.add-on').click ->
    $(@).parent().find('input').datepicker('show')

  $.each $('.tab-content.second'), ->
    $(this).children().first().addClass('active')
  $.each $('.nav-tabs'), ->
    $(this).children().first().addClass('active')

  $('.move_to_top').click ->
    $(document).scrollTop(0)