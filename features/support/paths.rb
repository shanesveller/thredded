module NavigationHelpers
  def path_to(page_name)
    case page_name

    when /the homepage/
      '/'

    when /my profile page/i
      '/users/edit'

    when /the user profile page for "([^\"]+)"/i
      @user = User.find_by_name($1)
      user_path(@user)

    when /a user profile that doesn\'t exist/i
      '/users/dkjflsdfdf'

    when /the forgot password page/i
      new_user_password_path

    when /the messageboard "([^\"]+)"/i
      messageboard = Messageboard.where(name: $1).first
      messageboard_topics_url(messageboard)

    when /the new thread page for "([^\"]+)"/i
      messageboard = Messageboard.where(name: $1).first
      new_messageboard_topic_url(messageboard)

    when /the new private thread page for "([^\"]+)"/i
      messageboard = Messageboard.where(name: $1).first
      new_messageboard_private_topic_url(messageboard)

    when /the forum listing page/i
      messageboards_path

    when /the topic listing page/i
      messageboard = Messageboard.first
      messageboard_topics_url(messageboard)

    when /edit the latest thread/i
      messageboard = Messageboard.first
      topic = messageboard.topics.first
      edit_messageboard_topic_url(messageboard, topic)

    when /the latest thread/i
      messageboard = Messageboard.first
      topic = messageboard.topics.first
      messageboard_topic_url(messageboard, topic)

    when /the most recently updated thread on "([^\"]+)"/i
      messageboard = Messageboard.where(name: $1).first
      topic = messageboard.topics.first
      messageboard_topic_posts_url(messageboard.name, topic.slug)

    when /the sign up page/i
      new_user_registration_path

    when /the sign in page/i
      new_user_session_path

    when /the password reset request page/i
      new_user_password_path

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
