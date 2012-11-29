
@appendUploader = (tab) ->
  tabs = ['#photo_exterior', '#photo_interior', '#photo_under_the_hood', '#photo_video', '#photo_other_photos' ]

  if tab in tabs
    $("#{tab}.row-fluid").append($('.uploader'))
    $('.uploader').show()

  if tab in ["#defects-exterior", "#defects-interior", "#defects-windows_and_lights", "#defects-powertrains", "#defects-chasis", "#defects-wheels", "#defects-electric", "#defects-liquids", "#defects-other", "#defects-video"]
    $('.defect').hide()
    $(".defect[data-category='#{tab.slice(9)}']").show()
    $(".row-fluid#{tab} .defects").append $(".defect[data-category='#{tab.slice(9)}']")
    $('#defects hr').remove()
    $('.defect').after('<hr/>')
    $(".row-fluid#{tab} .defects").prepend $('.add_defect')
    $(".row-fluid#{tab}").append($('.uploader'))
    $('.uploader').show()
  else if tab == '#defects-compiled'
    $('.defect').show()
    $(".defect[data-category='#{tab.slice(9)}']").show()
    $(".row-fluid#{tab} .defects").append $(".defect[data-category='#{tab.slice(9)}']")
    $('#defects hr').remove()
    $('.defect').after('<hr/>')
    $(".row-fluid#{tab} .defects").prepend $('.add_defect')
    $(".row-fluid#{tab}").append($('.uploader'))
    $('.uploader').show()



@store_defect = (defect) ->
  if defect.data().id
    update_defect(defect)
  else
    create_defect(defect)

@create_defect = (defect) ->
  # console.log defect.data('report_id')
  window.defect = defect
  $.ajax
    type: 'POST'
    data: {point: defect.data()}
    url: "/points.json"
    async: false
    success: (data) ->
      defect.data('id', data.id)
      defect.find('.drop').attr('object_id', data.id)

@update_defect = (defect) ->
  $.ajax
    type: 'PUT'
    data: {defect: defect.data()}
    url: '/reports/' + defect.data('report_id') + '/defects/' + defect.data().id + '.json'
    async: false

@assing_drops = ->
    droppable = $('.drop')
    $.each $('.drop'), ->

      this.ondrop  = (event) ->
        target = $(@)
        obj = window.dragged
        console.log "Dragged object id is #{obj.id}"
        event.preventDefault()
        event.dataTransfer.dropEffect = "copy"
        attribute = target.data().section

        

        report_id = $('#report.container').data('id')

        image = $(document.createElement('div'))
        image.addClass('thumb')
        image.attr('data-attribute', attribute)
        image.attr('data-place', $(@).data('place'))
        image.attr('style', 'cursor: pointer')

        target.find('a').html(image)
        target.find('.thumb').html(window.dragged)
        target.find('.btn').text(parseInt(target.find('.btn').text())+1)
        target.find('img').attr('style', '').prop('draggable', false)
        

        imgbox = $(".imgbox##{attribute}")

        if imgbox.find("##{obj.id}").size() == 0
          imgbox.append "<div class='thumbnail' style='width: 100px; float: left; margin-right: 5px; height: 67px'><div class='btn remove_asset btn-danger btn-mini' data-attribute = #{attribute} id='"+obj.id+"' style='position: relative; top: -20px; left: 80px'>x</div></div>"
          imgbox.width(imgbox.width()+ 116)
          new_image = $.clone(target.find('.thumb')[0])
          imgbox.find('.thumbnail').last().prepend(new_image)

        data = {asset: target.data()}
        console.log data
        if target.data().attachable_type == 'Report'
          $.ajax
            url: "/reports/#{report_id}/assets/#{obj.id}.json"
            data: data
            type: 'PUT'

        


$ ->

  $('#repor_car_mark_model').change ->
    console.log 'change'
  container = $('#report.container')

  if container.attr('source')
    container.data(JSON.parse($('#report.container').attr('source')))

  window.datas = container.data()

  report_id = $('#report.container').data('id')

  $(".upload").fileUploadUI
    uploadTable: $(".photos .tab-pane.uploading")
    downloadTable: $(".photos .tab-pane")
    buildUploadRow: (files, index) ->
      console.log "file: #{file} index: #{index}"
      file = files[index]

      $ "<tr><td>" + file.name + "</td>" + "<td class=\"file_upload_progress\"><div></div></td>" + "<td class=\"file_upload_cancel\">" + "</td></tr>"
    buildDownloadRow: (file) ->
      $('.photos').trigger ('custom_change')
      $ "<div class='processing_image'><img alt='Missing' class='processing' draggable='true' id='#{file.id}' processing='#{file.id}' src='/assets/loading.gif' style='cursor: move;'></div>"



  assing_drops()

  $('.remove_asset').live 'click', ->

    $.ajax
      url: '/reports/' +report_id+ '/remove_asset?asset=' + this.id + '&attribute=' + $(@).data('attribute')
      type: 'DELETE'
      success: (responce) =>
        $(this).parent().remove()

        for place in responce.places
          drop = $(".drop[data-attribute=#{$(@).data('attribute')}][data-place='#{place}']")
          drop.find('img').attr('src', responce.images[place][0])
          drop.find('.btn').html(responce.images[place][1])

  $.each $('.photos img'), ->
    this.ondragstart = (event) ->


      window.dragged = event.target
    $(".thumbnail img").prop('draggable', false)



  $('.destroy_report').click ->
    confirmation = confirm('Точно?')
    if confirmation
      report = $(@).attr('report_id')
      $.ajax
        url: '/reports/' + report + '.json'
        type: 'DELETE'
        complete: ->
          window.location.href = '/reports/'

  $('input:not(#point_description), textarea').change ->
    element = $(@)
    if element.data('change') 
      element.data(element.data('change'), element.val())
    else
      element.data(element.data('attribute'), element.val())
    

    update_object(@)
    console.log 'change'
    if $('.all_wheels').prop('checked')
      $("input[type='text']").val($("input[type='text']").first().val())
    
    store_report()

  $('.all_wheels').click ->
    
    data = container.data().wheels.front_left
    for wheel in $('.wheel')
      
      params = ['width', 'diameter', 'profile', 'brand', 'protector']
      $("input[type='text']").val($("input[type='text']").first().val())
      for param in params
        span_caret = "<span class='caret'></span>"
        $(wheel).find('.' + param).empty()
        $(wheel).find('.' + param).append(data[param])
        $(wheel).find('.' + param).append(span_caret)
      for param in ['pads', 'discs', 'damper']
        $(wheel).find('.' + param).find('.btn').removeClass('btn-primary')
        $("."+ param).find(".btn[data-#{param}=#{data[param]}]").addClass('btn-primary')          
      $(wheel).find('input').val(data.brand)

    container.data().wheels.front_right = data
    container.data().wheels.rear_left = data
    container.data().wheels.rear_right = data
    store_report()


  $('.all_ok').live 'click', ->
    pads = $(@).parent().parent().parent().siblings().find('.pads')
    for pad in pads
      $(pad).find('.btn').first().trigger('click')
    $(@).removeClass('all_ok')
    $(@).addClass('clear_ok')
    $(@).text('Очистить')
  


  $('.clear_ok').live 'click', ->
    $(@).removeClass('clear_ok')
    $(@).addClass('all_ok')
    $(@).text('Все ОК')
    pads = $(@).parent().parent().siblings().find('.object')
    for pad in pads
      if $(pad).data('object')
        $.ajax
          type: 'DELETE'
          url: "/points/#{$(pad).data().id}.json"          
        $(pad).find('.btn-primary').removeClass('btn-primary')
        delete $(pad).data()['id']

  $('.new_all_ok').live 'click', ->
    pads = $(@).parents('.accordion-group').find('.pads')
    for pad in pads
      $(pad).find('.btn').first().trigger('click')
    $(@).removeClass('new_all_ok')
    $(@).addClass('new_clear_ok')
    $(@).text('Очистить')

  $('.new_clear_ok').live 'click', ->
    $(@).removeClass('new_clear_ok')
    $(@).addClass('new_all_ok')
    $(@).text('Все ОК')
    pads = $(@).parents('.accordion-group').find('.object')
    for pad in pads
      console.log $(pad).data('object')
      document.pad = pad
      if $(pad).data('object')
        $.ajax
          type: 'DELETE'
          url: "/points/#{$(pad).data().id}.json"          
        $(pad).find('.btn-primary').removeClass('btn-primary')
        delete $(pad).data()['id']

  $('input#point_description').change ->
    that = $(@)  
    object = that.parents('.object')
    data = object.data()

    if data.id
      $.ajax
        url: "/points/#{data.id}.json"
        type: 'PUT'
        data: {point: description: @.value}
        async: false
    else
      data.description = @.value

      $.ajax
        url: '/points.json'
        type: 'POST'
        data: {point: data}
        async: false

        success: (response) ->
          object.data('id', response.id)
          object.find('.btn').data('id', response.id)       
