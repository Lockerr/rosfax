
modal = $('.modal#schedule-success')
modal.find('p').html('<%= flash[:js].html_safe %>')
modal.modal('show')