$(document).ready ->
  container = $('#report.container')
  $('.dropdown-element').live 'click', ->
    element = $(@)

    element.parents('.btn-group').find('.btn').first().text(@textContent)
    element.parents('.btn-group').find('.btn').first().css('color', '#08c')
    element.parents('.btn-group').find('.btn').last().css('color', '#08c')

    console.log "=============================="

    attr           = element.data('attribute')
    change         = element.data('change')



    console.log "attr => #{attr}"
    console.log "change => #{change}"

    unless attr == 'defect'
      container_data = container.data(attr) || new Object

      console.log "container_data => #{container.data(attr)}"

      if (place = element.data('place'))
        container_data[place] ||= new Object
        container_data[place][change] = element.data(change)
        console.log "preivous data => #{container_data[place][change]}"
        console.log "data(change) => #{element.data(change)}"
      else
        container_data[change] = element.data(change)

      container.data(attr, container_data)
      store_report()
      $('.all_wheels').trigger('change') if $('.all_wheels').prop('checked')

    else
      defect = $(@).parents('.defect')
      data = defect.data()
      if change == 'category'
        console.log "change => #{change}"
        defect.find('.btn-group').show()
        defect.find('.drop').show()
        defect.data('category',element.data('category'))
        defect.find('.undercat').parent().find('.btn').css('color', '#333')
        console.log "incat change => #{change}, data_change => #{element.data(change)}"

        cat_list = defect.find('.undercat').parent().find('ul')
        cat_list.empty()
        for category in $.parseJSON($('.categories').text())[element.data(change)]
          cat_list.append("<li><div class='dropdown-element' data-defect='' data-attribute='defect' data-change='sub_category' data-sub_category=#{category.k}>#{category.v}</div></li>") # :TODO remove this error


      else
        defect.data(change, element.data(change))
        console.log "notincat change => #{change}, data_change => #{element.data(change)}"

      console.log "end change => #{change}, data_change => #{element.data(change)}"
      defect.trigger('change')

