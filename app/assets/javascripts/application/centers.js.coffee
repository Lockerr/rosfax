$ ->
  $('#centers_cities a').click ->
    $.ajax
      type: 'get'
      url: "/centers.json?city_id=#{$(@).data('city_id')}"
      success: (data) ->
        $('#centers_list').empty()
        template = JST['templates/center']
        for center in data
          console.log data
          console.log center
          $('#centers_list').append(template(center[0]))


