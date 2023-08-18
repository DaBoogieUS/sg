class Phase < ActiveRecord::Base
  belongs_to :job
  has_many :structures
  has_many :manufacturing_jobs
  has_many :panels, through: :structures
  has_many :parts, through: :panels

  accepts_nested_attributes_for :manufacturing_jobs, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :structures, reject_if: :all_blank, allow_destroy: true
  validates :job_id, :name, presence: true

  def progress
    tasks = (panels.count * 2) + parts.count
    manufactured = parts.where(is_manufactured: true).count.to_f
    assembled = panels.where(is_assembled: true).count.to_f * 2
    completed = manufactured + assembled
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
end
