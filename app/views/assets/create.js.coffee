object = $('.object_drop[data-object_id=<%= @asset.attachable.id %>]')
img = object.find('img')
img.addClass('processing')
img.parent().spin()
img.attr('id', "<%= @asset.id %>")
$('.photos').trigger('custom_change')