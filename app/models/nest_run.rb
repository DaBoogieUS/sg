class NestRun < ActiveRecord::Base
  belongs_to :manufacturing_job
  belongs_to :material
  has_many :nests, dependent: :destroy
  has_many :nest_objects, through: :nests

  delegate :material_type, to: :material

  # create nest runs
  after_create :create_nests

  def progress
    tasks = nests.length
    completed = nests.where(is_manufactured: true).length.to_f
    ((completed / tasks) * 100).to_f.round(0)
  end

  def percentage
    return 5 if progress > 0 && progress < 5
    5 * (progress / 5).round
  end

  # nest mfg job name
  def nest_mfg_job_name
    "Mfg Job \"#{manufacturing_job.name}\""
  end

  # nest material name
  def nest_material_name
    "#{material.name} Run"
  end

  # nest full name
  def nest_full_name
    [nest_mfg_job_name, nest_material_name].join(' ')
  end

  # sum waste in inches by adding all its nests' waste
  def waste_in_inches
    total_waste = 0
    nests.each { |nest| total_waste += nest.waste_in_inches }
    total_waste
  end

  # convert waste in inches to number of source materials
  def waste_in_material_quantity
    total_waste = waste_in_inches
    case material.material_type
    when 'length'
      waste_in_material = total_waste / material.length_options.first.to_f
    when 'area'
      waste_in_material = total_waste / (material.width * material.height)
    end
    waste_in_material.round(1)
  end

  # create nests
  def create_nests
    NestRunService.new.build_nests(nest_run: self)
  end # end create_nests
end
