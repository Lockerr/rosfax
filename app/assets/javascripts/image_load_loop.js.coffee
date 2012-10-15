 $(document).ready ->
  

  load_image = ->
    
    if src = document.loading[0]
      document.loading.reverse().pop()
      document.loading.reverse()
    
      image = new Image
  
      $(image).load ->
        load_image()
  
      image.src = src
    else
      load_large()
      
  
  load_large = ->
    if src = document.load_large[0]
      document.load_large.reverse().pop()
      document.load_large.reverse()
    
      image = new Image
  
      $(image).load ->
        load_large()
  
      image.src = src.replace('carousel','magnify')


  $.ajax
    url: "/reports/19/assets"
    success: (resp) ->
      document.loading = []
      document.load_large = []
      
      for src of resp
        document.loading.push resp[src]               
        document.load_large.push resp[src]
      
      load_image()
  
      if src = document.load_large[0]
        document.load_large.reverse().pop()
        document.load_large.reverse()
    
        image = new Image
        image.src = src.replace('carousel','magnify')      

  
