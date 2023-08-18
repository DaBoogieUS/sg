module DrawNestObject
  class Base
    attr_accessor :nest_object
    attr_accessor :part
    attr_accessor :panel
    attr_accessor :material_type

    def initialize(nest_object:, part:, panel:, material_type:)
      @nest_object = nest_object
      @part = part
      @panel = panel
      @material_type = material_type
    end
  end
end
