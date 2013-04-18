class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :touch_last_seen
  helper_method :extra_data,
    :messageboard,
    :topic,
    :tz_offset

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to site_home
  end

  def authenticate_admin_user!
    unless current_user && current_user.superadmin?
      redirect_to '/'
    end
  end

  protected

  def merge_default_topics_params
    params.deep_merge!({
      topic: {
        last_user: current_user,
        messageboard: messageboard,
        user: current_user,
        posts_attributes: {
          '0' => {
            messageboard: messageboard,
            ip: request.remote_ip,
            user: current_user,
          }
        }
      }
    })
  end

  private

  def extra_data
    ''
  end

  def get_project
    @app_config ||= AppConfig.first
  end

  def after_sign_in_path_for(resource_or_scope)
    session[:redirect_url] || site_home
  end

  def after_sign_out_path_for(resource_or_scope)
    site_home
  end

  def site_home
    '/'
  end

  def default_home
    root_url
  end

  def messageboard
    @messageboard ||= Messageboard.where(name: params[:messageboard_id]).
      order('id ASC').first
  end

  def topic
    if messageboard
      @topic ||= messageboard.topics.find(params[:topic_id])
    end
  end

  def tz_offset
    if current_user
      Time.zone = current_user.time_zone
    end

    @tz_offset ||= Time.zone.now.utc_offset / 1.hour
  end

  def touch_last_seen
    if current_user && messageboard
      current_user.mark_active_in!(messageboard)
    end
  end

  def ensure_messageboard_exists
    if messageboard.blank?
      redirect_to default_home,
        flash: { error: 'This messageboard does not exist.' }
    end
  end
end
