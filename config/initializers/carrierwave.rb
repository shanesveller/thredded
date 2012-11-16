if %q{test cucumber development}.include? Rails.env
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
end
