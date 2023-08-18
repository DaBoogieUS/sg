module Draw
  class Holes
    attr_accessor :scale
    attr_accessor :diameter
    attr_accessor :radius
    attr_accessor :center
    attr_accessor :spacing
    attr_accessor :scaled_x
    attr_accessor :scaled_y
    attr_accessor :scaled_length
    attr_accessor :scaled_in_1
    attr_accessor :scaled_in_2
    attr_accessor :x
    attr_accessor :y
    attr_accessor :length
    attr_accessor :in_1
    attr_accessor :in_2
    attr_accessor :direction
    attr_accessor :circle_styles
    attr_accessor :rectangle_styles
    attr_accessor :result

    def initialize(circle_styles: nil, rectangle_styles: nil, scale: 72)
      @scale = scale
      @circle_styles = circle_styles || circle_style
      @rectangle_styles = rectangle_styles
      @result = []
    end

    # draw hole pattern
    def draw(x, y, length, in_1, in_2, direction)
      @x = x
      @y = y
      @length = length
      @in_1 = in_1
      @in_2 = in_2
      @direction = direction

      calculate
      run
    end

    private

    def calculate
      @diameter = 0.25 * scale
      @radius = diameter / 2
      @center = diameter * 2
      @spacing = 4 * scale
      @scaled_x = x * scale
      @scaled_y = y * scale
      @scaled_length = length * scale
      @scaled_in_1 = in_1 * scale
      @scaled_in_2 = in_2 * scale
    end

    def run
      case direction
      when 'LR'
        left_to_right_rect if rectangle_styles
        left_to_right_line
        left_to_right_cap
      when 'RL'
        right_to_left_rect if rectangle_styles
        right_to_left_line
        right_to_left_cap
      when 'BT'
        bottom_to_top_rect if rectangle_styles
        bottom_to_top_line
        bottom_to_top_cap
      when 'TB'
        top_to_bottom_rect if rectangle_styles
        top_to_bottom_line
        top_to_bottom_cap
      end
    end

    def circle(*args)
      @result << { type: 'circle', args: args }
    end

    def rectangle(*args)
      @result << { type: 'rectangle', args: args }
    end

    # left_to_right

    def left_to_right_rect
      rectangle(scaled_x, scaled_y, scaled_length, scale, rectangle_styles)
    end

    def left_to_right_cap
      @scaled_x = x * scale
      return unless in_2 > 0
      circle(
        scaled_x + scaled_length - scaled_in_2,
        scaled_y + center, radius, circle_styles
      )
    end

    def left_to_right_line
      while scaled_x + scaled_in_1 + scaled_in_2 < (x * scale) + scaled_length
        circle(
          scaled_x + scaled_in_1, scaled_y + center,
          radius, circle_styles
        )
        @scaled_x += spacing
      end
    end

    # right_to_left

    def right_to_left_rect
      rectangle(
        scaled_x - scaled_length, scaled_y,
        scaled_length, scale, rectangle_styles
      )
    end

    def right_to_left_cap
      @scaled_x = x * scale
      return unless in_2 > 0
      circle(
        scaled_x - scaled_length + scaled_in_2,
        scaled_y + center, radius, circle_styles
      )
    end

    def right_to_left_line
      while scaled_x > (x * scale) - scaled_length + scaled_in_1 + scaled_in_2
        circle(
          scaled_x - scaled_in_1, scaled_y + center,
          radius, circle_styles
        )
        @scaled_x -= spacing
      end
    end

    # bottom_to_top

    def bottom_to_top_rect
      rectangle(
        scaled_x, scaled_y - scaled_length, scale, scaled_length,
        rectangle_styles
      )
    end

    def bottom_to_top_cap
      @scaled_y = y * scale
      return unless in_2 > 0
      circle(
        scaled_x + center, (y * scale) - scaled_length + scaled_in_2,
        radius, circle_styles
      )
    end

    def bottom_to_top_line
      while scaled_y > (y * scale) - scaled_length + scaled_in_1 + scaled_in_2
        circle(
          scaled_x + center, scaled_y - scaled_in_1,
          radius, circle_styles
        )
        @scaled_y -= spacing
      end
    end

    # top_to_bottom

    def top_to_bottom_rect
      rectangle(scaled_x, scaled_y, scale, scaled_length, rectangle_styles)
    end

    def top_to_bottom_cap
      return unless in_2 > 0
      circle(
        scaled_x + center, (y * scale) + scaled_length - scaled_in_2,
        radius, circle_styles
      )
    end

    def top_to_bottom_line
      while scaled_y + scaled_in_1 + scaled_in_2 < (y * scale) + scaled_length
        circle(
          scaled_x + center, scaled_y + scaled_in_1,
          radius, circle_styles
        )
        @scaled_y += spacing
      end
    end

    def circle_style
      {
        stroke: 'black',
        fill: 'white',
        stroke_width: 0.5
      }
    end
  end
end
