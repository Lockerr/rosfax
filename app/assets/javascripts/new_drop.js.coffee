$(document).ready ->
    droppable = $('.object_drop')
    $.each $('.object_drop'), ->

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
        console.log target

        target.parents('.object').data().asset_id = obj.id

        store_point(target.parents('.object'))

