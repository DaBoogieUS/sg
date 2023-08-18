class Structure < ActiveRecord::Base
  belongs_to :phase
  has_many :panels, dependent: :destroy
  has_many :parts, through: :panels, dependent: :destroy

  attr_accessor :quick_w, :quick_l, :quick_h, :quick_def, :quick_bur

  accepts_nested_attributes_for :panels, reject_if: :all_blank, allow_destroy: true
  validates :phase_id, :name, presence: true

  after_create :create_panels
  before_destroy :clear_old_parts

  def name_number
    name = self.name
    return 0 unless name
    number = name.scan(/\d+$/).first
    # if number
    number.to_i
  end

  def clear_old_parts
    phase.parts.each do |part|
      part.destroy unless part.panel
    end
  end

  def manufacturing_jobs
    mfg_jobs = []
    parts.each do |part|
      part.nest_objects.each do |nest_obj|
        nest = nest_obj.nest
        nest_run = nest.nest_run
        mfg_jobs.push(nest_run.manufacturing_job_id)
      end
    end
    mfg_jobs.uniq
  end

  def progress
    tasks = (panels.count * 2) + parts.count
    ap parts.where(is_manufactured: true)
    manufactured = parts.where(is_manufactured: true).count.to_f
    assembled = (panels.where(is_assembled: true).count.to_f * 2)
    completed = manufactured + assembled

    ap 'here we go'
    ap 'YOYOYO'
    ap "YO: #{manufactured} #{assembled} #{parts.count}"
    ((completed / tasks) * 100).to_f.round(0)
  end

  def percentage
    return 5 if progress > 0 && progress < 5
    5 * (progress / 5).round
  end

  def create_panels
    panel_model = PanelModel.find_by(name: 'Standard Panel v1').id
    # first panel (w)
    # second panel (l)
    # third panel (w)
    # fourth panel (l)
    (1..4).each do |i|
      w = i.even? ? self.quick_l : self.quick_w
      self.panels.create(
        panel_model_id: panel_model, side_position: i.to_s,
        width: w, height: self.quick_h, deflector: self.quick_def,
        buried: self.quick_bur, door_width: 0, door_height: 0,
        door_inset_left: 0, is_manufactured: false, is_assembled: false
      )
    end
  end
end
