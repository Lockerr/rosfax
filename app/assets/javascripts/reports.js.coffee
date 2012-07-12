# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $(".upload").fileUploadUI
    uploadTable: $(".upload_files")
    downloadTable: $(".download_files")
    buildUploadRow: (files, index) ->
      file = files[index]
      $ "<tr><td>" + file.name + "</td>" + "<td class=\"file_upload_progress\"><div></div></td>" + "<td class=\"file_upload_cancel\">" + "<button class=\"ui-state-default ui-corner-all\" title=\"Cancel\">" + "<span class=\"ui-icon ui-icon-cancel\">Cancel</span>" + "</button></td></tr>"

    buildDownloadRow: (file) ->
      $ "<tr><td><img alt=\"Photo\" width=\"40\" height=\"40\" src=\"" + file.pic_path + "\">" + file.name + "</td></tr>"


  droppable = $('.drop')

  $.each $('.drop'), ->
    this.ondrop  = (event) ->
      event.preventDefault()
      event.dataTransfer.dropEffect = "copy"
      $(this).empty()
      $(this).append window.dragged
      $.ajax
        url: '/reports/' + $('.container').attr('data-report')  + '/place?place=' + $(this).parent().parent().attr('id') + '&asset='  + window.dragged.id + '&index=' + this.id
        type: 'post'

  $.each $('.photos img'), ->
    this.ondragstart = (event) ->
      window.dragged = event.target