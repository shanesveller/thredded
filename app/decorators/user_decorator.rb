class UserDecorator < SimpleDelegator
  attr_reader :user

  def initialize(user)
    super
    @user = user
  end

  def last_active_timeago
    if last_sign_in_at.nil?
      <<-eohtml.strip_heredoc.html_safe
        <abbr>
          not sure how long ago
        </abbr>
      eohtml
    else
      <<-eohtml.strip_heredoc.html_safe
        <abbr class="timeago" title="#{last_active_utc}">
          #{last_active_str}
        </abbr>
      eohtml
    end
  end

  def created_at_timeago
    if created_at.nil?
      <<-eohtml.strip_heredoc.html_safe
        <abbr>
          not sure how long ago
        </abbr>
      eohtml
    else
      <<-eohtml.strip_heredoc.html_safe
        <abbr class="timeago" title="#{created_at_utc}">
          #{created_at_str}
        </abbr>
      eohtml
    end
  end

  private

  def created_at_str
    created_at.getutc.to_s
  end

  def created_at_utc
    created_at.getutc.iso8601
  end

  def last_active_str
    last_sign_in_at.getutc.to_s
  end

  def last_active_utc
    last_sign_in_at.getutc.iso8601
  end
end
