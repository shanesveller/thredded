class RegistrationsController < Devise::RegistrationsController
  def edit
    if params['messageboard']
      @preference = current_user_messageboard_preference
    end

    super
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    if update_status
      if is_navigational_format?
        set_flash_message :notice, flash_key
      end

      sign_in resource_name, resource, bypass: true
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  private

  def update_status
    password_set? ?
      resource.update_with_password(resource_params) :
      resource.update_without_password(resource_params)
  end

  def flash_key
    if resource.respond_to?(:unconfirmed_email)
      prev_unconfirmed_email = resource.unconfirmed_email
    end

    update_needs_confirmation?(resource, prev_unconfirmed_email) ?
      :update_needs_confirmation :
      :updated
  end

  def password_set?
    resource_params['password'].present? &&
      resource_params['password_confirmation'].present?
  end

  def current_user_messageboard_preference
    current_user.
      preferences.
      find_or_create_by_messageboard_id(messageboard_id)
  end

  def messageboard_id
    Messageboard.find_by_name(params['messageboard']['name']).id
  end
end
