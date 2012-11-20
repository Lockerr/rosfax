@scroll_logo = ->
  if $(".main-lines-1").css('display') == 'none'
    to_show = $(".main-lines-1")
    to_hide = $('.main-lines-2')
  else
    to_show = $(".main-lines-2")
    to_hide = $('.main-lines-1')

  to_hide.hide "slide",
    direction: "right"
  , 1500

  setTimeout(( ->
    to_show.show "slide",
      direction: 'left'
    , 1500)
  , 1600)

$(document).ready ->
  $('a[href="' + document.location.pathname + '"]').parent().addClass('active')
  scroll_forever = ->
    scroll_logo()
    setTimeout(( -> scroll_forever()), 7000)

  setTimeout(( -> scroll_forever()), 7000)
  
  $('#report_car_mark_model').change ->
    $(@).val($('#report_car_mark_model').data('models')[$(@).val()][1])
  
  $('.main-input').change ->
    $.ajax
      url: "/models/#{document.models[$('.main-input').val()]}/index_block"
      complete: (data) ->
        $('.selected-models').append(data.responseText)
        window.selected_models ||= []
        window.selected_models.push  document.models[$('.main-input').val()]
        $('.main-input').val('')

  $('.line').click ->
    scroll_logo()

  $('.main-search img').click ->
    arr = []

    $.each $('.alert'), ->
      arr.push this.id

    console.log arr
    window.location.href = "/reports/models/?ids=#{arr}"


