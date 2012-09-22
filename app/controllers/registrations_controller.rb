class RegistrationsController < Devise::RegistrationsController
  def edit
    if params['messageboard']
      @preference = current_user_messageboard_preference
    end

    super
  end

  private

  def current_user_messageboard_preference
    current_user.
      preferences.
      find_or_create_by_messageboard_id(messageboard_id)
  end

  def messageboard_id
    Messageboard.find_by_name(params['messageboard']['name']).id
  end
end
