module PageObject
  module Authentication
    def logged_in?
      has_css? 'header nav a', text: 'Logout'
    end

    def signs_out
      visit '/users/sign_out'
    end

    def signs_up_via_github
      visit '/users/sign_in'
      find('a.github').click
    end

    def goes_to_edit_account
      visit edit_user_registration_path
    end
  end
end

