ready = ->
  $(".validate").each ->
    $(this).validate
      errorClass: "has-error"
      highlight: (element, errorClass) ->
        $(element).parent().addClass(errorClass)

      unhighlight: (element, errorClass) ->
        $(element).parent().removeClass(errorClass)

$(document).ready(ready)
$(document).on('page:load', ready)