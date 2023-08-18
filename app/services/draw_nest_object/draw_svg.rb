module DrawNestObject
  class DrawSvg < Base
    def area_body(scale:)
      service = ::Draw::AreaBody.new(
        x: nest_object.x, y: nest_object.y,
        rotated: nest_object.rotated,
        scale: scale, part: part
      )
      # returns a group
      service.draw
    end

    def area_cuts(scale:)
      service = ::Draw::AreaCuts.new(
        x: nest_object.x, y: nest_object.y,
        rotated: nest_object.rotated,
        scale: scale, part: part, panel: panel
      )
      # returns a group
      service.draw
    end

    def area_scores(scale:)
      service = ::Draw::AreaScores.new(
        x: nest_object.x, y: nest_object.y,
        rotated: nest_object.rotated,
        scale: scale, part: part, panel: panel
      )
      # returns a group
      service.draw
    end

    def area_holes(scale:)
      service = ::Draw::AreaHoles.new(
        x: nest_object.x, y: nest_object.y,
        rotated: nest_object.rotated,
        scale: scale, part: part, panel: panel
      )
      # returns a group
      service.draw
    end
  end
end
