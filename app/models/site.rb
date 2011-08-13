class Site  < ActiveRecord::Base
  has_many :messageboards
  belongs_to  :user
  validates_presence_of :slug, :permission, :title, :description
  validates_uniqueness_of :slug

  def topics_count
    messageboards.inject(0){|sum, item| sum + item.topics_count}
  end

  def posts_count
    messageboards.inject(0){|sum, item| sum + item.posts_count}
  end

  class << self
    def default_slug
      return THREDDED[:default_site] if Site.exists?(:slug => THREDDED[:default_site])
      return Site.first.slug if Site.first
      raise "No default site exists for this website. Please create a new Site and/or set :default_site in your thredded_config.yml to point to it."
    end
  end
end
