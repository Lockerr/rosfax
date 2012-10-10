$(document).ready ->
  $('.radio *').removeClass('active')
  $('.radio *').live 'click', ->

    $(@).parent().find('*').removeClass('btn-primary')
    $(@).toggleClass('btn-primary')
    place = $(@).data('place')
    
    section = $(@).data('section')    
    span = $("a[href='##{section[0]}#{section}'] span")
    span = $("a[href='##{place}'] span") if span.length == 0
    console.log span
    diggits = span.text().replace(/\s/g, '').split(/\D/)
    
    tab = $(".tab-pane##{section[0]}#{section}")
    tab = $(".tab-pane##{place}") if tab.length == 0

    value = tab.find('.btn-primary').size()
    span.text("#{value}/#{diggits[1]}")
