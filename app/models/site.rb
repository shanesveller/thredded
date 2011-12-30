class Site  < ActiveRecord::Base
  has_many :messageboards
  belongs_to :user
  
  before_validation       :cache_domain
  validates_uniqueness_of :subdomain,    :cached_domain
  validates_uniqueness_of :cname_alias,  :allow_blank => true
  validates_presence_of   :subdomain,
                          :cached_domain,
                          :permission,
                          :title,
                          :description
  validates_exclusion_of  :subdomain,
                          :in => %w(admin blog),
                          :message => "is taken"
  
  def topics_count
    messageboards.inject(0){|sum, item| sum + item.topics_count}
  end

  def posts_count
    messageboards.inject(0){|sum, item| sum + item.posts_count}
  end

  def to_param
    subdomain
  end

private

  def cache_domain
    self.cached_domain = if THREDDED[:domain] == 'localhost'
      "localhost"
    elsif self.cname_alias.blank?
      "#{self.subdomain}.#{THREDDED[:domain]}"
    else
      "#{self.cname_alias}"
    end
  end

end
