$(document).ready ->
  $('.radio *').removeClass('active')
  $('.radio *').live 'click', ->
    $(@).parent().find('*').removeClass('btn-primary')
    $(@).toggleClass('btn-primary')
    place = $(@).data('place')
    a = $("a[href='##{place}']")
    tab = a.text().split(/\s/).unique()
    unless $.inArray('',tab) == -1
        tab.splice($.inArray('', tab),1)
    console.log tab
    diggits = tab[1].split(/\D/)
    console.log diggits
    value = $(".tab-pane##{place}").find('.btn-primary').size()
    a.text("#{tab[0]} #{value}/#{diggits[1]}")
