that = $(".schedule#<%= @schedule.id %>")
that.html("<%=j render partial: 'schedule_row' %>")
that.find('td:not(.actions)').css('text-decoration', 'underline')
that.find('.btn').show()