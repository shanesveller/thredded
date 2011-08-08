require "highline"

# A ginormous thank you to the Radiant CMS team for direction in how to implement the setup and bootstrapping of a project.
# For more information - https://github.com/radiant/radiant/blob/master/lib/radiant/setup.rb
# ... and - http://radiantcms.org

module Thredded
  class Setup

    class << self
      def bootstrap(config)
        setup = new
        setup.bootstrap(config)
        setup
      end

      def with_fake_content
        puts "Starting fake thread generation. Sit tight ..."
        
        Messageboard.delete_all
        Topic.delete_all
        Post.delete_all

        user = User.first

          2.times do |i|
            site = Site.find_or_create_by_slug(:slug => "site#{i}", :user => user)
            3.times do |j|
              messageboard = Messageboard.create(:name => "messageboard_#{j}", :site => site)
              50.times do
                topic = Topic.create(:user => user, :title => Faker::Lorem.words(5).join(' '), :messageboard => messageboard)
                10.times do
                  post = Post.create(:content => Faker::Lorem.paragraph, :user => user, :ip => "127.0.0.1", :topic => topic)
                end
              end
            end
          end

        puts "Finished. 2 fake sites, 6 fake boards, 300 fake threads and 3000 fake posts created."
      end
    end

    attr_accessor :config

    def bootstrap(config)
      @config     = config
      admin       = create_admin_user(config[:username], config[:email], config[:password])
      site_board  = create_site_and_messageboard(admin, config[:sitename], config[:messageboard], config[:security], config[:permission])
      first_topic = create_first_thread(admin, site_board)
      announce "Finished."
    end

    def create_first_thread(admin, messageboard)
      first_topic = messageboard.topics.create(:user => admin, :title => "Welcome to your site's very first thread")
      first_topic.save
      first_topic.posts.create(:content => "There's not a whole lot here for now.", :user => admin, :ip => "127.0.0.1")
      first_topic
    end

    def create_admin_user(username, email, password)
      unless username and email and password
        announce "Create the admin user (press enter for defaults)."
        username = prompt_for_username unless username
        email    = prompt_for_email    unless email
        password = prompt_for_password unless password
      end
      attributes = {
        :name     => username,
        :email    => email,
        :password => password
      }
      admin = User.where(:name => username).first || User.new
      admin.update_attributes(attributes)
      admin
    end

    # TODO : MAKE SURE SITE IS ACCURATELY BOOTSTRAPPED
    #
    def create_site_and_messageboard(user, sitename, messageboard, security, permission)
      unless sitename and messageboard and security
        announce "Create your messageboard (press enter for defaults)."
        # sitename     = prompt_for_sitename     unless sitename
        sitename     = "thredded"
        messageboard = prompt_for_messageboard unless messageboard
        security     = prompt_for_security     unless security
        permission   = prompt_for_permission   unless permission
      end

      #TODO: CREATE THE SITE OBJECT. Site doesn't exist yet.  Do it.
      new_site = Site.create(:user => user)

      attributes = {
        :name               => messageboard,
        :description        => "Another internet messageboard named #{messageboard}",
        :theme              => "default",
        :security           => security,
        :posting_permission => permission,
        :site               => new_site
      }
      new_messageboard = Messageboard.where(:name => messageboard).first || Messageboard.new
      new_messageboard.update_attributes(attributes)
      user.member_of(new_messageboard, 'admin')
      new_messageboard
    end

    def announce(string)
      puts "\n#{string}"
    end
    
    private 

      def prompt_for_username
        username = ask('Name (Admin): ', String) do |q|
          q.validate = /^.{0,100}$/
          q.responses[:not_valid] = "Invalid name. Must be at less than 100 characters long."
          q.whitespace = :strip
        end
        username = "Admin" if username.blank?
        username
      end
      
      def prompt_for_email
        email = ask('Email address: ', String) do |q|
          q.validate = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/
          q.responses[:not_valid] = "Invalid email address. Please make sure it is correct."
          q.whitespace = :strip
        end
        email
      end
      
      def prompt_for_password
        password = ask('Password (password): ', String) do |q|
          q.echo = '*'
          q.validate = /^(|.{5,40})$/
          q.responses[:not_valid] = "Invalid password. Must be at least 5 characters long."
          q.whitespace = :strip
        end
        password = "password" if password.blank?
        password
      end
      
      def prompt_for_sitename
        sitename = ask('Website name (thredded): ', String) do |q|
          q.validate = /^.{0,20}$/
          q.responses[:not_valid] = "Invalid site name. It must be less than 20 characters long."
          q.whitespace = :strip
        end
        sitename = "thredded" if sitename.blank?
        sitename
      end
      
      def prompt_for_messageboard
        messageboard = ask('Messageboard name (default): ', String) do |q|
          q.validate = /^.{0,20}$/
          q.responses[:not_valid] = "Invalid messageboard name. It must be less than 20 characters long."
          q.whitespace = :strip
        end
        messageboard = "default" if messageboard.blank?
        messageboard
      end
      
      def prompt_for_security
        security = 'public'
        choose do |menu|
          menu.index = :number
          menu.index_suffix = ") "
          menu.prompt = "Choose the security level you would like your messageboard to have: "
          menu.choice "Private - only members who've been invited"  do |command|
            security = 'private'
          end
          menu.choice "Logged In - only those who are logged in to the site may view"  do |command|
            security = 'logged_in'
          end
          menu.choice "Public - anyone and everyone"  do |command|
            security = 'public'
          end
        end
        security
      end
      
      def prompt_for_permission
        permission = 'logged_in'
        choose do |menu|
          menu.index = :number
          menu.index_suffix = ") "
          menu.prompt = "Select who may post in the messageboard: "
          menu.choice "Members - only those who've are members of the messageboard"  do |command|
            permission = 'members'
          end
          menu.choice "Logged In - only those who are logged in to the site may post"  do |command|
            permission = 'logged_in'
          end
          menu.choice "Anonymous - anyone and everyone can post"  do |command|
            permission = 'anonymous'
          end
        end
        permission
      end

      extend Forwardable
      def_delegators :terminal, :agree, :ask, :choose, :say  # delegate methods agree, ask, choose and say to the @terminal object
      def terminal
        @terminal ||= HighLine.new
      end
      
  end
end
