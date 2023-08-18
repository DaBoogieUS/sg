module Draw
  class AreaHoles
    attr_accessor :scale
    attr_accessor :holes
    attr_accessor :part
    attr_accessor :panel
    attr_accessor :part_type
    attr_accessor :nest_obj_x
    attr_accessor :nest_obj_y
    attr_accessor :part_width
    attr_accessor :part_height
    attr_accessor :panel_door_width
    attr_accessor :panel_door_height
    attr_accessor :panel_door_inset
    attr_accessor :thickness
    attr_accessor :rotated

    attr_accessor :in_sm
    attr_accessor :in_md
    attr_accessor :in_lg
    attr_accessor :in_xl
    attr_accessor :in_xx

    def initialize(
      x:, y:, rotated:, scale:, part:, panel:,
      rectangle: false, circle: nil
    )
      @rotated = rotated
      @scale = scale
      @holes = Holes.new(
        scale: scale, rectangle_styles: rectangle,
        circle_styles: circle
      )
      @part_type = part.part_type.name
      @nest_obj_x = x
      @nest_obj_y = y
      @part_width = part.width
      @part_height = part.height
      @panel_door_width = panel.door_width
      @panel_door_height = panel.door_height
      @panel_door_inset = panel.door_inset_left
      @thickness = 0.125

      @in_sm = 0.5
      @in_md = 0.75
      @in_lg = 1
      @in_xl = 1.5
      @in_xx = 2
    end

    # draw hole pattern
    def draw
      is_deflector = part_type.match 'Deflector'
      is_dropdown = part_type.match 'Dropdown'
      is_removable = part_type.match 'Removable'
      if part_type == 'Standard Surface'
        standard_surface
      elsif is_removable
        removable_surface_rotated if rotated
        removable_surface unless rotated
      elsif is_dropdown
        dropdown_surface_rotated if rotated
        dropdown_surface unless rotated
      elsif is_deflector
        case part_type
        when 'Deflector'
          deflector
        when 'Deflector Bare'
          deflector_bare
        when 'Deflector Right'
          deflector_right
        when 'Deflector Left'
          deflector_left
        end
      end

      group = Rasem::SVGTag.new('g')
      holes.result.each do |res|
        group.rectangle(*res[:args]) if res[:type] == 'rectangle'
        group.circle(*res[:args]) if res[:type] == 'circle'
      end

      group
    end

    private

    def standard_surface
      if rotated
        # draw top holes
        holes.draw(
          nest_obj_x, nest_obj_y + part_width, part_width,
          in_sm, in_sm, 'BT'
        )
        # draw bottom holes
        holes.draw(
          nest_obj_x + (part_height - 1), nest_obj_y + 1, part_width - 2,
          in_sm, in_sm, 'TB'
        )
        # draw left side holes
        holes.draw(
          nest_obj_x + part_height, nest_obj_y + part_width - 1,
          part_height - 1,
          in_sm, in_sm, 'RL'
        )
        # draw right side holes
        holes.draw(
          nest_obj_x + part_height, nest_obj_y, part_height - 1,
          in_md, in_md, 'RL'
        )
      else
        # draw top holes
        holes.draw(
          nest_obj_x, nest_obj_y, part_width,
          in_sm, in_sm, 'LR'
        )
        # draw bottom holes
        holes.draw(
          nest_obj_x + (part_width - 1), nest_obj_y + part_height - 1,
          part_width - 2,
          in_sm, in_sm, 'RL'
        )
        # draw left side holes
        holes.draw(
          nest_obj_x, nest_obj_y + part_height, part_height - 1,
          in_sm, in_sm, 'BT'
        )
        # draw right side holes
        holes.draw(
          nest_obj_x + (part_width - 1), nest_obj_y + part_height,
          part_height - 1,
          in_md, in_md, 'BT'
        )
      end
    end

    def removable_surface
      # draw top holes
      holes.draw(nest_obj_x, nest_obj_y, part_width, in_sm, in_sm, 'LR')
      if part_type == 'Removable Surface Left'
        # draw bottom holes
        holes.draw(
          nest_obj_x + part_width, nest_obj_y + part_height - 2, part_width - 1,
          in_sm, in_sm, 'RL'
        )
        # draw left side holes
        holes.draw(
          nest_obj_x, nest_obj_y + part_height, part_height - 1,
          in_sm, in_sm, 'BT'
        )
        # draw right side holes
        holes.draw(
          nest_obj_x + (part_width - 1), nest_obj_y + part_height - 2,
          part_height - 3,
          in_sm, in_sm, 'BT'
        )
      else
        # draw bottom holes
        holes.draw(
          nest_obj_x + part_width - 1, nest_obj_y + part_height - 2,
          part_width - 1,
          in_sm, in_sm, 'RL'
        )
        # draw left side holes
        holes.draw(
          nest_obj_x, nest_obj_y + part_height - 2, part_height - 3,
          in_sm, in_sm, 'BT'
        )
        # draw right side holes
        holes.draw(
          nest_obj_x + (part_width - 1), nest_obj_y + part_height,
          part_height - 1,
          in_md, in_md, 'BT'
        )
      end
    end

    def removable_surface_rotated
      # draw top holes
      holes.draw(
        nest_obj_x, nest_obj_y + part_width, part_width,
        in_sm, in_sm, 'BT'
      )
      if part_type == 'Removable Surface Left'
        # draw left side holes
        holes.draw(
          nest_obj_x + part_height, nest_obj_y + part_width - 1,
          part_height - 1,
          in_sm, in_sm, 'RL'
        )
        # draw bottom holes
        holes.draw(
          nest_obj_x + (part_height - 2), nest_obj_y, (part_width - 1),
          in_sm, in_sm, 'TB'
        )
        # draw right side holes
        holes.draw(
          nest_obj_x + part_height - 2, nest_obj_y, part_height - 3,
          in_sm, in_sm, 'RL'
        )
      else
        # draw right side holes
        holes.draw(
          nest_obj_x + part_height, nest_obj_y, part_height - 1,
          in_md, in_md, 'RL'
        )
        # draw bottom holes
        holes.draw(
          nest_obj_x + (part_height - 2), nest_obj_y + 1, part_width - 1,
          in_sm, in_sm, 'TB'
        )
        # draw left side holes
        holes.draw(
          nest_obj_x + part_height - 2, nest_obj_y + part_width - 1,
          part_height - 3,
          in_sm, in_sm, 'RL'
        )
      end
    end

    def dropdown_surface
      # horizontal support
      holes.draw(
        nest_obj_x + (part_width - 1), nest_obj_y + panel_door_height,
        part_width - 2,
        in_sm, in_sm, 'RL'
      )
      # bottom
      holes.draw(
        nest_obj_x + (part_width - 1), nest_obj_y + part_height - 1,
        part_width - 2,
        in_sm, in_sm, 'RL'
      )

      if ['Dropdown Right Surface', 'Dropdown Inset Surface'].include? part_type
        # inner left side
        holes.draw(
          nest_obj_x + panel_door_inset, nest_obj_y + panel_door_height,
          panel_door_height - 1,
          in_sm, in_sm, 'BT'
        )
        # standard left side
        holes.draw(
          nest_obj_x, nest_obj_y + part_height, part_height - 1,
          in_sm, in_sm, 'BT'
        )
        # vertical support left
        holes.draw(
          nest_obj_x + panel_door_inset - 1,
          nest_obj_y + part_height - thickness,
          part_height - (thickness * 2),
          in_sm, in_sm, 'BT'
        )
        # top left
        holes.draw(
          nest_obj_x, nest_obj_y, panel_door_inset - 1,
          in_sm, in_sm, 'LR'
        )
      end
      if ['Dropdown Left Surface', 'Dropdown Inset Surface'].include? part_type
        # inner right side
        holes.draw(
          nest_obj_x + panel_door_inset + panel_door_width - 1,
          nest_obj_y + panel_door_height,
          panel_door_height - 1,
          in_sm, in_sm, 'BT'
        )
        # standard right side
        holes.draw(
          nest_obj_x + (part_width - 1), nest_obj_y + part_height,
          part_height - 1,
          in_md, in_md, 'BT'
        )
        # vertical support right
        holes.draw(
          nest_obj_x + panel_door_width + panel_door_inset,
          nest_obj_y + part_height - thickness,
          part_height - (thickness * 2),
          in_sm, in_sm, 'BT'
        )
        # top right
        holes.draw(
          nest_obj_x + panel_door_inset + panel_door_width + 1, nest_obj_y,
          part_width - (panel_door_inset + panel_door_width) - 1,
          in_sm, in_sm, 'LR'
        )
      end
      if ['Dropdown Left Surface', 'Dropdown Full Surface'].include? part_type
        # inner left side
        holes.draw(
          nest_obj_x + panel_door_inset + 1, nest_obj_y + panel_door_height,
          panel_door_height - 1,
          in_sm, in_sm, 'BT'
        )
        # vertical support side left
        holes.draw(
          nest_obj_x, nest_obj_y + part_height, part_height - thickness,
          in_sm, in_sm + panel_door_height - thickness, 'BT'
        )
      end
      if ['Dropdown Right Surface', 'Dropdown Full Surface'].include? part_type
        # inner right side
        holes.draw(
          nest_obj_x + part_width - 2, nest_obj_y + panel_door_height,
          panel_door_height - 1,
          in_sm, in_sm, 'BT'
        )
        # vertical support side right
        holes.draw(
          nest_obj_x + part_width - 1, nest_obj_y + part_height,
          part_height - thickness,
          in_md, in_md + panel_door_height - thickness, 'BT'
        )
      end

      # door tops & bottoms
      case part_type
      when 'Dropdown Full Surface'
        holes.draw(
          nest_obj_x, nest_obj_y, panel_door_width,
          in_xl, in_xl, 'LR'
        )
        holes.draw(
          nest_obj_x + part_width - 2, nest_obj_y + panel_door_height - 1,
          panel_door_width - 4,
          in_sm, in_sm, 'RL'
        )
      when 'Dropdown Inset Surface'
        holes.draw(
          nest_obj_x + panel_door_inset - 1, nest_obj_y, panel_door_width + 2,
          in_xl, in_xl, 'LR'
        )
        holes.draw(
          nest_obj_x + panel_door_inset + panel_door_width - 1,
          nest_obj_y + panel_door_height - 1,
          panel_door_width - 2,
          in_sm, in_sm, 'RL'
        )
      when 'Dropdown Left Surface'
        holes.draw(
          nest_obj_x, nest_obj_y, panel_door_width + 1,
          in_xl, in_xl, 'LR'
        )
        holes.draw(
          nest_obj_x + panel_door_width - 1, nest_obj_y + panel_door_height - 1,
          panel_door_width - 3,
          in_sm, in_sm, 'RL'
        )
      when 'Dropdown Right Surface'
        holes.draw(
          nest_obj_x + panel_door_inset - 1, nest_obj_y, panel_door_width + 1,
          in_xl, in_xl, 'LR'
        )
        holes.draw(
          nest_obj_x + part_width - 2, nest_obj_y + panel_door_height - 1,
          panel_door_width - 3,
          in_sm, in_sm, 'RL'
        )
      end
    end

    def dropdown_surface_rotated
      # horizontal support
      holes.draw(
        nest_obj_x + panel_door_height, nest_obj_y + 1, (part_width - 2),
        in_sm, in_sm, 'TB'
      )
      # bottom
      holes.draw(
        nest_obj_x + (part_height - 1), nest_obj_y + 1, (part_width - 2),
        in_sm, in_sm, 'TB'
      )

      if ['Dropdown Right Surface', 'Dropdown Inset Surface'].include? part_type
        # inner left side
        holes.draw(
          nest_obj_x + panel_door_height,
          nest_obj_y + part_width - panel_door_inset - 1,
          panel_door_height - 1,
          in_sm, in_sm, 'RL'
        )
        # standard left side
        holes.draw(
          nest_obj_x + part_height, nest_obj_y + part_width - 1,
          part_height - 1,
          in_sm, in_sm, 'RL'
        )
        # vertical support left
        holes.draw(
          nest_obj_x + part_height - thickness,
          nest_obj_y + part_width - panel_door_inset,
          part_height - (thickness * 2),
          in_sm, in_sm, 'RL'
        )
        # top left
        holes.draw(
          nest_obj_x, nest_obj_y + part_width, panel_door_inset - 1,
          in_sm, in_sm, 'BT'
        )
      end
      if ['Dropdown Left Surface', 'Dropdown Inset Surface'].include? part_type
        # inner right side
        holes.draw(
          nest_obj_x + panel_door_height,
          nest_obj_y + part_width - (panel_door_inset + panel_door_width),
          panel_door_height - 1,
          in_sm, in_sm, 'RL'
        )
        # standard right side
        holes.draw(
          nest_obj_x + part_height, nest_obj_y, part_height - 1,
          in_md, in_md, 'RL'
        )
        # vertical support right
        holes.draw(
          nest_obj_x + part_height - thickness,
          nest_obj_y + part_width - (panel_door_width + panel_door_inset) - 1,
          part_height - (thickness * 2),
          in_sm, in_sm, 'RL'
        )
        # top right
        holes.draw(
          nest_obj_x,
          nest_obj_y + part_width - panel_door_inset - panel_door_width - 1,
          part_width - (panel_door_inset + panel_door_width) - 1,
          in_sm, in_sm, 'BT'
        )
      end
      if ['Dropdown Left Surface', 'Dropdown Full Surface'].include? part_type
        # inner left side
        holes.draw(
          nest_obj_x + panel_door_height, nest_obj_y + part_width - 2,
          panel_door_height - 1,
          in_sm, in_sm, 'RL'
        )
        # vertical support side left
        holes.draw(
          nest_obj_x + part_height, nest_obj_y + part_width - 1,
          part_height - thickness,
          in_sm, in_sm + panel_door_height - thickness, 'RL'
        )
      end
      if ['Dropdown Right Surface', 'Dropdown Full Surface'].include? part_type
        # inner right side
        holes.draw(
          nest_obj_x + panel_door_height, nest_obj_y + 1, panel_door_height - 1,
          in_sm, in_sm, 'RL'
        )
        # vertical support side right
        holes.draw(
          nest_obj_x + part_height, nest_obj_y, part_height - thickness,
          in_md, in_md + panel_door_height - thickness, 'RL'
        )
      end

      # door tops & bottoms
      case part_type
      when 'Dropdown Full Surface'
        holes.draw(
          nest_obj_x, nest_obj_y + panel_door_width, panel_door_width,
          in_xl, in_xl, 'BT'
        )
        holes.draw(
          nest_obj_x + panel_door_height - 1, nest_obj_y + 2,
          panel_door_width - 4,
          in_sm, in_sm, 'TB'
        )
      when 'Dropdown Inset Surface'
        holes.draw(
          nest_obj_x, nest_obj_y + part_width - panel_door_inset + 1,
          panel_door_width + 2,
          in_xl, in_xl, 'BT'
        )
        holes.draw(
          nest_obj_x + panel_door_height - 1,
          nest_obj_y + part_width - panel_door_inset - panel_door_width + 1,
          panel_door_width - 2,
          in_sm, in_sm, 'TB'
        )
      when 'Dropdown Left Surface'
        holes.draw(
          nest_obj_x, nest_obj_y + part_width, panel_door_width + 1,
          in_xl, in_xl, 'BT'
        )
        holes.draw(
          nest_obj_x + panel_door_height - 1,
          nest_obj_y + part_width - panel_door_width + 1,
          panel_door_width - 3,
          in_sm, in_sm, 'TB'
        )
      when 'Dropdown Right Surface'
        holes.draw(
          nest_obj_x, nest_obj_y + part_width - panel_door_inset + 1,
          panel_door_width + 1,
          in_xl, in_xl, 'BT'
        )
        holes.draw(
          nest_obj_x + panel_door_height - 1, nest_obj_y + 2,
          panel_door_width - 3,
          in_sm, in_sm, 'TB'
        )
      end
    end

    def deflector
      # cool way of detecting proximity
      inner_inset = 0
      if rotated
        # draw top left holes
        holes.draw(
          nest_obj_x, nest_obj_y + part_width, part_width / 2,
          in_xx, inner_inset, 'BT'
        )
        # draw top right holes
        holes.draw(
          nest_obj_x, nest_obj_y, part_width / 2,
          in_xx, inner_inset, 'TB'
        )
        # draw left side holes
        holes.draw(
          nest_obj_x + 1, nest_obj_y + part_width - 1, part_height - 1,
          in_lg, in_lg, 'LR'
        )
        # draw right side holes
        holes.draw(
          nest_obj_x + 1, nest_obj_y, part_height - 1,
          in_lg, in_lg, 'LR'
        )
      else
        # draw top left holes
        holes.draw(
          nest_obj_x, nest_obj_y, part_width / 2,
          in_xx, inner_inset, 'LR'
        )
        # draw top right holes
        holes.draw(
          nest_obj_x + part_width, nest_obj_y, part_width / 2,
          in_xx, inner_inset, 'RL'
        )
        # draw left side holes
        holes.draw(
          nest_obj_x, nest_obj_y + 1, part_height - 1,
          in_lg, in_lg, 'TB'
        )
        # draw right side holes
        holes.draw(
          nest_obj_x + part_width - 1, nest_obj_y + 1, part_height - 1,
          in_lg, in_lg, 'TB'
        )
      end
    end

    def deflector_bare
      # rotated
      if rotated
        # draw top left holes
        holes.draw(
          nest_obj_x, nest_obj_y + part_width, part_width,
          in_lg, in_lg, 'BT'
        )
      else
        # draw top left holes
        holes.draw(
          nest_obj_x, nest_obj_y, part_width,
          in_lg, in_lg, 'LR'
        )
      end
    end

    def deflector_right
      # rotated
      if rotated
        # draw top left holes
        holes.draw(
          nest_obj_x, nest_obj_y, part_width,
          in_xx, in_lg, 'TB'
        )
        # draw right side holes
        holes.draw(
          nest_obj_x + 1, nest_obj_y, part_height - 1,
          in_lg, in_lg, 'LR'
        )
      else
        # draw top left holes
        holes.draw(
          nest_obj_x + part_width, nest_obj_y, part_width,
          in_xx, in_lg, 'RL'
        )
        # draw right side holes
        holes.draw(
          nest_obj_x + part_width - 1, nest_obj_y + 1, part_height - 1,
          in_lg, in_lg, 'TB'
        )
      end
    end

    def deflector_left
      if rotated
        # draw top left holes
        holes.draw(
          nest_obj_x, nest_obj_y + part_width, part_width,
          in_xx, in_lg, 'BT'
        )
        # draw left side holes
        holes.draw(
          nest_obj_x + 1, nest_obj_y + part_width - 1, part_height - 1,
          in_lg, in_lg, 'LR'
        )
      else
        # draw top left holes
        holes.draw(
          nest_obj_x, nest_obj_y, part_width,
          in_xx, in_lg, 'LR'
        )
        # draw left side holes
        holes.draw(
          nest_obj_x, nest_obj_y + 1, part_height - 1,
          in_lg, in_lg, 'TB'
        )
      end
    end
  end
end
