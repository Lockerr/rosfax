$(document).ready ->
  $('.radio *').removeClass('active')
  $('.radio *').live 'click', ->

    element = $(@)
    object = element.parents('.object')
    console.log object.data()
    change = element.data().change
    console.log change
    
    if element.hasClass('btn-primary')
      element.toggleClass('btn-primary')
      object.data(change, null)
      console.log 'change to _'
    else
      element.parent().find('*').removeClass('btn-primary')
      element.toggleClass('btn-primary')
      change = element.data().change
      object.data(change, element.data(change))

    console.log object.data()
    console.log '--------------------------'



    place   = element.data('place')
    section = element.data('section') 
    store_point(object)  
    
    # span = $("a[href='##{section[0]}#{section}'] span")
    # span = $("a[href='##{place}'] span") if span.length == 0
    # console.log span
    # diggits = span.text().replace(/\s/g, '').split(/\D/)
    
    # tab = $(".tab-pane##{section[0]}#{section}")
    # tab = $(".tab-pane##{place}") if tab.length == 0

    # value   = tab.find('.btn-primary').size()
    # span.text("#{value}/#{diggits[1]}")
