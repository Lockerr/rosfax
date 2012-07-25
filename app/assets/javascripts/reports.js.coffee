# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/



@store_report = ->
  data = $('.container').data()

  report = new Object

  $.ajax
    type: 'PUT'
    data: {report: data}
    url: '/reports/' + $('.container').attr('report')

@store_defect = (defect) ->
  if defect.data().id
    update_defect(defect)
  else
    create_defect(defect)

@create_defect = (defect) ->

  $.ajax
    type: 'POST'
    data: {defect: defect.data()}
    url: '/reports/' + $('.container').attr('data-report') + '/defects.json'
    async: false
    success: (data) ->
      defect.data('id', data.id)
      defect.find('.drop').attr('object_id', data.id)
@update_defect = (defect) ->
  $.ajax
    type: 'PUT'
    data: {defect: defect.data()}
    url: '/reports/' + container.data('report') + '/defects/' + defect.data().id + '.json'
    async: false

@assing_drops = ->
    droppable = $('.drop')
    $.each $('.drop'), ->

      this.ondrop  = (event) ->
        obj = window.dragged

        event.preventDefault()
        event.dataTransfer.dropEffect = "copy"
        attribute = $(this).attr('attribute')

        $('.imgbox').append "<div class='thumbnail' style='width: 100px; float: left; margin-right: 5px; height: 67px'><div class='btn remove_asset btn-danger btn-mini' id='"+obj.id+"' style='position: relative; top: -20px; left: 80px'>x</div></div>"
        $('.imgbox').width($('.imgbox').width()+ 116)
        $('.thumbnail').last().prepend($.clone(window.dragged))
        $(this).find('a').html(window.dragged)
        if $(this).attr('object') == 'Report'
          $.ajax
            url: '/reports/' + $('.container').attr('data-report')  + '/place?position=' + $(this).attr('id') + '&asset='  + window.dragged.id + '&attribute=' + attribute
            type: 'post'
        else if $(this).attr('object') == 'Defect'
          $.ajax
            url: '/defects/' + $(this).attr('object_id')  + '/place?&asset='  + window.dragged.id
            type: 'post'

$ ->
  container = $('div.container')
  container.data(JSON.parse($('.container').attr('source')))


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
    report = $('.container').attr('data-report')
    $.ajax
      url: '/reports/' +report+ '/remove_asset?asset=' + this.id
      type: 'DELETE'
      success: =>
        $(this).parent().remove()
        $('.drop[image=' +this.id+ ']').find('a').html($('.drop[image=' +this.id+ ']').attr('id'))
        $('.drop[image=' +this.id+ '] img')


  $.each $('.photos img'), ->
    this.ondragstart = (event) ->
      window.dragged = event.target


  $('.drop').click ->
    $('#modal_carousel').modal('show')
    $('#modal_carousel .item').remove()
    attribute = $(this).parent().parent().parent().attr('id')
    report = $('.container').attr('data-report')
    place = $(this).attr('id')

    url = '/reports/'+report+'/images?attribute=' +attribute+ '&place=' +place

    $.ajax
      url: url
      success: (data) ->
        console.log data

        for image_src in data
          $('.carousel-inner').append("<div class='item'><img src='" + image_src + "'></div>")

        $($('.carousel-inner .item')[0]).addClass('active')

        $('#modal_carousel').modal('show')

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

  $('button.dropdown-toggle').parent().find('div.dropdown-element').click ->
    element = $(@)

    element.parents('div.btn-group').find('button.dropdown-toggle').text(@textContent)

    attr           = element.data('attribute')
    container_data = container.data(attr) || new Object
    change         = element.data('change')

    if (place = element.data('place'))
      container_data[place] ||= new Object
      container_data[place][change] = element.data(change)
    else
      container_data[change] = element.data(change)

    container.data(attr, container_data)
    container.trigger('change')

  #-- end of dropdown

  # checkbox common


  #-- end of checkbox common


  $('.add_defect').click ->
    defect = $('.defect_template').clone()
    defect.removeClass('defect_template')
    defect.addClass('defect')
    defect.find('.drop').hide()
    window.scrollTo(0,0)
    $('#compiled .defects').prepend(defect)
    $('.defect').show()

  $('.defect').find('.dropdown-element').live 'click', ->
    $(this).parent().parent().parent().find('.dropdown-toggle').text(this.textContent)
    $(this).parents('.defect').data($(this).attr('data-change'), $(this).attr($(this).attr('data-change')) )
    $(this).parents('.defect').trigger('change')
    $(this).parent().parent().parent().parent().find('.undercat').show()
    $('.defect_type').show()
    $('.defect_size').show()
    $('#defect_form').find('.drop').show() # :TODO refactor this shit(many forms with same id, this is unnaceptable !!!1111oneone)
    cat_list = $(this).parent().parent().parent().parent().find('.undercat').parent().find('ul')
    cat_list.empty()
    for category in $.parseJSON($('.categories').text())[$(this).attr($(this).attr('data-change'))]
      cat_list.append("<li><div class='dropdown-element' data-change= 'sub_category' sub_category=#{category.k}>#{category.v}</div></li>") # :TODO remove this error
    cat_list.find('.dropdown-element').click ->
      $(this).parent().parent().parent().find('.dropdown-toggle').text(this.textContent)
      $(this).parent().parent().parent().attr('category-selected', $(this).attr('data-change'))

  $('.defect').live 'change', ->
    store_defect($(this))
    assing_drops()

  $('.container').live 'change', ->
    store_report()

  $('.btn#save_defect').click ->

