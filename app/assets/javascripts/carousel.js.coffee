$(document).ready ->
  $(".thumb").live 'click', ->
    if $(@).parent().siblings().html() > 0

      $('#modal_carousel .item').remove()
      data = $(@).data()
      report_id = $('#report.container').data('id')

      url = "/reports/#{report_id}/assets"
      object_id = $(@).parents('.object').data('id')

      if data.place
        
        ajax_data = {attribute: data.attribute, place: data.place}
        $.ajax
          url: url
          data: ajax_data
          success: (resp) ->
            for image_src in resp
              $('.carousel-inner').append("<div class='item'><img src='" + image_src + "'></div>")

            $($('.carousel-inner .item')[0]).addClass('active')
            $('#myCarousel').carousel('pause')
            $('#modal_carousel').modal('show')
            if $('.carousel-inner .item').size() > 1
              $('.carousel-control.left').show()
              $('.carousel-control.right').show()
            else
              $('.carousel-control.left').hide()
              $('.carousel-control.right').hide()

      else if $(@).parents('.object').data('object') == 'element'
        point_id = $(@).parents('.object').data('id')
        
        $.ajax
          url: "/points/#{point_id}/assets"
          success: (resp) ->
            console.log resp

            for image of resp.point
              console.log image
              id = image
              image_src = resp.point[image]
              delete resp.points[image]

              $('.carousel-inner').append("<div class='item'><img src='#{image_src}'><button class='btn btn-alert carousel-delete' data-point=#{object_id} data-id=#{id}>Удалить</div>")
            for image of resp.points
              id = image
              image_src = resp.points[image]
              $('.carousel-inner').append("<div class='item'><img src='#{image_src}'><button class='btn btn-alert carousel-delete' data-point=#{object_id} data-id=#{id}>Удалить</div>")


            $($('.carousel-inner .item')[0]).addClass('active')
            $('#myCarousel').carousel('pause')
            $('#modal_carousel').modal('show')
            if $('.carousel-inner .item').size() > 1
              $('.carousel-control.left').show()
              $('.carousel-control.right').show()
            else
              $('.carousel-control.left').hide()
              $('.carousel-control.right').hide()

      else 
        console.log 'nothing'

  $('.carousel-delete').live 'click', ->
    data = $(@).data()
    $.ajax
      type: 'DELETE'
      url: "/points/#{data.point}/image/#{data.id}?size=thumb"
      success: (resp) =>
        console.log resp
        
        $(@).parent().remove()
        console.log $(@).parent()
        $('.carousel .item').first().addClass('active')
        thumb = $(".object[data-id='#{data.point}'] a")
        img = thumb.find('img')
        if thumb.siblings().html() > 1
          thumb.siblings().html(thumb.siblings().html() - 1)
          img.attr('id', resp[0])
          img.attr('src', resp[1])
        else
          thumb.siblings().html('0')
          img.attr('src',"http://s3-eu-west-1.amazonaws.com/rosfax/box.png")
          $('.carousel').parent().modal('hide')
        if $('.carousel-inner .item').size() > 1
          $('.carousel-control.left').show()
          $('.carousel-control.right').show()
        else
          $('.carousel-control.left').hide()
          $('.carousel-control.right').hide()
     