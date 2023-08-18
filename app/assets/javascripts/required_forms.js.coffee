ready = ->
  alert('foo')
  required_form = $(".required_form")
  if required_form
    required_form.each ->
      required_fields = $(this).find(".required")
      required_submit = $(this).find(".required_submit")
      required_fields.change ->
        if required_fields.is(":empty")
          required_submit.addClass "disabled"
        else
          required_submit.removeClass "disabled"

$(document).ready(ready)
$(document).on('page:load', ready)