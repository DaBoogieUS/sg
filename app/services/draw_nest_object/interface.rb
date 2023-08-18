module DrawNestObject
  class Interface
    attr_accessor :nest_object
    attr_accessor :part
    attr_accessor :panel
    attr_accessor :material_type

    def initialize(nest_object:)
      @nest_object = nest_object
      @part = nest_object.part
      @panel = part.panel
      @material_type = part.material_type
    end

    def draw_body(nest_svg:, scale:)
      return nil if material_type == 'length'
      draw_svg_service.area_body(scale: scale)
    end

    def draw_cuts(nest_svg:, scale:)
      return nil if material_type == 'length'
      draw_svg_service.area_cuts(scale: scale)
    end

    def draw_scores(nest_svg:, scale:)
      return nil if material_type == 'length'
      draw_svg_service.area_scores(scale: scale)
    end

    def draw_holes(nest_svg:, scale:)
      return nil if material_type == 'length'
      draw_svg_service.area_holes(scale: scale)
    end

    def draw_map(nest_svg:, scale:)
      case material_type
      when 'length'
        draw_map_service.length(nest_svg: nest_svg, scale: scale)
      when 'area'
        draw_map_service.area(nest_svg: nest_svg, scale: scale)
      end
    end

    def draw_map_service
      @draw_map_service_cache ||= DrawMap.new(
        nest_object: nest_object, part: part, panel: panel,
        material_type: material_type
      )
    end

    def draw_svg_service
      @draw_svg_service_cache ||= DrawSvg.new(
        nest_object: nest_object, part: part, panel: panel,
        material_type: material_type
      )
    end
  end
end
