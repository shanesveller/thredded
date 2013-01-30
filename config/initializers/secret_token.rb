# Be sure to restart your server when you modify this file.


# Everyone can share the same token for development/test
if %w(development test).include? Rails.env
  Thredded::Application.config.secret_token = 'e21d71a34f1b2e38a248c533e3803a903377beb453c5db0cb001f528dfd0ef30fd4e524cb8b438314ba1fa79108a0e85bca05086450412b9c015a6ef52ab5va8'

elsif ENV['SECRET_TOKEN'].present?
  Thredded::Application.config.secret_token = ENV['SECRET_TOKEN']

elsif ENV['RAILS_GROUPS'] != 'assets'
  raise <<-ERROR.strip_heredoc
    You must generate a unique secret token for your Thredded instance.

    If you are deploying to Heroku, please run the following command to set your secret token:

        heroku config:add SECRET_TOKEN="$(bundle exec rake secret)"

    If you are deploying in some other way, please run the following command to generate a new secret token,
    and commit the new `config/initializers/secret_token.rb`:

        echo "Thredded::Application.config.secret_token = '$(bundle exec rake secret)'" > config/initializers/secret_token.rb

  ERROR
end
