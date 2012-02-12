class Attachment < ActiveRecord::Base
  belongs_to :post
  attr_accessible :attachment
  mount_uploader :attachment, AttachmentUploader
end
