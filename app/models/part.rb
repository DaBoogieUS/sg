class Part < ActiveRecord::Base
  belongs_to :part_type
  belongs_to :panel
  has_many :nest_objects, dependent: :destroy
  has_and_belongs_to_many :manufacturing_jobs

  delegate :material, to: :part_type, allow_nil: true
  delegate :material_type, to: :material
  delegate :panel_letter, to: :panel

  after_update :update_panel
  after_create :draw_svg

  after_initialize do
    # self.is_manufactured = false if self.new_record?
  end

  def area
    return 0 unless material_type == 'area'
    width * height
  end

  # get manufactured status
  def manufactured_status
    part_manufactured = true
    if self.nest_objects.empty?
      self.nest_objects.each do |nest_obj|
        part_manufactured = false unless nest_obj.nest.is_manufactured
      end
    else
      part_manufactured = false
    end
    part_manufactured
  end

  # update part manufactured status
  def update_manufactured_status
    self.update_attributes(is_manufactured: manufactured_status)
  end

  # on update, change its nest objects parts to manufactured if it is manufactured
  def update_panel
    panel = self.panel
    if self.is_manufactured
      manufactured = true
      panel.parts.each do |part|
        manufactured = false unless part.is_manufactured
      end
      panel.update_attributes(is_manufactured: true) if manufactured
    else
      panel.update_attributes(is_manufactured: false)
    end
  end

  def get_inches(i)
    whole, num, den = i.to_whole_fraction
    string = num > 0 ? "#{whole} #{num}/#{den}" : whole.to_s
    "#{string}\""
  end

  def scope_name
    panel_name = panel_letter
    structure = panel.structure.name
    part_type = self.part_type
    extra = if part_type.material.material_type == 'length'
              get_inches(self.length.to_i)
            else
              "w#{get_inches(width.to_i)} h#{get_inches(height.to_i)}"
            end
    type = part_type.name
    "#{structure}#{panel_name}: #{type} #{extra}"
  end

  def draw_svg
    return unless material_type == 'area'
    self.svg = draw
    self.save!
  end

  def draw
    PartService.new.draw(part: self)
  end
end
