$ ->
  $('.feedback').mouseenter(->
    
    $('.alert').toggleClass('alert-success').toggleClass('alert-error')
  ).mouseleave ->
    $('.alert').toggleClass('alert-success').toggleClass('alert-error')

  $('.feedback').click ->
    $('.feedback-modal').modal('show')