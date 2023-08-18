ready = ->
  $("input[type=submit].btn").each ->
    $(this).click ->
      loading_text = $(this).data("loading-text")
      if loading_text
        reg_form = $(this).parents(".simple_form:not(.validate)")
        validate_form = $(this).parents("form.validate")
        if validate_form and validate_form.valid() is true
          $(this).addClass "disabled"
          $(this).val loading_text

$(document).ready(ready)
$(document).on('page:load', ready)