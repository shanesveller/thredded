class Post  < ActiveRecord::Base
  require 'gravtastic'
  include Gravtastic
  gravtastic :user_email

  include BaseFilter
  include TextileFilter
  include BbcodeFilter
  include MarkdownFilter
  include SyntaxFilter
  include AttachmentFilter
  include EmojiFilter
  include AtNotificationFilter

  paginates_per 50

  attr_accessible :attachments_attributes,
    :content,
    :filter,
    :ip,
    :messageboard,
    :source,
    :topic,
    :user

  cattr_accessor(:notification_enabled) { true }

  default_scope order: 'id ASC'
  belongs_to :messageboard, counter_cache: true, touch: true
  belongs_to :topic, counter_cache: true
  belongs_to :user, counter_cache: true, touch: true
  has_many   :attachments
  has_many   :post_notifications

  accepts_nested_attributes_for :attachments

  validates :content, presence: true
  validates :messageboard_id, presence: true

  def create
    super &&
      modify_parent_topic
  end

  def create_or_update
    set_user_email &&
      super &&
      notify_at_users
  end

  private

  def modify_parent_topic
    topic.last_user = user
    topic.touch
    topic.save
  end

  def set_user_email
    self.user_email = user.email
  end

  def notify_at_users
    if self.notification_enabled
      AtNotifier.new(self).notifications_for_at_users
    else
      true
    end
  end
end
