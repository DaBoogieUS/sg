# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  material_type = $('#material-type-container')
  if material_type
    select = material_type.find('select')
    current = select.find(':selected')
    area_objs = $('.show-area')
    length_objs = $('.show-length')
    count_objs = $('.show-count')
    if current.val() is "area" or material_type.text()  is "area"
      area_objs.each ->
        $(this).fadeIn 200
    else if current.val() is "length" or material_type.text()  is "length"
      length_objs.each ->
        $(this).fadeIn 200
    else if current.val() is "count"  or material_type.text()  is "count"
      count_objs.each ->
        $(this).fadeIn 200
    select.change ->
      chosen = $(this).find(':selected')

      if chosen.val() is "area"
        area_objs.each ->
          $(this).fadeIn 200
        length_objs.each ->
          $(this).hide()
          $(this).find('input').val('')
        count_objs.each ->
          $(this).hide()
          $(this).find('input').val('')

      else if chosen.val() is "length"
        area_objs.each ->
          $(this).hide()
          $(this).find('input').val('')
        length_objs.each ->
          $(this).fadeIn 200
        count_objs.each ->
          $(this).hide()
          $(this).find('input').val('')
      else if chosen.val() is "count"
        area_objs.each ->
          $(this).hide()
          $(this).find('input').val('')
        length_objs.each ->
          $(this).hide()
          $(this).find('input').val('')
        count_objs.each ->
          $(this).fadeIn 200
      else
        area_objs.each ->
          $(this).hide()
          $(this).find('input').val('')
        length_objs.each ->
          $(this).hide()
          $(this).find('input').val('')
        count_objs.each ->
          $(this).hide()
          $(this).find('input').val('')

$(document).ready(ready)
$(document).on('page:load', ready)