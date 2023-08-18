class Job < ActiveRecord::Base
  belongs_to :client
  has_many :phases

  validates :name, presence: true

  def phase_count
    1000 - phases.length
  end
end
