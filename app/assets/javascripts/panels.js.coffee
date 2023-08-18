# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->

  # door selects
  $panel_model = $('#panel-model')
  $panel_width = $('#panel-width select')
  $panel_height = $('#panel_height')
  $door_width = $('#door-width select')
  $door_height = $('#door-height select')
  $door_inset = $('#door-inset select')
  $svg = document.getElementById('svg')




  svg = ->
    return unless $svg
    panel_width = $panel_width.val()
    panel_height = $panel_height.val()
    door_width = $door_width.val()
    door_height = $door_height.val()
    door_inset = $door_inset.val()
    $svg.innerHTML = ''
    NS = $svg.namespaceURI;
    native_w = parseInt($svg.getAttribute('width'))
    rect = document.createElementNS(NS, 'rect')
    rel_x = (native_w / 2) - (panel_width / 2)
    rect.setAttribute('x', rel_x)
    rect.setAttribute('y', 0)
    rect.setAttribute('width', panel_width)
    rect.setAttribute('height', panel_height)
    rect.setAttribute('fill', 'black')
    $svg.appendChild(rect)

    if door_width
      rect = document.createElementNS(NS, 'rect')
      rect.setAttribute('x', rel_x + (panel_width - door_width - door_inset))
      rect.setAttribute('y', 0)
      rect.setAttribute('width', door_width)
      rect.setAttribute('height', door_height)
      rect.setAttribute('fill', 'none')
      rect.setAttribute('stroke', 'white')
      rect.setAttribute('stroke-width', '0.25')
      $svg.appendChild(rect)



  # show door options
  show_door_options = ->
    allow_height()



  # hide door options
  hide_door_options = ->
    clear_door_options()
    full_panel()



  # clear door options
  clear_door_options = ->
    $door_width.children('option').attr('disabled', false).attr('selected', false)
    $door_height.children('option').attr('disabled', false).attr('selected', false)
    $door_inset.children('option').attr('disabled', false).attr('selected', false)
    $door_width.children('option[value=0]').attr('disabled', false).attr('selected', 'selected')
    $door_height.children('option[value=0]').attr('disabled', false).attr('selected', 'selected')
    $door_inset.children('option[value=0]').attr('disabled', false).attr('selected', 'selected')
    $door_width.children(':not(:selected)').attr('disabled', 'disabled')
    $door_height.children(':not(:selected)').attr('disabled', 'disabled')
    $door_inset.children(':not(:selected)').attr('disabled', 'disabled')



  # allow height
  allow_height = ->
    # allow height
    $door_height.children('option').attr('disabled', false)
    $door_height.children('option[value=0]').attr('disabled', 'disabled').attr('selected', false)
    $door_height.children('option[value=8]').attr('selected', 'selected')



  # zero inset
  zero_inset = ->
    $door_inset.children('option').attr('selected', false)
    $door_inset.children('option[value="0"]').attr('selected', true).attr('disabled', false)
    $door_inset.children(':not(:selected)').attr('disabled', 'disabled')



  # full door
  full_door = ->
    full_panel()
    # dictate width
    $door_width.children('option').attr('selected', false)
    $door_width.children('option[value="'+$panel_width.val()+'"]').attr('disabled', false).attr('selected', true)
    $door_width.children('option[value=0]').attr('disabled', 'disabled').attr('selected', false)
    $door_width.children(':not(:selected)').attr('disabled', 'disabled')
    # zero inset
    zero_inset()



  # min panel
  min_panel = (min) ->
    $panel_width.children('option').each ->
      if $(this).val() < min
        $(this).attr('disabled', 'disabled')
      else
        $(this).attr('disabled', false)
    selected = $panel_width.find(':selected')
    if selected.attr('disabled')
      $panel_width.children('option[value='+min+']').attr('selected', true)

  # full panel
  full_panel = ->
    $panel_width.children('option').each ->
      $(this).attr('disabled', false)



  # inset door
  inset_door = ->
    min_panel(20)
    # allow width
    $door_width.children('option[value=0]').attr('disabled', 'disabled').attr('selected', false)
    $door_width.children('option').each ->
      if $(this).val() > $panel_width.val() - 4 || $(this).val() == "0"
        $(this).attr('disabled', 'disabled')
      else
        $(this).attr('disabled', false)
    dw_selected = $door_width.find(':selected')
    if dw_selected.attr('disabled')
      $door_width.children('option[value=8]').attr('selected', true).attr('disabled', false)
    # allow insets
    $door_inset.children('option').each ->
      if $(this).val() > $panel_width.val() - $door_width.val() - 4 || $(this).val() == "0"
        $(this).attr('disabled', 'disabled')
      else
        $(this).attr('disabled', false)
    selected = $door_inset.find(':selected')
    if selected.attr('disabled')
      $door_inset.children('option[value=4]').attr('selected', true).attr('disabled', false)



  # left door
  left_door = ->
    min_panel(20)
    # dictate width
    $door_width.children('option').attr('disabled', false)
    $door_width.children('option[value=0]').attr('disabled', 'disabled').attr('selected', false)
    $door_width.children('option').each ->
      if $(this).val() > $panel_width.val() - 4
        $(this).attr('disabled', 'disabled')
    # zero inset
    zero_inset()



  # right door
  right_door = ->
    min_panel(20)
    # dictate width
    $door_width.children('option').attr('disabled', false)
    $door_width.children('option[value=0]').attr('disabled', 'disabled').attr('selected', false)
    $door_width.children('option').each ->
      if $(this).val() > $panel_width.val() - 4
        $(this).attr('disabled', 'disabled')
    # dictate door_inset
    inset = $panel_width.val() - $door_width.val()
    $door_inset.children('option').attr('selected', false)
    $door_inset.children('option[value="'+inset+'"]').attr('selected', true).attr('disabled', false)
    $door_inset.children(':not(:selected)').attr('disabled', 'disabled')



  # door validator
  door_validator = (current, change) ->
    unless current.text().indexOf("Dropdown Full") is -1
      full_door()
    unless current.text().indexOf("Dropdown Inset") is -1
      inset_door()
    unless current.text().indexOf("Dropdown Left") is -1
      left_door()
      unless change == false
        door_width = $panel_width.val() - 4
        $door_width.children('option[value='+door_width+']').attr('selected', true)
    unless current.text().indexOf("Dropdown Right") is -1
      unless change == false
        door_width = $panel_width.val() - 4
        $door_width.children('option[value='+door_width+']').attr('selected', true)
        right_door()
      else
        right_door()



  # form model options
  form_model_options = ->
    if $panel_model
      select = $panel_model.find('select')
      current = select.find(':selected')
      unless current.text().indexOf("Dropdown") is -1
        show_door_options()
        door_validator(current, false)
      chosen = select.find(':selected')
      unless chosen.text().indexOf("Dropdown") is -1
        show_door_options()
        door_validator(chosen, true)
      else
        hide_door_options()
        clear_door_options()

      select.change ->
        chosen = $(this).find(':selected')
        unless chosen.text().indexOf("Dropdown") is -1
          show_door_options()
          door_validator(chosen, true)
        else
          hide_door_options()
          clear_door_options()
        svg()

      $panel_width.change ->
        chosen = $panel_model.find(':selected')
        if $panel_width.val() - 4 < $door_width.val()
          door_validator(chosen, true)
        else
          door_validator(chosen, false)
        svg()

      $door_width.change ->
        chosen = $panel_model.find(':selected')
        if $panel_width.val() - 4 < $door_width.val()
          door_validator(chosen, true)
        else
          door_validator(chosen, false)
        svg()

      $door_height.change ->
        svg()

      $door_inset.change ->
        svg()

  form_model_options()
  svg()



$(document).ready(ready)
$(document).on('page:load', ready)