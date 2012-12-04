#= require jquery
#= require jquery_ujs
#= require  twitter/bootstrap
#= require ./app/index
#= require ./app/feedback

$ ->
  $('td:not(.actions)').click ->
    console.log 'click'
    window.location = "/reports/#{$('td:not(.actions)').first().parent().data().report}/edit"