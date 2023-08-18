# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  # e.g. set the background of inserted task
  $("#structures .remove_fields").each ->
    $(this).on "click", ->
      # allow some time for the animation to complete
      $(this).parents('.form-group').slideUp 200

$(document).ready(ready)
$(document).on('page:load', ready)