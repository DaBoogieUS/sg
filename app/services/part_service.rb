class PartService
  def draw(part:)
    # draw nest svg

    #
    # drawing
    #

    scale = 10

    # the nest
    part_svg = Rasem::SVGImage.new(width: part.width * scale, height: part.height * scale)

    service = ::Draw::AreaBody.new(
      x: 0, y: 0,
      rotated: false, scale: 10,
      part: part, cut_styles: { fill: 'rgba(255,255,255,0.3)' }
    )
    group = service.draw
    part_svg.append_child group if group

    #
    # cut group
    #

    service = ::Draw::AreaCuts.new(
      x: 0, y: 0,
      rotated: false, scale: 10,
      part: part, panel: part.panel
    )
    group = service.draw
    part_svg.append_child group if group

    #
    # score group
    #

    service = ::Draw::AreaScores.new(
      x: 0, y: 0,
      rotated: false, scale: 10,
      part: part, panel: part.panel
    )
    group = service.draw
    part_svg.append_child group if group

    #
    # holes group
    #

    service = ::Draw::AreaHoles.new(
      x: 0, y: 0,
      rotated: false, circle: { fill: 'black', stroke_width: 0 },
      rectangle: { fill: 'rgba(255,255,255,0.3)', stroke_width: 1 },
      scale: 10,
      part: part, panel: part.panel
    )
    group = service.draw
    part_svg.append_child group if group
    #
    # output
    #
    part_svg
  end
end
