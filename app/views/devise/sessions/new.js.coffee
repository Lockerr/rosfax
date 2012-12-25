$('.alerts').fadeOut(200)
$('.alerts').empty()
if <%= !flash[:alert].presence.nil? %>
  
  $('.alerts').append("<div class='alert alert-error'><%= flash[:alert] %></div>")
  $('.alerts').fadeIn(200)