Capybara.add_selector(:link) do
  xpath {|rel| ".//a[contains(@rel='#{rel}')]"}
end

# <a href="javascript:void(0);" rel="toggle-chart">Toggle chart</a>
#
# When /^I toggle the charts$/ do
#   page.find(:link, "toggle-chart").click
# end
