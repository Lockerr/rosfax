#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require jquery-ui
#= require_self
#= require_tree ./lib
#= require ./app/app
#= require ./app/static
#= require ./app/radio
#= require ./app/new_drop
#= require ./app/magnify
#= require ./app/links
#= require ./app/input-file
#= require ./app/image_load_loop
#= require ./app/feedback
#= require ./app/drop_down
#= require ./app/checkbox_click
#= require ./app/carousel
#= require ./app/reports




$("body").on "touchstart.dropdown", ".dropdown-menu", (e) ->
  e.stopPropagation()
  e.preventDefault()

logger = ->
  oldConsoleLog = null
  pub = {}
  pub.enableLogger = enableLogger = ->
    return  unless oldConsoleLog?
    window["console"]["log"] = oldConsoleLog

  pub.disableLogger = disableLogger = ->
    oldConsoleLog = console.log
    window["console"]["log"] = ->

  pub
