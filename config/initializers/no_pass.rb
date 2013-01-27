require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class NoPass < Authenticatable
      def valid?
        true
      end

      def authenticate!
        if params[:user]
          user = User.find_by_email(params[:user][:email])

          if user
            success!(user)
          else
            fail
          end
        else
          fail
        end
      end
    end
  end
end

Warden::Strategies.add(:no_pass, Devise::Strategies::NoPass)
