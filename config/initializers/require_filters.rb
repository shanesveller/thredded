Dir[File.join(Rails.root, 'lib', '*filter.rb')].each do |f|
  require f
end
