$(document).ready ->
  
  $(document).keyup (e) ->
    $('#modal_carousel').modal('hide')  if e.keyCode is 27
  
  $(".thumb").live 'click', ->
    console.log 'thumb click'
    element = $(@)
    data = element.data()
    window.element = element
    if data.attachable_type
      object = data.attachable_type.toLowerCase()      
      $.ajax
        url: "/#{object}s/#{data.attachable_id}/assets"
        data: data
        success: (resp) ->
          
          mag = $('.carousel-inner')
          mag.empty()
          for asset in resp
            item = $(document.createElement('div')).addClass('item')
            item.attr('id',"asset_id_#{asset.id}")

            small = new Image
            small.src = asset.src
            small.width = 900
            
            large = $(document.createElement('div')).addClass('large')
            large.attr('loading', 'true')
                        
            item.append small
            item.append large
            mag.append item
          
          $($(".carousel-inner .item")).last().addClass('active')
          $('#myCarousel').carousel('pause')
          $('#modal_carousel').modal('show')
          if $('.carousel-inner .item').size() > 1
            $('.carousel-control.left').show()
            $('.carousel-control.right').show()
          else
            $('.carousel-control.left').hide()
            $('.carousel-control.right').hide()
        
        error: (resp) -> 
          console.log resp
  

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
       