ready = ->
  Element::hasClassName = (a) ->
    new RegExp("(?:^|\\s+)" + a + "(?:\\s+|$)").test @className

  Element::addClassName = (a) ->
    @className = [@className, a].join(" ")  unless @hasClassName(a)

  Element::removeClassName = (b) ->
    if @hasClassName(b)
      a = @className
      @className = a.replace(new RegExp("(?:^|\\s+)" + b + "(?:\\s+|$)", "g"), " ")

  init = ->
    box = document.getElementById("structure_model")
    showPanelButtons = document.querySelectorAll("#show-buttons button")
    panelClassName = "show-front"
    onButtonClick = (event) ->
      box.removeClassName panelClassName
      panelClassName = event.target.title
      box.addClassName panelClassName

    i = 0
    len = showPanelButtons.length

    while i < len
      showPanelButtons[i].addEventListener "click", onButtonClick, false
      i++

  # window.addEventListener "DOMContentLoaded", init, false
  init()

$(document).ready(ready)
$(document).on('page:load', ready)