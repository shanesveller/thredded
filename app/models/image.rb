class Image < ActiveRecord::Base

  # include Mongoid::Document
  # include Mongoid::Timestamps
  # field :width, :type => Integer
  # field :height, :type => Integer
  # field :orientation
  # referenced_in :post

  # CarrierWave
  # mount_uploader :image, ImageUploader
  validates_presence_of :image
  before_validation :save_dimensions, :save_orientation, :save_position
  
private

  def save_dimensions
    if image.path
      self.width = MiniMagick::Image.open(image.path)[:width]
      self.height = MiniMagick::Image.open(image.path)[:height]
    end
  end

  def save_orientation
    if image.path
      self.orientation = (height.to_i > width.to_i) ? 'portrait' : 'landscape'
    end
  end

  def save_position
    self.position = (self._index + 1) if self.new_record? and self._index
  end

end
