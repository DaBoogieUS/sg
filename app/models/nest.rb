class Nest < ActiveRecord::Base
  belongs_to :nest_run
  has_many :nest_objects, dependent: :destroy
  has_many :parts, through: :nest_objects

  after_save :update_parts
  after_save :update_panels

  after_create :draw_svg

  # number index
  def number_index
    nests = nest_run.nests.order('created_at ASC').pluck(:id)
    nest_index = nests.index(id)
    (nest_index + 1).to_s
  end

  # update parts
  def update_parts
    parts.each(&:update_manufactured_status)
  end

  # update panels
  def update_panels
    parts.each do |part|
      part.panel.update_manufactured_status
    end # end parts loop
  end

  # get waste in inches
  def waste_in_inches
    the_nest_run = nest_run
    material = the_nest_run.material
    used = 0

    case material.material_type
    when 'area'
      size = material.width * material.height
      nest_objects.each do |obj|
        used += obj.part.width * obj.part.height
      end
    when 'length'
      size = length
      nest_objects.each { |obj| used += obj.part.length }
    else
      size = 0
    end

    # get wasted remainder
    # return waste
    size - used
  end

  def draw_svg
    self.svg = draw unless nest_run.material_type == 'length'
    self.map_svg = draw_map
    self.save!
  end

  private

  def draw_map
    NestService.new.draw_map(nest: self)
  end

  # draw nest svg
  # dependent on nests directory inside of public/system
  def draw
    NestService.new.draw(nest: self)
  end
end
