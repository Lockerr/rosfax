$(document).ready ->
  data= JSON.parse($('#report.container').attr('source'))

  for checkbox in $('.checkbox')
    button = $(checkbox)
    boxlist = data[button.data('attribute')]

    if boxlist[button.data('place')]

      if parseInt(data[button.data('attribute')][button.data('place')][button.data('change')]) == button.data(button.data('change'))
        button.addClass('btn-primary')
      else if data[button.data('attribute')][button.data('place')][button.data('change')] == button.data(button.data('change'))
        button.addClass('btn-primary')

  $('.checkbox').click ->
    update_object(@)
    store_report()

    $('.all_wheels').trigger('change') if $('.all_wheels').prop('checked')