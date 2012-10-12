@magnify = ->
  native_width = 0
  native_height = 0
  $(".magnify").mouseleave (e) ->
    large = $('.large').hide()

  $(".magnify").mousemove (e) ->
    
    small = $('.item.active img')
    large = $('.item.active .large')
    if not native_width and not native_height
        
      image_object = new Image()
      src = large.css('background-image')
      image_object.src = src.replace(/^url\(["']?/, '').replace(/["']?\)$/, '');
      
      native_width = image_object.width
      native_height = image_object.height
    else

      magnify_offset = $(this).offset()
      mx = e.pageX - magnify_offset.left
      my = e.pageY - magnify_offset.top

      if mx < $(this).width() and my < $(this).height() and mx > 0 and my > 0
        large.fadeIn 100
      else
        large.fadeOut 100
      if large.is(":visible")
        
        rx = Math.round(mx / small.width() * native_width - large.width() / 2) * -1
        ry = Math.round(my / small.height() * native_height - large.height() / 2) * -1
        bgp = rx + "px " + ry + "px"

        px = mx - large.width() / 2
        py = my - large.height() / 2
        
        large.css
          left: px
          top: py
        
        large.css('background-position', bgp)
        


