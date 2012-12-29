
$(document).ready ->
  
  $('.hide_unchecked').click ->
    $('.unchecked').toggle(500)


  $.mask.definitions['~'] = "[AАBВСCEЕHНKКMМOОPРTТXХYУ]"
  
  $('input#report_car_gov_number').mask("~ 999 ~~ 99?9", {upcase: true})
  $('input#profile_phone').mask("+7(999) 999 99 99")
  $('input#report_car_vin').mask("*** ****** ****9999",{upcase: true})
  $('input#report_car_buyer_phone, input#report_car_seller_phone').mask("+7(999) 999 99 99")
  
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

  $('.feedback').mouseenter(->
    $('.alert').toggleClass('alert-success').toggleClass('alert-error')
  ).mouseleave ->
    $('.alert').toggleClass('alert-success').toggleClass('alert-error')
