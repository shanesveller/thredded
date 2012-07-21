class Site  < ActiveRecord::Base
  attr_accessible :cname_alias, :default_site, :description, :email_from,
    :email_subject_prefix, :permission, :subdomain, :theme, :title

  belongs_to :user
  has_many :messageboards

  before_validation       :cache_domain
  validates_uniqueness_of :cached_domain, :subdomain
  validates_uniqueness_of :cname_alias, allow_blank: true
  validates_presence_of   :cached_domain, :description, :permission, :title
  validates_exclusion_of  :subdomain, in: %w(admin blog), message: 'is taken'
  validates_inclusion_of  :home, :in => %w{homepage messageboards topics}

  def posts_count
    messageboards.inject(0){|sum, item| sum + item.posts_count}
  end

  def to_param
    subdomain
  end

  def topics_count
    messageboards.inject(0){|sum, item| sum + item.topics_count}
  end

  private

  def cache_domain
    @default_site ||= Site.find_by_default_site(true)
    if self.cname_alias.blank? && @default_site
      self.cached_domain = "#{self.subdomain}.#{@default_site.cname_alias}"
    else
      self.cached_domain = "#{self.cname_alias}"
    end
  end
end
