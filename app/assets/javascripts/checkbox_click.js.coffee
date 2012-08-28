$(document).ready ->

  container = $('#report.container')
  $('.checkbox').click ->
    element      = $(@)
    change       = element.data('change')
    attribute    = element.data('attribute')
    place        = element.data('place')
    data         = container.data(attribute) || {}
    data[place] ||= {}
    data[place][change] = element.data(change)

    container.data(attribute, data)
    console.log "checkbox container =>"
    console.log container.data()
    store_report()
    $('.all_wheels').trigger 'change'