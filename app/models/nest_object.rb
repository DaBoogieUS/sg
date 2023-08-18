class NestObject < ActiveRecord::Base
  belongs_to :nest
  belongs_to :part

  def draw_service
    @draw_nest_object_cache ||= DrawNestObject::Interface.new(nest_object: self)
  end
end
