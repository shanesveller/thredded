# Many thanks to John Nunemaker for posting this 
# http://railstips.org/blog/archives/2009/11/10/config-so-simple-your-mama-could-use-it/

module THREDDED
  def self.[](key)
    unless @config
      raw_config = File.read(Rails.root.to_s + "/config/thredded_config.yml")
      @config = YAML.load(raw_config)[Rails.env].symbolize_keys
    end
    @config[key]
  end

  def self.[]=(key, value)
    @config[key.to_sym] = value
  end
end
