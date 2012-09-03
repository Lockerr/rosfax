
@appendUploader = (tab) ->
  tabs = ['#exterior', '#interior', '#under_the_hood', '#photo_others', '#wheels', '#defects-compiled', "#defects-exterior", "#defects-interior", "#defects-windows_and_lights", "#defects-powertrains", "#defects-chasis", "#defects-wheels", "#defects-electric", "#defects-liquids", "#defects-other", "#defects-video"]

  if tab in tabs
    $("#{tab} #{tab}.row-fluid").append($('.uploader'))
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
  console.log defect.data('report_id')
  window.defect = defect
  $.ajax
    type: 'POST'
    data: {defect: defect.data()}
    url: '/reports/' + defect.data('report_id') + '/defects.json'
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
        obj = window.dragged
        console.log obj.id
        event.preventDefault()
        event.dataTransfer.dropEffect = "copy"
        attribute = $(this).data('attribute')

        target = $(@)

        image = document.createElement('div')
        $(image).addClass('thumb')
        $(image).attr('data-attribute', attribute)
        $(image).attr('data-place', $(@).data('place'))
        $(image).attr('style', 'cursor: pointer')

        target.find('a').html(image)
        target.find('.thumb').html(window.dragged)
        target.find('.btn').text(parseInt(target.find('.btn').text())+1)
        target.find('img').attr('style', '')
        target.find('img').prop('draggable', false)
        imgbox = $(".imgbox##{attribute}")
        console.log imgbox.find("##{obj.id}")
        if imgbox.find("##{obj.id}").size() == 0
          imgbox.append "<div class='thumbnail' style='width: 100px; float: left; margin-right: 5px; height: 67px'><div class='btn remove_asset btn-danger btn-mini' data-attribute = #{attribute} id='"+obj.id+"' style='position: relative; top: -20px; left: 80px'>x</div></div>"
          imgbox.width(imgbox.width()+ 116)
          new_image = $.clone(target.find('.thumb')[0])
          imgbox.find('.thumbnail').last().prepend(new_image)


        if target.attr('object') == 'Report'
          $.ajax
            url: '/reports/' + $('#report.container').data('id')  + '/place?position=' + target.attr('id') + '&asset='  + window.dragged.id + '&attribute=' + attribute
            type: 'post'
        else if target.attr('object') == 'Defect'
          $.ajax
            url: '/defects/' + target.attr('object_id')  + '/place?&asset='  + window.dragged.id
            type: 'post'


$ ->
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
      $ "<img alt='Missing' class='processing' draggable='true' height='66' id='#{file.id}' processing='#{file.id}' src='/assets/loading.gif' style='cursor: move;' width='96'>"

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

  $(".thumb").live 'click', ->

    $('#modal_carousel .item').remove()
    data = $(@).data()

    if object = 'Report'
      url = '/reports/'+report_id+'/images'

      $.ajax
        url: url
        data: {attribute: data.attribute, place: data.place}
        success: (data) ->
          console.log data

          for image_src in data

            $('.carousel-inner').append("<div class='item'><img src='" + image_src + "'></div>")

          $($('.carousel-inner .item')[0]).addClass('active')
          $('#myCarousel').carousel('pause')
          $('#modal_carousel').modal('show')

  $('.add_defect').click ->
    defect = $('.defect_template').clone()
    defect.removeClass('defect_template')
    defect.addClass('defect')
    defect.find('.drop').hide()
    window.scrollTo(0,0)
    $(@).parent().prepend('<hr/>')
    $(@).parent().prepend(defect)
    $(@).parent().prepend $('.add_defect')
    $('.defect').show()

  $('.defect').live 'change', ->
    store_defect($(@))
    assing_drops()

  $('.destroy_report').click ->
    confirmation = confirm('Точно?')
    if confirmation
      report = $(@).attr('report_id')
      $.ajax
        url: '/reports/' + report + '.json'
        type: 'DELETE'
        complete: ->
          window.location.href = '/reports/'

  $('input, textarea').change ->
    element = $(@)
    element.data(element.data('change'), element.val())
    update_object(@)
    $('.all_whells').trigger('change') if $('.all_wheels').prop('checked')
    store_report()

  $('.all_wheels').change ->
    if $(@).prop('checked')
      data = container.data().wheels.front_left
      for wheel in $('.wheel')
        unless $('.wheel').index(wheel) == 0
          params = ['width', 'diameter', 'profile', 'brand', 'protector']
          for param in params
            span_caret = "<span class='caret'></span>"
            $(wheel).find('.' + param).empty()
            $(wheel).find('.' + param).append(data[param])
            $(wheel).find('.' + param).append(span_caret)
          for param in ['pads', 'discs', 'damper']
            $(wheel).find('.' + param).find('.btn').removeClass('btn-primary')
            $("."+ param).find(".btn[data-#{param}=#{data[param]}]").addClass('btn-primary')
          console.log data.brand
          $(wheel).find('input').val(data.brand)

      container.data().wheels.front_right = data
      container.data().wheels.rear_left = data
      container.data().wheels.rear_right = data
      store_report()


