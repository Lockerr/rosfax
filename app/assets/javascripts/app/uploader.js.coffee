$(document).ready ->
  $('#fileupload').fileupload
    url: "/reports/#{$('.container#report').attr('report')}/assets"
    type: 'post'
    method: 'post'
    dataType: 'json'
    autoUpload: true
    dropZone: $('#fileupload')

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
      $('.fileinput-button span').text('Загрузка...')
    done: (e, data) ->
      img = $(new Image)
      window.result = data.result

      img.attr
        id: data.result.id
        src: data.result.pic_path
        draggable: true
        style: 'cursor: move'
        class: 'processing'

      image = $("<div class='image'></div>")
      image.append img

      $('.photos .tab-pane').prepend image
      $('.processing').parent().spin()
      $('.photos').trigger('custom_change')
      window.assing_drops()
      $('.fileinput-button span').text('Перетащить сюда файлы...')



  $(".file-upload").each ->
    $(@).fileupload
      dropZone: $(@)
      type: 'post'
      method: 'post'
      dataType: 'json'
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
        $(@).parent().parent().find('.thumb').spin()
        $(this).fileupload("process", data).done ->
          data.submit()
      done: (e, data) ->
        console.log data.result
        object = $(@).parent().parent().find('.object_drop')
        img = object.find('img');
        img.addClass('processing');
        img.parent().spin();
        img.attr('id', data.result.id);
        $('.photos').trigger('custom_change');
        thumb = img.parent();
        thumb.data('attachable_id', object.data('object_id'));
        thumb.data('attachable_type', 'Point');
        thumb.css('color','green')
        thumb.spin()