# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/



@store_report = ->
  data = $('#report.container').data()

  report = new Object

  $.ajax
    type: 'PUT'
    data: {report: data}
    url: '/reports/' + $('#report.container').attr('report')

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

        imgbox = $(".imgbox##{attribute}")

        imgbox.append "<div class='thumbnail' style='width: 100px; float: left; margin-right: 5px; height: 67px'><div class='btn remove_asset btn-danger btn-mini' data-attribute = #{attribute} id='"+obj.id+"' style='position: relative; top: -20px; left: 80px'>x</div></div>"
        imgbox.width(imgbox.width()+ 116)
        imgbox.find('.thumbnail').last().prepend($.clone(window.dragged))
        target = $(@)


        target.find('a').html(window.dragged)
        target.find('.btn').text(parseInt(target.find('.btn').text())+1)



        if target.attr('object') == 'Report'
          $.ajax
            url: '/reports/' + $('#report.container').data('id')  + '/place?position=' + target.attr('id') + '&asset='  + window.dragged.id + '&attribute=' + attribute
            type: 'post'
        else if target.attr('object') == 'Defect'
          $.ajax
            url: '/defects/' + target.attr('object_id')  + '/place?&asset='  + window.dragged.id
            type: 'post'

@assign_click_for_dropdown = (container) ->
  $('button.dropdown-toggle').parent().find('div.dropdown-element').click ->
    element = $(@)

    element.parents('div.btn-group').find('button.dropdown-toggle').text(@textContent)

    attr           = element.data('attribute')
    change         = element.data('change')

    unless attr == 'defect'
      container_data = container.data(attr) || new Object


      if (place = element.data('place'))
        container_data[place] ||= new Object
        container_data[place][change] = element.data(change)
      else
        container_data[change] = element.data(change)

      container.data(attr, container_data)
      console.log 'container triggered'
      container.trigger('change')

    else
      defect = $(@).parents('.defect')
      data = defect.data()
      if change == 'category'
        console.log defect
        defect.find('.btn-group').show()
        defect.find('.drop').show()
        defect.data('category',element.data('category'))
        cat_list = defect.find('.undercat').parent().find('ul')
        cat_list.empty()
        for category in $.parseJSON($('.categories').text())[element.data(change)]
          cat_list.append("<li><div class='dropdown-element' data-defect data-attribute='defect' data-change='sub_category' data-sub_category=#{category.k}>#{category.v}</div></li>") # :TODO remove this error

        cat_list.find('.dropdown-element').click ->
          element = $(@)
          change         = element.data('change')
          $(@).parents('div.btn-group').find('button.dropdown-toggle').text(@textContent)
          defect.data(change, element.data(change))
      else
        defect.data(change, element.data(change))
      defect.trigger('change')



$ ->
  container = $('#report.container')
  if container.attr('source')
    container.data(JSON.parse($('#report.container').attr('source')))
    assign_click_for_dropdown(container)

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


  $('.checkbox').click ->
    element      = $(@)
    change       = element.data('change')
    attribute    = element.data('attribute')
    place        = element.data('place')
    data         = container.data(attribute) || {}
    data[place]||= {}
    data[place][change] = element.data(change)

    container.data(attribute, data)
    console.log container.data()
    container.trigger('change')

  $(".upload").fileUploadUI
    uploadTable: $(".upload_files")
    downloadTable: $(".download_files")
    buildUploadRow: (files, index) ->
      file = files[index]
      $ "<tr><td>" + file.name + "</td>" + "<td class=\"file_upload_progress\"><div></div></td>" + "<td class=\"file_upload_cancel\">" + "<button class=\"ui-state-default ui-corner-all\" title=\"Cancel\">" + "<span class=\"ui-icon ui-icon-cancel\">Cancel</span>" + "</button></td></tr>"

    buildDownloadRow: (file) ->
      $ "<tr><td><img alt=\"Photo\" width=\"40\" height=\"40\" src=\"" + file.pic_path + "\">" + file.name + "</td></tr>"

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


  $('.drop').click ->
    $('#modal_carousel').modal('show')
    $('#modal_carousel .item').remove()
    data = $(@).data()

    if object = 'Report'
      url = '/reports/'+report_id+'/images?attribute=' +data.attribute+ '&place=' + data.place

      $.ajax
        url: url
        success: (data) ->
          console.log data

          for image_src in data
            $('.carousel-inner').append("<div class='item'><img src='" + image_src + "'></div>")

          $($('.carousel-inner .item')[0]).addClass('active')

          $('#modal_carousel').modal('show')





  $('.add_defect').click ->
    defect = $('.defect_template').clone()
    defect.removeClass('defect_template')
    defect.addClass('defect')
    defect.find('.drop').hide()
    window.scrollTo(0,0)
    $('#compiled .defects').prepend(defect)
    $('.defect').show()
    assign_click_for_dropdown(defect)


  $('.defect').live 'change', ->
    store_defect($(@))
    assing_drops()

  $('#report.container').live 'change', ->
    container = $(@)
    inputs = $("#report.container input[type='text']")
    for input in inputs
      input = $(input)
      container.data()[input.data().attribute] ||= {}
      container.data()[input.data().attribute][input.data().place] = input.val()
      console.log container.data()

    store_report()

  $('.btn#save_defect').click ->

  $('.destroy_report').click ->
    confirmation = confirm('Точно?')
    if confirmation
      report = $(@).attr('report_id')
      $.ajax
        url: '/reports/' + report + '.json'
        type: 'DELETE'
        complete: ->
          window.location.href = '/reports/'







#  $('.defect').find('.dropdown-element').live 'click', ->
#    change = change
#    $(@).parent().parent().parent().find('.dropdown-toggle').text(this.textContent)
#    $(@).parents('.defect').data(change, $(@).attr(change) )
#    $(@).parents('.defect').trigger('change')
#    $(@).parent().parent().parent().parent().find('.undercat').show()
#    $('.defect_type').show()
#    $('.defect_size').show()
#    $('#defect_form').find('.drop').show() # :TODO refactor this shit(many forms with same id, this is unnaceptable !!!1111oneone)
#    cat_list = $(@).parent().parent().parent().parent().find('.undercat').parent().find('ul')
#    cat_list.empty()
#    for category in $.parseJSON($('.categories').text())[$(@).attr(change)]
#      cat_list.append("<li><div class='dropdown-element' data-change= 'sub_category' sub_category=#{category.k}>#{category.v}</div></li>") # :TODO remove this error
#    cat_list.find('.dropdown-element').click ->
#      $(@).parent().parent().parent().find('.dropdown-toggle').text(this.textContent)
#      $(@).parent().parent().parent().attr('category-selected', change)


  # dropdown common
#
#  $('.dropdown-toggle').parent().find('.dropdown-element').click ->
#    $(this).parents('.btn-group').find('.dropdown-toggle').text(this.textContent)
#    if $('.container').data($(this).data('attribute')) == undefined
#      console.log 'undef'
#      $('.container').data($(this).data('attribute'), new Object)
#
#    if $(this).data('place')
#      if $('.container').data($(this).data('attribute'))[$(this).data('place')] == undefined
#        $('.container').data($(this).data('attribute'))[$(this).data('place')] = new Object
#      $('.container').data($(this).data('attribute'))[$(this).data('place')][$(this).data('change')] = $(this).data($(this).data('change'))
#    else
#      $('.container').data($(this).data('attribute'))[$(this).data('change')] = $(this).data($(this).data('change'))
#
#    $('.container').trigger('change')

  #-- end of dropdown

  # checkbox common


  #-- end of checkbox common