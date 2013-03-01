$ ->

  $('.subscribtion_filter_countries_').click ->
    $(@).parent().parent().find('.span9 .btn').click()

  $("input[name='subscribtion\[filter\]\[brands\]\[\]']").change ->
    console.log "#{this.value} checked" if $(this).is(':checked')
    console.log "#{this.value} unchecked" unless $(this).is(':checked')
