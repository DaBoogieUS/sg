ready = ->

  if $(window).width() >= 996
    dropright = true
  else
    dropright = false
  $('.multiselect-select').multiselect({
      maxHeight: 300
      buttonClass: 'btn btn-default multiselect-btn'
      enableFiltering: true
      dropRight: dropright
      buttonText: (options, select) ->
        type = select.data("type")
        if options.length is 0
          "Select " + type + " <b class=\"caret\"></b>"
        else
          options.length + " " + type + " <b class=\"caret\"></b>"
      buttonTitle: (options, select) ->
        type = select.data("type")
        if options.length is 0
          "Select " + type
        else
          options.length + " " + type + " selected"
    })

  $(".multiselect-select").on "change", ->
    get_selected()

  get_selected = ->
    selected_html = ""
    if $(".multiselect-select option:selected").length > 0
      $(".multiselect-select option:selected").each ->
        $this = undefined
        selected_text = undefined
        $this = $(this)
        if $this.length
          selected_text = $this.text()
          selected_html += "<li>" + selected_text + "</li>"
    else
      selected_html = "<em>Nothing selected</em>"

    $("#multiselect-values").html("<h4>Queued for MFG</h4> <ul class=\"list-unstyled\">" + selected_html + "</ul>")

  ###
  Gets whether all the options are selected
  ###
  multiselect_selected = ($el) ->
    ret = true
    $("option", $el).each (element) ->
      ret = false  unless !!$(this).prop("selected")

    ret

  ###
  Selects all the options
  ###
  multiselect_selectAll = ($el) ->
    $("option", $el).each (element) ->
      $el.multiselect "select", $(this).val()
      get_selected()


  ###
  Deselects all the options
  ###
  multiselect_deselectAll = ($el) ->
    $("option", $el).each (element) ->
      $el.multiselect "deselect", $(this).val()
      get_selected()

  ###
  Clears all the selected options
  ###
  multiselect_toggle = ($el, $btn) ->
    if multiselect_selected($el)
      multiselect_deselectAll $el
      $btn.text "Select All"
    else
      multiselect_selectAll $el
      $btn.text "Deselect All"

  $(".multiselect-select-all").click (e) ->
    e.preventDefault()
    multiselect_toggle $('.multiselect-select'), $(this)



$(document).ready(ready)
$(document).on('page:load', ready)