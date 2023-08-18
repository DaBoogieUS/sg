class PanelModel < ActiveRecord::Base
  has_many :panels, dependent: :destroy

  validates :name, presence: true
  has_attached_file :panel_model_image, styles: {
    large: '540x720>', medium: '480x480>', thumb: '240x240>'
  }, default_url: '/images/:style/missing.png'
end
