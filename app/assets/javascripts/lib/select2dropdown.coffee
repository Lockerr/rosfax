jQuery ($) ->
  $(".bootstrap-select").each (i, e) ->
    current = $(e).find("option:selected").html() or "&nbsp;"
    val = $(e).find("option:selected").val()
    name = e.name

    btn_group = $(document.createElement('div'))
      .addClass('btn-group')

    top_button = $(document.createElement('a'))
      .addClass("btn #{$(e).attr('class')}")
      .html(current)

    caret = $(document.createElement('a'))
      .addClass('btn dropdown-toggle')
      .attr('data-toggle', 'dropdown')
      .html($(document.createElement('span'))
        .addClass('caret')
        )

    ul = $(document.createElement('ul'))
      .addClass('dropdown-menu from-selector')

    attribute = $(e).attr('name').match(/\[\w+\]/)[0].match(/\w+/)[0]

    input = $(document.createElement('input'))
      .attr({
        type: 'hidden',
        value: val,
        name: name,
        id: e.id,
        class: $(e).attr('class'),
        'data-attribute': attribute,
        'data-value': val
      })

    btn_group
      .append(top_button)
      .append(caret)
      .append(ul)
      .append(input)

    options = $(e).find('option')

    options.each (option, v) ->
      li = $(document.createElement('li'))
        .append(
          $(document.createElement('a'))
            .attr({
                value: v.value,
                data: attribute,
                'data-value': v.value
                            })
            .html(v.text)
        )
      ul.append li

    $(e).parent().append btn_group
    $(e).remove()

    new_options = $(".dropdown-menu.from-selector a")

    new_options.die 'click'

    $(".dropdown-menu.from-selector a").live 'click', (e) ->
      select = $(@).parents('.btn-group')
      select.find("input[type=hidden]").val($(@).attr('value')).attr('data-value', $(@).attr('value'))

      select.find(".btn:eq(0)").html($(@).html()).addClass('active')

      select.find("input[type=hidden]").trigger('change')

      e.preventDefault()

  $(".bootstrap-check").each (i, e) ->
    btn = $(document.createElement('button'))
      .attr({
        type: 'button',
        class: 'btn',
        style: 'float: left; margin-left: 5px; margin-bottom: 5px',
        'data-toggle': 'button'
           }).html(
           e.value
           )
    $(e).parent().append(btn)
    $(e).hide()