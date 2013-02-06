$('.container#selector').empty()
$('.container#scheduler').empty()
$('.container#selector').html("<%=j (render 'schedule_form').html_safe %>")
$('#schedule_phone').mask("+7(999) 999 99 99")