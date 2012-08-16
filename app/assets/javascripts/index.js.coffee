@scroll_logo = ->
  if $(".main-lines-1").css('display') == 'none'
    to_show = $(".main-lines-1")
    to_hide = $('.main-lines-2')
  else
    to_show = $(".main-lines-2")
    to_hide = $('.main-lines-1')

  to_hide.hide "slide",
    direction: "right"
  , 500

  setTimeout(( ->
    to_show.show "slide",
      direction: 'left'
    , 500)
  , 500)

$(document).ready ->
  scroll_forever = ->
    scroll_logo()
    setTimeout(( -> scroll_forever()), 7000)

  setTimeout(( -> scroll_forever()), 7000)

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


