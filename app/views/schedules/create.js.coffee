
modal = $('.modal#schedule-success')
modal.find('p').html('<%= flash[:js] %>')
modal.modal('show')