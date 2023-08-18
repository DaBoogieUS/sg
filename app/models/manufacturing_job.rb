class ManufacturingJob < ActiveRecord::Base
  belongs_to :phase
  has_many :nest_runs, dependent: :destroy
  has_many :nests, through: :nest_runs
  has_many :nest_objects, through: :nests
  has_and_belongs_to_many :parts

  after_create do
    # create nest runs
    NestRunService.new.create(manufacturing_job: self, parts: parts)
  end

  before_destroy :update_manufactured_statuses

  def progress
    nests = self.nests
    tasks = nests.length
    completed = nests.where(is_manufactured: true).length.to_f
    ratio = ((completed / tasks) * 100).to_f
    return 0 if ratio.nan?
    ratio = ratio > 0 ? ratio : 0
    ratio.round(0)
  end

  def percentage
    prog = progress
    return 5 if prog > 0 && prog < 5
    5 * (prog / 5).round
  end

  def update_manufactured_statuses
    parts.each do |part|
      # update parts
      part.update_manufactured_status
      # update panels
      part.panel.update_manufactured_status
    end
  end

  def mfg_job_name
    return nil unless name
    "#{name} Job"
  end
end
