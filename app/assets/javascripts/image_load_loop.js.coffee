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

  
  report_id = report_id = $('#report.container').attr('report')
  
  $.ajax
    url: "/reports/#{report_id}/assets"
    success: (resp) ->
      document.resp = resp
      document.loading = []
      document.load_large = []
      
      for src in resp
        document.loading.push src.src
        document.load_large.push src.src
      
      load_image()
  
      if src = document.load_large[0]
        document.load_large.reverse().pop()
        document.load_large.reverse()
        image = new Image
        image.src = src.replace('carousel','magnify')      

  
