class Panel < ActiveRecord::Base
  belongs_to :structure
  belongs_to :panel_model
  has_many :parts, dependent: :destroy
  has_many :nest_objects, through: :parts

  accepts_nested_attributes_for :parts, reject_if: :all_blank, allow_destroy: true
  validates :structure_id, :panel_model_id, :side_position, :width, :height, presence: true

  after_create :create_new_parts
  after_create :generate_sides
  after_create :generate_buried
  before_destroy :destroyed_position_assignment
  after_destroy :generate_sides
  after_destroy :generate_buried
  before_update :update_manufactured_status
  after_update :update_all_the_things

  delegate :position_panels, to: :panel_service
  delegate :generate_sides, to: :panel_service
  delegate :generate_buried, to: :panel_service
  delegate :create_new_parts, to: :panel_service

  def panel_letter
    letters = ('A'..'Z').to_a
    letters[self.side_position - 1]
  end

  def manufacturing_progress
    parts = self.parts
    tasks = self.parts.length
    manufactured = parts.where(is_manufactured: true).length.to_f
    completed = manufactured
    ((completed / tasks) * 100).to_f.round(0)
  end

  def percentage
    prog = manufacturing_progress
    return 5 if prog > 0 && prog < 5
    5 * (prog / 5).round
  end

  ###
  # callbacks
  ###

  # get manufactured status
  def load_manufactured_status
    part_manufactured = true
    self.parts.each do |part|
      part_manufactured = false unless part.is_manufactured
    end
    part_manufactured
  end

  # update panel manufactured status
  def update_manufactured_status
    part_manufactured = load_manufactured_status
    if part_manufactured == false
      # un-manufacture panel
      if self.is_manufactured == true
        self.update_attributes(is_manufactured: false)
      end
      # un-assemble panel
      self.update_attributes(is_assembled: false) if self.is_assembled
    elsif !self.is_manufactured
      # manufacture panel
      self.update_attributes(is_manufactured: true)
    end
  end

  # rearranging if needed upon deletion
  def destroyed_position_assignment
    # for each panel in structure
    panels = self.structure.panels
    # if other panels exist
    if panels.length > 1
      # current panel position
      panel_position = self.side_position
      # if destroyed panel does not have last position
      if panel_position != panels.length
        # get panel in last position
        last_panel = panels.find_by(side_position: panels.length)
        # if last panel exists
        if last_panel
          # give panel destroyed panel's position
          last_panel.update_attribute(:side_position, panel_position)
        end # end last panel exists
      end # end if destroyed does not have last position
    end # end if panels.length > 1
  end # end destroyed position assignment

  # remove all of panel's parts
  def remove_existing_parts
    Part.where(panel_id: id).destroy_all
  end

  def update_all_the_things
    return if changed.empty?
    man_or_ass_or_side = changed.include?('is_manufactured') ||
                         changed.include?('is_assembled') ||
                         changed.include?('side_position')
    unless changed.length == 1 && man_or_ass_or_side
      # remove panel's existing parts
      remove_existing_parts
      # create parts for the panel
      create_new_parts
      # generate sides for the structure
      generate_sides
      # generate buried
      generate_buried
      # position panels
      position_panels
    end
  end

  def panel_service
    @panel_service_cache ||= PanelService.new(panel: self)
  end
end
