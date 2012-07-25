$(document).ready ->
  $('.radio *').removeClass('active')
  $('.radio *').live 'click', ->
    $(this).parent().find('*').removeClass('btn-primary')
    $(this).toggleClass('btn-primary')
