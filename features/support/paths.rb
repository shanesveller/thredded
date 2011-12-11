module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the homepage/
      '/'

    when /the messageboard "([^\"]+)"/i
      messageboard = @site.messageboards.find_by_name($1)
      messageboard_url(messageboard, :host => @site.cached_domain)

    when /the new thread page for "([^\"]+)"/i
      messageboard = @site.messageboards.find_by_name($1)
      new_messageboard_topic_url(messageboard, :host => @site.cached_domain)

    when /the new private thread page for "([^\"]+)"/i
      messageboard = @site.messageboards.find_by_name($1)
      new_messageboard_topic_url(messageboard, :type => 'private', :host => @site.cached_domain)

    when /the topic listing page/i
      messageboard = @site.messageboards.first
      messageboard_url(messageboard, :host => @site.cached_domain)

    when /edit the latest thread/i
      messageboard = Messageboard.first
      topic = messageboard.topics.first
      edit_messageboard_topic_url(messageboard, topic, :host => @site.cached_domain)

    when /the most recently updated thread on "([^\"]+)"/i
      messageboard = @site.messageboards.find_by_name($1)
      topic = messageboard.topics.first
      messageboard_topic_url(messageboard, topic, :host => @site.cached_domain)

    when /the sign up page/i
      new_user_registration_url( :host => @site.cached_domain )

    when /the sign in page/i
      new_user_session_url( :host => @site.cached_domain )

    when /the password reset request page/i
      new_user_password_url( :host => @site.cached_domain )

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
