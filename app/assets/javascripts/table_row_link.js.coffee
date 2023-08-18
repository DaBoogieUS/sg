ready = ->
  row_links = ->
    table_row_links = $(".table-row-link")
    if table_row_links
      table_row_links.each ->
        $(this).click ->
          destination = $(this).data("destination")
          window.location = destination

  row_links()

$(document).ready(ready)
$(document).on('page:load', ready)