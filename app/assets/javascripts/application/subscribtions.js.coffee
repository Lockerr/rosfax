$ ->
  $('.subscription_filter_countries_').click ->
    console.log 'click'
    $(@).parent().parent().find('.span9 .btn').click()

  $("input[name='subscription\[filter\]\[brands\]\[\]']").change ->
    if $(this).is(':checked')
      $('#filtered-models').append "<span value='#{this.value}'class='fltered-car label label-important'>#{this.value}</span><br/>"
    else
      $("span[value='#{this.value}']").remove()


#  car = JST['templates/report_filtered_horizontal']
#
#  html = car
#    mark_model: 'Mark Model'
#    image_src: '/system/assets/data/000/000/983/thumb/IMG_1899.jpg?1360834673'
#    price: '100'
#    year: 2005
#    mileage: 100500
#    transmission: 'автомат'
#    city: 'Челябинск'
#
#  $('.rendered_reports').append html
#
