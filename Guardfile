# A sample Guardfile
# More info at http://github.com/guard/guard#readme

# guard 'spork', :cucumber_env => { 'RAILS_ENV' => 'test' }, :rspec_env => { 'RAILS_ENV' => 'test' } do

guard 'spork', :wait => 60, :cucumber_env => { 'RAILS_ENV' => 'test' }, :rspec_env => { 'RAILS_ENV' => 'test' }, :test_unit => false do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.+\.rb$})
  watch(%r{^config/initializers/.+\.rb$})
  watch('spec/spec_helper.rb')
end

guard 'livereload' do
  watch(%r{app/helpers/.+\.rb})
  watch(%r{app/views/.+\.(erb|haml)})
  watch(%r{(public/).+\.(css|js|html)})
  watch(%r{app/assets/stylesheets/partials/(.+\.scss).*$})    { |m| "assets/#{m[1]}" }
  watch(%r{app/assets/stylesheets/(.+\.css).*$})    { |m| "assets/#{m[1]}" }
  watch(%r{app/assets/javascripts/(.+\.js).*$}) { |m| "assets/#{m[1]}" }
  watch(%r{lib/assets/stylesheets/(.+\.css).*$})    { |m| "assets/#{m[1]}" }
  watch(%r{lib/assets/javascripts/(.+\.js).*$}) { |m| "assets/#{m[1]}" }
  watch(%r{vendor/assets/stylesheets/(.+\.css).*$}) { |m| "assets/#{m[1]}" }
  watch(%r{vendor/assets/javascripts/(.+\.js).*$})  { |m| "assets/#{m[1]}" }
  watch(%r{config/locales/.+\.yml})
end
