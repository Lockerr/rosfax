object = $('.object_drop[data-object_id=<%= @asset.attachable.id %>]')
img = object.find('img')
img.addClass('processing')
img.parent().spin()
img.attr('id', "<%= @asset.id %>")
$('.photos').trigger('custom_change')

thumb = img.parent()
thumb.data('attachable_id', '<%= @asset.attachable_id %>')
thumb.data('attachable_type', 'Point')

