loader = (image_object) ->
  $(image_object).load ->
    window.native_width = image_object.width
    window.native_height = image_object.height
    $('.item.active .large').css('background', "url('#{image_object.src}') no-repeat")
    $('.item.active .large').activity(false)

  $(image_object).onload = ->
    window.native_width = 0
    window.native_height = 0    

@magnify = ->
  
  $(".magnify").mouseleave (e) ->
    large = $('.large').hide()

  $(".magnify").mousemove (e) ->
    small = $('.item.active img')
    large = $('.item.active .large')
   
    if large.css('background-image').split(/\W/).reverse()[2] == "loading"
        
      image_object = new Image()
      src = small.attr('src')
      
      unless large.attr('unactive') == 'true'
        large.activity({width: 13, space: 40, segments: 20, opacity: 1/100, length: 80})
        large.attr('unactive', true)

      loader(image_object)
      
      image_object.src = src.replace(/^url\(["']?/, '').replace(/["']?\)$/, '').replace('carousel','magnify')

      magnify_offset = $(this).offset()
      mx = e.pageX - magnify_offset.left
      my = e.pageY - magnify_offset.top

      if mx < $(this).width() and my < $(this).height() and mx > 0 and my > 0
        large.fadeIn 100
      else
        large.fadeOut 100
      if large.is(":visible")
        
        

        px = mx - large.width() / 2
        py = my - large.height() / 2
        
        large.css
          left: px
          top: py
    else
      loader(image_object)

      magnify_offset = $(this).offset()
      mx = e.pageX - magnify_offset.left
      my = e.pageY - magnify_offset.top

      if mx < $(this).width() and my < $(this).height() and mx > 0 and my > 0
        large.fadeIn 100
      else
        large.fadeOut 100
      if large.is(":visible")
        
        

        px = mx - large.width() / 2
        py = my - large.height() / 2
        
        large.css
          left: px
          top: py
      
      if window.native_width and window.native_height
        rx = Math.round(mx / small.width() * native_width - large.width() / 2) * -1
        ry = Math.round(my / small.height() * native_height - large.height() / 2) * -1
        bgp = rx + "px " + ry + "px"

        large.css('background-position', bgp)

        


