class Client < ActiveRecord::Base
  has_many :jobs

  validates :name, presence: true

  def job_count
    1000 - jobs.count
  end
end
