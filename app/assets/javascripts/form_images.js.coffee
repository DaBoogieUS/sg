ready = ->
  form_image_container = $(".form-image-container")
  if form_image_container
    replace_link = form_image_container.find(".replace-image")
    image_view = form_image_container.find(".form-image-view")
    image_field = form_image_container.find(".form-image-field")
    replace_link.click ->
      image_view.hide()
      image_field.fadeIn 200
      return false

$(document).ready(ready)
$(document).on('page:load', ready)
