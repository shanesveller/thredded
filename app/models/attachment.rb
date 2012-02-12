class Attachment < ActiveRecord::Base
  belongs_to :post
  validates_presence_of :attachment
  attr_accessible :attachment
  mount_uploader :attachment, AttachmentUploader

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end
  
end
