class MessageboardDecorator < SimpleDelegator
  include ActionView::Helpers::NumberHelper
  attr_reader :messageboard

  def initialize(messageboard)
    super
    @messageboard = messageboard
  end

  def original
    messageboard
  end

  def category_options
    messageboard.categories.collect { |cat| [cat.name, cat.id] }
  end

  def users_options
    messageboard.users.collect{ |user| [user.name, user.id] }
  end

  def meta
    topics = topics_count
    posts  = posts_count
    "#{number_to_human topics} topics, #{number_to_human posts} posts".downcase
  end

  def updated_at_timeago
    if updated_at.nil?
      <<-eohtml.strip_heredoc.html_safe
        <abbr>
          a little while ago
        </abbr>
      eohtml
    else
      <<-eohtml.strip_heredoc.html_safe
        <abbr class="timeago" title="#{updated_at_utc}">
          #{updated_at_str}
        </abbr>
      eohtml
    end
  end

  def latest_user
    if topics.any? && topics.first.last_user.present?
      topics.first.last_user.name
    else
      ''
    end
  end

  private

  def updated_at_str
    updated_at.to_s
  end

  def updated_at_utc
    updated_at.getutc.iso8601
  end
end
