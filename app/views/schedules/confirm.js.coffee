$(".schedule#<%= @schedule.id %>").html("<%=j render partial: 'schedule_row' %>")
$(".schedule#<%= @schedule.id %>").trigger('hover')