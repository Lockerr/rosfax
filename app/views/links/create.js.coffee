errors = JSON.parse('<%= @link.errors.messages.to_json.html_safe%>')

$('body').prepend("<div class='alert-feedback alert alert-error' style='position: fixed;top: 40px;right: 0px'>ссылка: #{errors.url[0]}</div>");

$('.modal').modal('hide');

$('.alert-feedback').fadeOut(10000);