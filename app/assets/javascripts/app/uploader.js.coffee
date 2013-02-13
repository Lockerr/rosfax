$(document).ready ->
  console.log 'document in uploader ready'
  $('#fileupload').fileupload
    # acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i
    url: '/reports/70/assets'
    type: 'post'
    method: 'post'
    # resizeMaxWidth: 800
    # resizeMaxHeight: 200
    autoUpload: true
    process: [
      action: 'load'
      fileTypes: /^image\/(gif|jpe?g|png)$/
      maxFileSize: 20000000
    ,

      action: 'resize'
      maxWidth: 1800
      maxHeight: 1200
    ,
      action: 'save'

    ]
    add: (e, data) ->
      $(this).fileupload("process", data).done ->
      
        data.submit()
        console.log data
        console.log e
        $.each data.files, (index, file) ->
          console.log file.name
    done: (e, data) ->
      $.each data.result.files, (index, file) ->
        console.log file.name
        # $("<p/>").text(file.name).appendTo document.body
