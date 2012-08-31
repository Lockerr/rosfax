# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

@appendUploader = (tab) ->
  tabs = ['#exterior', '#interior', '#under_the_hood', '#photo_others', '#wheels', '#defects-compiled', "#defects-exterior", "#defects-interior", "#defects-windows_and_lights", "#defects-powertrains", "#defects-chasis", "#defects-wheels", "#defects-electric", "#defects-liquids", "#defects-other", "#defects-video"]

  console.log tabs
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

        imgbox = $(".imgbox##{attribute}")

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


  report_id = $('#report.container').data('id')

  $( ".pick_date" ).datepicker({showOn: ".add-on",changeMonth: true,changeYear: true})
  $('.add-on').click ->
    $(@).parent().find('input').datepicker('show')

  for checkbox in $('button.checkbox')
    button = $(checkbox)
    boxlist = container.data(button.data('attribute'))
    if boxlist[button.data('place')]
      if parseInt(container.data(button.data('attribute'))[button.data('place')][button.data('change')]) == button.data(button.data('change'))
        button.addClass('btn-primary')
      else if container.data(button.data('attribute'))[button.data('place')][button.data('change')] == button.data(button.data('change'))
        button.addClass('btn-primary')

  $(".upload").fileUploadUI
    uploadTable: $(".photos .tab-pane.uploading")
    downloadTable: $(".photos .tab-pane")
    buildUploadRow: (files, index) ->
      console.log "file: #{file} index: #{index}"
      file = files[index]

      $ "<tr><td>" + file.name + "</td>" + "<td class=\"file_upload_progress\"><div></div></td>" + "<td class=\"file_upload_cancel\">" + "</td></tr>"
        # "<span class=\"ui-icon ui-icon-cancel\">Cancel</span>" + "<button class=\"ui-state-default ui-corner-all\" title=\"Cancel\">" + "</button>
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

  $(' .nav-tabs.first li').click ->

    # console.log $(@).find('a').attr('href')

    #console.log 'first'
    #console.log $("#{$(@).find('a').attr('href')}.tab-pane .nav-tabs li.active a").first().attr('href')

    appendUploader($("#{$(@).find('a').attr('href')}.tab-pane .nav-tabs li.active a").first().attr('href'))

  $(' .nav-tabs.second li').click ->
    console.log 'second'
    console.log  $(@).find('a').attr('href')

    appendUploader($(@).find('a').attr('href'))
################# DOCUMENTS #########################
  $('input, textarea').change ->
    element = $(@)
    console.log "input textarea =============================="
    console.log element
    attr           = element.data('attribute')
    change     = element.data('change')
    place        = element.data('place')

    console.log "attr => #{attr}"
    console.log "place => #{place}"
    console.log "change => #{change}"

    container_data = container.data(attr) || new Object

    console.log "container_data => #{container.data(attr)}"


    container_data[place] ||= new Object
    container_data[place][change] = element.val()
    console.log "preivous data => #{container_data[place][change]}"
    console.log "data(change) => #{element.val()}"

    container.data(attr, container_data)

    console.log "container.data(attr, container_data) => #{container.data(attr, container_data)}"

    console.log 'container triggered'

    store_report()

  $('.hide_unchecked').click ->
    $('.unchecked').toggle(500)


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
      container.data().wheels.front_right = data
      container.data().wheels.rear_left = data
      container.data().wheels.rear_right = data
      store_report()
  $.mask.definitions['~'] = "[AАBВСCEЕHНKКMМOОPРTТXХYУ]"
  $('input#report_car_gov_number').mask("~ 999 ~~ 99?9")
  $('input#report_car_vin').mask("*** ****** ****9999")
  $('input#report_car_buyer_phone, input#report_car_seller_phone').mask("+7(999) 999 99 99")
