errors = JSON.parse('<%= @link.errors.messages.to_json.html_safe%>')
if errors.url
  $('body').prepend("<div class='alert-feedback alert alert-error' style='position: fixed;top: 40px;right: 0px'>ссылка: #{errors.url[0]}</div>");
  $('.new_link_<%= @link.site %>').find('.control-group').addClass('error')
  $('.new_link_<%= @link.site %>').find('.control-group').removeClass('success')
else
  $('body').prepend("<div class='alert-feedback alert alert-success' style='position: fixed;top: 40px;right: 0px'>Ссылка сохранена.</div>");
  $('.new_link_<%= @link.site %>').find('.control-group').addClass('success')
  $('.new_link_<%= @link.site %>').find('.control-group').removeClass('error')


$('.alert-feedback').fadeOut(10000);