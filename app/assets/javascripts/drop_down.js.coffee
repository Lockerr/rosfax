$(document).ready ->
  container = $('#report.container')
  $('.dropdown-element').live 'click', ->
    element = $(@)
    parent = element.parents(".object")
    parent.data(element.data().change, element.data().value)

    btns = element.parents('.btn-group').find('.btn')

    btns.first().text(@textContent).css('color', '#08c')
    btns.last().css('color', '#08c')

    if element.data().object == 'defect'
      cat_list = parent.find('.undercat').parent().find('ul')
      cat_list.empty()
      if parent.data().section
        for category in $.parseJSON($('.categories').text())[parent.data().section]
          cat_list.append("<li><div class='dropdown-element' data-object='defect' data-change='place' data-value=#{category.k}>#{category.v}</div></li>")
    console.log parent
    store_point(parent)
    # attr           = element.data('attribute')
    # change         = element.data('change')
    # unless attr == 'defect'
    #   container_data = container.data(attr) || new Object

    #   console.log "container_data => #{container.data(attr)}"

    #   if (place = element.data('place'))
    #     container_data[place] ||= new Object
    #     container_data[place][change] = element.data(change)
    #     console.log "preivous data => #{container_data[place][change]}"
    #     console.log "data(change) => #{element.data(change)}"
    #   else
    #     container_data[change] = element.data(change)

    #   container.data(attr, container_data)
    #   store_report()
    #   $('.all_wheels').trigger('change') if $('.all_wheels').prop('checked')

    # else
    #   defect = $(@).parents('.defect')
    #   data = defect.data()
    #   if change == 'category'
    #     console.log "change => #{change}"
    #     defect.find('.btn-group').show()
    #     defect.find('.drop').show()
    #     defect.data('category',element.data('category'))
    #     defect.find('.undercat').parent().find('.btn').css('color', '#333')
    #     console.log "incat change => #{change}, data_change => #{element.data(change)}"




    #   else
    #     defect.data(change, element.data(change))
    #     console.log "notincat change => #{change}, data_change => #{element.data(change)}"

    #   console.log "end change => #{change}, data_change => #{element.data(change)}"
    #   defect.trigger('change')

