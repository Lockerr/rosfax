$('.container#selector').empty()
$('.container#scheduler').empty()
$('.container#selector').html("<%=j (render 'schedule_form').html_safe %>")