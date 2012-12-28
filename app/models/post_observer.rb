class PostObserver < ActiveRecord::Observer
  def after_save(post)
    Notifier.new(post).notifications_for_at_users
  end
end
