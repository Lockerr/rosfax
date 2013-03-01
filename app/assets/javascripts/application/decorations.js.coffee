$ ->
  $('#report_table tr, #schedules_table tr').hover (->
    $(@).find('td:not(.actions)').css('text-decoration', 'underline')
    $(@).find('.btn').show()
  ), ->
    $(@).find('td:not(.actions)').css('text-decoration', 'none')
    $(@).find('.btn').hide()

  $('.feedback').hover (->
    $('.alert').toggleClass('alert-success').toggleClass('alert-error')
  ), ->
    $('.alert').toggleClass('alert-success').toggleClass('alert-error')

  $('.free').live 'mouseenter', ->
    $(@).find('.alert-success').fadeIn(200)
    $(@).find('.alert-success').addClass('active')
  $('.free').live 'mouseleave', ->
    $(@).find('.alert-success').fadeOut(200)
    $(@).find('.alert-success').removeClass('active')