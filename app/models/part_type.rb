class PartType < ActiveRecord::Base
  belongs_to :material
  has_many :parts, dependent: :destroy

  attr_writer :image_delete

  validates :name, presence: true
  has_attached_file :part_type_image, styles: {
    large: '540x720>', medium: '480x480>', thumb: '240x240>'
  }, default_url: '/images/:style/missing.png'

  before_save :destroy_image?

  def image_delete
    @image_delete ||= '0'
  end

  private

  def destroy_image?
    self.part_type_image.clear if @image_delete == '1'
  end
end
