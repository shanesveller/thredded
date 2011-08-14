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
    when /a "([^\"]+)" messageboard/i
      m = Factory(:messageboard, :security => $1.to_sym)
      t = Factory(:topic, :messageboard => m)
      messageboard_topics_path(m)
    when /the add a new thread page for "([^\"]+)"/i
      m = Messageboard.where(:name =>$1).first
      new_messageboard_topic_path(m)
    when /the topic listing page/i
      m = Messageboard.first
      messageboard_topics_path(m)
    when /edit the latest thread/i
      m = Messageboard.first
      t = m.topics.latest.first
      edit_messageboard_topic_path(m, t)
    when /the most recently updated thread on "([^\"]+)"/i
      m = Messageboard.where(:name =>$1).first
      t = m.topics.latest.first
      messageboard_topic_path(m, t)
    when /the sign up page/i
      new_user_registration_path( THREDDED[:default_site] )
    when /the sign in page/i
      new_user_session_path( THREDDED[:default_site] )
    when /the password reset request page/i
      new_user_password_path( THREDDED[:default_site] )

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

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
