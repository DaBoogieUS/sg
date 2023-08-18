module Draw
  class AreaBody
    attr_accessor :scale
    attr_accessor :part
    attr_accessor :x
    attr_accessor :y
    attr_accessor :part_width
    attr_accessor :part_height
    attr_accessor :rotated
    attr_accessor :cuts
    attr_accessor :cut_styles

    def initialize(x:, y:, rotated:, scale:, part:, cut_styles: nil)
      @cut_styles = cut_styles || cut_style
      @cuts = []
      @rotated = rotated
      @scale = scale
      @x = x * scale
      @y = y * scale
      @part_width = part.width * scale
      @part_height = part.height * scale
    end

    # draw hole pattern
    def draw
      # if rotated
      if rotated
        # draw perimeter
        rectangle(x, y, part_height, part_width, cut_styles)
      # if not rotated
      else
        # draw perimeter
        rectangle(x, y, part_width, part_height, cut_styles)
      end # end checking for rotation

      group = Rasem::SVGTag.new('g')
      cuts.each do |res|
        group.rectangle(*res[:args])
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

    def rectangle(*args)
      cuts << { args: args }
    end
  end
end
