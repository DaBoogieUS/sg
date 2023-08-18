ready = ->
  inline_form_button = $(".show_inline_form")
  if inline_form_button
    inline_form_button.each ->
      form = $('#' + $(this).data('form') )
      $(this).click ->
        $(this).hide()
        form.slideDown 200

$(document).ready(ready)
$(document).on('page:load', ready)