#= require jquery
#= require jquery_ujs
#= require  twitter/bootstrap
#= require ./app/index
#= require ./app/feedback

$ ->
  $('td:not(.actions)').click ->
    console.log 'clickl'
    console.log $(@)
    window.location = "/reports/#{$(@).parent().data().report}/edit"