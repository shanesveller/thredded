class EmailProcessor
  attr_accessor :email, :messageboard, :user

  def initialize(email)
    @email = email
    @user, @messageboard = extract_user_and_messageboard
  end

  def self.process(email)
    processor = self.new(email)
    processor.create_or_update_topic
  end

  def create_or_update_topic
    if can_post_to_topic?
      topic = find_or_build_topic
      topic.posts.build(
        user: user,
        user_email: user.email,
        content: email.body,
        source: 'email',
        messageboard: messageboard,
        attachments_attributes: attachment_params,
      )
      topic.save
    else
      return false
    end
  end

  def extract_user_and_messageboard
    user = User.where(email: email.from).first
    messageboard = Messageboard.where(name: messageboard_name).first
    user && messageboard ? [user, messageboard] : []
  end

  private

  def attachment_params
    @attachment_params = {}

    email.attachments.each_with_index do |attachment, i|
      @attachment_params[i.to_s] = { 'attachment' => attachment }
    end

    @attachment_params
  end

  def can_post_to_topic?
    user && messageboard &&
      Ability.new(user).can?(:create, messageboard.topics.new)
  end

  def find_or_build_topic
    topic = messageboard.topics.where(hash_id: topic_hash).first

    if topic.nil?
      topic = messageboard.topics.build(title: email.subject)
      topic.user = user
      topic.state = 'pending'
    end

    topic.last_user = user
    topic
  end

  def messageboard_name
    email.to.split('-')[0]
  end

  def topic_hash
    email.to.split('-')[1]
  end
end
