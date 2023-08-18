module Draw
  class AreaScores
    attr_accessor :scale
    attr_accessor :part
    attr_accessor :part_type
    attr_accessor :x
    attr_accessor :y
    attr_accessor :part_width
    attr_accessor :panel_door_width
    attr_accessor :panel_door_height
    attr_accessor :panel_door_inset
    attr_accessor :rotated
    attr_accessor :scores

    def initialize(x:, y:, rotated:, scale:, part:, panel:)
      @scores = []
      @rotated = rotated
      @scale = scale
      @part_type = part.part_type.name
      @x = x * scale
      @y = y * scale
      @part_width = part.width
      @panel_door_width = panel.door_width
      @panel_door_height = panel.door_height
      @panel_door_inset = panel.door_inset_left
    end

    # draw hole pattern
    def draw
      # master filter
      return nil unless part_type.match('Deflector') ||
                        part_type.match('Dropdown')

      # deflector scores
      if part_type.match 'Deflector'
        deflector_scores
      elsif part_type.match 'Dropdown'
        dropdown_scores
      end

      group = Rasem::SVGTag.new('g')
      scores.each do |res|
        group.line(*res[:args])
      end

      group
    end

    private

    def deflector_styles
      {
        stroke: 'black',
        fill: 'none',
        stroke_width: 2
      }
    end

    def line(*args)
      scores << { args: args }
    end

    def dropdown_scores
      # if rotated
      if rotated
        score_x1 = panel_door_height * scale
        score_y1 = (part_width - (panel_door_inset + panel_door_width)) * scale
        score_x2 = panel_door_height * scale
        score_y2 = (part_width - panel_door_inset) * scale
      # if not rotated
      else
        score_x1 = panel_door_inset * scale
        score_y1 = panel_door_height * scale
        score_x2 = (panel_door_inset + panel_door_width) * scale
        score_y2 = panel_door_height * scale
      end # end checking for rotation
      line(
        (x + score_x1), (y + score_y1), (x + score_x2), (y + score_y2),
        deflector_styles
      )
    end

    def deflector_scores
      score_x1 = 0 * scale
      score_x2 = part_width * scale
      score_y1 = 1 * scale
      score_y2 = 1 * scale
      # if rotated
      if rotated
        line(
          (x + score_y1), (y + score_x2), (x + score_y2),
          (y + score_x1), deflector_styles
        )
      # if not rotated
      else
        line(
          (x + score_x1), (y + score_y1), (x + score_x2),
          (y + score_y2), deflector_styles
        )
      end # end checking for rotation
    end
  end
end
