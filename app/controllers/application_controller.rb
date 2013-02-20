class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :site
  before_filter :theme_layout, except: [:delete, :update, :create]
  before_filter :touch_last_seen
  helper_method :default_site,
    :extra_data,
    :messageboard,
    :site,
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

  def theme_layout
    if site && site.theme && ::Thredded.themes.keys.include?(site.theme.to_sym)
      prepend_view_path ::Thredded.themes[site.theme.to_sym]
    end
  end

  def get_project
    @site ||= Site.where(cached_domain: request.host).first
  end

  def after_sign_in_path_for(resource_or_scope)
    site_home
  end

  def after_sign_out_path_for(resource_or_scope)
    site_home
  end

  def site_home
    '/'
  end

  def site
    @site ||= requested_host_site or default_site
  end

  def default_home
    root_url(host: site.cached_domain)
  end

  def default_site
    @default_site ||= Site.find_by_default_site(true)
  end

  def requested_host_site
    Site.where(cached_domain: request.host).
      includes(:messageboards).order('messageboards.id ASC').first
  end

  def messageboard
    @messageboard ||= site.messageboards.where(name: params[:messageboard_id]).
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
