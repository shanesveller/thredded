class PostDecorator < SimpleDelegator
  attr_reader :post

  def initialize(post)
    super
    @post = post
  end

  def user_name
    if user
      user.name
    else
      'Anonymous'
    end
  end

  def original
    post
  end

  def created_date
    created_at.strftime("%b %d, %Y %I:%M:%S %Z") if created_at
  end

  def created_timestamp
    created_at.strftime("%Y-%m-%dT%H:%M:%S") if created_at
  end

  def gravatar_url
    super.gsub /http:/, ''
  end
end
