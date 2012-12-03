$ ->
  $('.file-upload').change ->
    console.log this.value
    document.q = this
    data = new FormData()
    form = $(this).parent()

    # jQuery.each $(this)[0].files, (i, file) ->
    #   data["file-" + i] = file
    # file = this.files[0]
    # for index of this.files
    #   data.append "file-#{index}", this.files[index]
    #   console.log this.files[index]
    
    console.log data
    document.qw = data
    
    fd = new FormData()
    

    jQuery.each $(this)[0].files, (i, file) ->
      fd.append "file-#{i}", file
    
    console.log fd

    $.ajax
      url: "/points/#{form.data().id}/assets.js"
      data: fd
      processData: false
      contentType: false
      type: "POST"
      
