$(document).ready ->
  
  $(document).keyup (e) ->
    $('#modal_carousel').modal('hide')  if e.keyCode is 27
  
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
              mag = $('.carousel-inner')
              item = $(document.createElement('div')).addClass('item')
              
              small = new Image
              small.src = image_src
              small.width = 900
              
              large = $(document.createElement('div')).addClass('large')
              # large.css('background', "url('#{image_src.replace('carousel','magnify')}') no-repeat")
              
              item.append small
              item.append large
              mag.append item

            $($('.carousel-inner .item')[0]).addClass('active')
            $('#myCarousel').carousel('pause')
            $('#modal_carousel').modal('show')
            if $('.carousel-inner .item').size() > 1
              $('.carousel-control.left').show()
              $('.carousel-control.right').show()
            else
              $('.carousel-control.left').hide()
              $('.carousel-control.right').hide()

      else if $(@).parents('.object').data('object') == 'elements'
        point_id = $(@).parents('.object').data('id')
        
        $.ajax
          url: "/points/#{point_id}/assets"
          success: (resp) ->
            console.log resp

            for image of resp.point
              mag = $('.carousel-inner')              
              id = image
              item = $(document.createElement('div')).addClass('item')

              image_src = resp.point[image]

              small = new Image
              small.src = image_src
              large = $(document.createElement('div')).addClass('large')
              # large.css('background', "url('#{image_src.replace('carousel','magnify')}') no-repeat")
                 
              item.append small
              item.append large
              mag.append item

              

              # $('.carousel-inner').append("<div class='item'><img src='#{image_src}'><button class='btn btn-alert carousel-delete' data-point=#{object_id} data-id=#{id}>Удалить</div>")
              $('')

              mag.find('.item').first().addClass('active')
            $('#myCarousel').carousel('pause')
            $('#modal_carousel').modal('show')
            
            $(document).keydown (e) ->
              $('#modal_carousel').modal('hide')  if e.keyCode is 27
            
            if $('.carousel-inner .item').size() > 1
              $('.carousel-control.left').show()
              $('.carousel-control.right').show()
            else
              $('.carousel-control.left').hide()
              $('.carousel-control.right').hide()


      else 
        console.log 'nothing'
    else
      element = $(@)
      report_id = $('#report.container').attr('report')
      $.ajax
        url: "/reports/#{report_id}/assets"
        success: (resp) ->
          
          first_image = resp[element.attr('id')]
          $('.carousel-inner').empty()
          delete resp[element.attr('id')]
          
          mag = $('.carousel-inner')          
          mag.append("<div class='item active'><img width='900' src='" + first_image + "'><div class='large'></div></div>")
          mag.find('.item.active .large').css('background', "url('/assets/loading.gif') no-repeat")
          
          

          
          for image of resp
            item = $(document.createElement('div')).addClass('item')
            
            small = new Image
            small.src = resp[image]
            small.width = 900
            
            large = $(document.createElement('div')).addClass('large')
            large.css('background', "url('/assets/loading.gif') no-repeat")
            
            item.append small
            item.append large
            mag.append item

          $('#myCarousel').carousel('pause')
          $('#modal_carousel').modal('show')
          
          if $('.carousel-inner .item').size() > 1
            $('.carousel-control.left').show()
            $('.carousel-control.right').show()
          else
            $('.carousel-control.left').hide()
            $('.carousel-control.right').hide()      


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

  $('#magnify').live 'click', ->
    el = $('#magnify')
    if el.data('magnify') == true
      $('.magnify').off('mousemove')
      $('.large').hide
      el.data('magnify', false)
      el.css('border-color', 'white')
    else
      magnify()
      el.data('magnify', true)
      el.css('border-color', 'gold')

  
  $('.carousel-control.left, .carousel-control.right').click ->
      el = $('#magnify')
      $('.magnify').off('mousemove')
      $('.large').hide
      el.data('magnify', false)
      el.css('border-color', 'white')
      window.native_width = 0
      window.native_height = 0
       