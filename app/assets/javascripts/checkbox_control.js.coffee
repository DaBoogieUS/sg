# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  # checkbox control
  checkbox_control = ->
    checkbox_control = $('.checkbox-control')
    if checkbox_control
      checkbox_control.each ->
        checkbox = $(this).siblings('.checkbox')
        $(this).click ->
          $(this).toggleClass('btn-default')
          $(this).toggleClass('btn-primary')
          checkbox.prop("checked", !checkbox.prop("checked"));

  checkbox_control()



$(document).ready(ready)
$(document).on('page:load', ready)
