ready = ->
  $('.datepicker').datepicker(
    format: 'yyyy-mm-dd',
    startDate: '-3d'
  ).on "changeDate", ->
    $(this).datepicker('hide')

$(document).ready(ready)
$(document).on('page:load', ready)
