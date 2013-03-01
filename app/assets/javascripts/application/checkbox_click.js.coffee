$(document).ready ->
  if source = $('#report.container').attr('source')
    data= JSON.parse(source)

    for checkbox in $('.checkbox')
      button = $(checkbox)
      boxlist = data[button.data('attribute')]

      attribute = button.data('attribute')
      place = button.data('place')
      change = button.data('change')

      if attribute && data[attribute]
        if place && data[attribute][place]
          if parseInt(data[attribute][place][change]) == button.data(change)
            button.addClass('btn-primary')
          else if data[attribute][place][change] == button.data(change)
            button.addClass('btn-primary')
        else if data[attribute][change] == button.data(change)
          button.addClass('btn-primary')
      else if data[attribute] == button.data(attribute)
        button.addClass('btn-primary')

  $('.checkbox').click ->
    update_object(@)
    store_report()

    $('.all_wheels').trigger('change') if $('.all_wheels').prop('checked')
