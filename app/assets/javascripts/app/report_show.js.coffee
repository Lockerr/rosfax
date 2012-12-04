$(document).ready ->
  $(".image_at_show").live 'click', ->
    id = $(@).attr('id')
    $('#modal_carousel .item').remove()

    report_id = $('#report.container').data('id')
    if object = 'Report'
      url = '/reports/'+report_id+'/all_images'

      $.ajax
        url: url
        data: {asset_id: id}
        success: (data) ->
          console.log data

          for image_src in data

            $('.carousel-inner').append("<div class='item'><img src='" + image_src + "'></div>")

          $($('.carousel-inner .item')[0]).addClass('active')
          $('#myCarousel').carousel('pause')
          $('#modal_carousel').modal('show')