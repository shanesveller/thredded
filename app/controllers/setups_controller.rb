class SetupsController < ApplicationController
  layout 'setup'
  helper_method :step, :setting_up

  def new
    if not_on_correct_step
      redirect_to correct_step
    end

    case step
      when '1'
        @user = User.new
      when '2'
        @site = Site.new
      when '3'
        @messageboard = Messageboard.new
    end
  end

  def create
    case step
    when '1'
      @user = User.create(params[:user])
      @user.superadmin = 1
      @user.save

      if @user.valid?
        redirect_to '/2'
      else
        flash[:error] = 'There were errors creating your user.'
        render action: :new
      end
    when '2'
      @user = User.last
      @site = Site.new params[:site]
      @site.user = @user
      @site.save

      if @site.valid?
        redirect_to '/3'
      end
    when '3'
      @user = User.last
      @site = Site.last
      messageboard_params = params[:messageboard].merge!({theme: 'default'})
      @messageboard = Messageboard.create(messageboard_params)

      if @messageboard.valid?
        @site.messageboards << @messageboard
        @site.save
        @user.admin_of @messageboard
        @messageboard.topics.create(
          user: @user,
          last_user: @user,
          title: "Welcome to your site's very first thread",
          posts_attributes: {
            '0' => {
              content: "There's not a whole lot here for now.",
              user: @user,
              ip: '127.0.0.1',
              messageboard: @messageboard
            }
          }
        )

        sign_in @user
        redirect_to root_path
      end
    end
  end

  private

  def not_on_correct_step
    step == '1' && User.any? ||
      step == '2' && (Site.any? || User.scoped.empty?) ||
      step == '3' && (Messageboard.any? || Site.scoped.empty? || User.scoped.empty?)
  end

  def correct_step
    if User.any? && Site.any? && Messageboard.scoped.empty?
      '/3'
    elsif User.any? && Site.scoped.empty?
      '/2'
    elsif User.scoped.empty?
      '/1'
    end
  end

  def step
    @step ||= params[:step] || '1'
  end

  def setting_up
    case step
      when '1'
        @setting_up = 'User'
      when '2'
        @setting_up = 'Site'
      when '3'
        @setting_up = 'Messageboard'
    end
  end
end
