class Material < ActiveRecord::Base
  has_many :nest_runs
  has_many :part_types
  has_many :parts, through: :part_types

  validates :name, presence: true
  serialize :length_options, Array

  before_validation do |material|
    material.length_options.reject!(&:blank?) if material.length_options
  end
end
