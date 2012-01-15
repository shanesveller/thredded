# Before('@default_site') do
#   permission = "public"
#   THREDDED[:default_domain] = "example.com"
#   THREDDED[:default_site]   = website.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
#   @site = Factory(:site, :slug => THREDDED[:default_site], :domain => THREDDED[:default_domain], :permission => permission)
# end

