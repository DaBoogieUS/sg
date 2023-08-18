module Draw
  class AreaCuts
    attr_accessor :scale
    attr_accessor :part
    attr_accessor :part_type
    attr_accessor :x
    attr_accessor :y
    attr_accessor :part_width
    attr_accessor :panel_width
    attr_accessor :panel_door_width
    attr_accessor :panel_door_height
    attr_accessor :panel_door_inset
    attr_accessor :rotated
    attr_accessor :cuts

    def initialize(x:, y:, rotated:, scale:, part:, panel:)
      @cuts = []
      @rotated = rotated
      @scale = scale
      @part_type = part.part_type.name
      @x = x * scale
      @y = y * scale
      @part_width = part.width
      @panel_width = panel.width
      @panel_door_width = panel.door_width
      @panel_door_height = panel.door_height
      @panel_door_inset = panel.door_inset_left
    end

    # draw hole pattern
    def draw
      cut_types = [
        'Dropdown Inset Surface', 'Dropdown Right Surface',
        'Dropdown Left Surface'
      ]
      return nil unless cut_types.include? part_type

      #
      # part_type-specific cuts
      #

      # door inset
      case part_type
      when 'Dropdown Inset Surface'
        door_left_cut_x = panel_door_inset * scale
        door_left_cut_y = panel_door_height * scale
        door_right_cut_x = (panel_door_inset + panel_door_width) * scale
        door_right_cut_y = panel_door_height * scale
      # door right
      when 'Dropdown Right Surface'
        door_left_cut_x = panel_door_inset_left * scale
        door_left_cut_y = panel_door_height * scale
      # door left
      when 'Dropdown Left Surface'
        door_right_cut_x = panel_door_width * scale
        door_right_cut_y = panel_door_height * scale
      end

      #
      # draw the object
      #

      # if rotated
      if rotated
        part_width = panel_width * scale
        # door cuts
        line(
          x, y + part_width - door_left_cut_x, x + door_left_cut_y,
          y + part_width - door_left_cut_x, cut_style
        ) if door_left_cut_x

        line(
          x, y + part_width - door_right_cut_x, x + door_right_cut_y,
          y + part_width - door_right_cut_x, cut_style
        ) if door_right_cut_x
      # if not rotated
      else
        # door cuts
        line(
          x + door_left_cut_x, y, x + door_left_cut_x,
          y + door_left_cut_y, cut_style
        ) if door_left_cut_x

        line(
          x + door_right_cut_x, y, x + door_right_cut_x,
          y + door_right_cut_y, cut_style
        ) if door_right_cut_x
      end # end checking for rotation

      group = Rasem::SVGTag.new('g')
      cuts.each do |res|
        group.line(*res[:args])
      end

      group
    end

    private

    def cut_style
      {
        stroke: 'black',
        fill: 'none',
        stroke_width: 1
      }
    end

    def line(*args)
      cuts << { args: args }
    end
  end
end
