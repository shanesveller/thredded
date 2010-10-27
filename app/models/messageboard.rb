class Messageboard
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :description, :type => String
  field :theme, :type => String, :default => "default" 
  field :topic_count, :type => Integer, :default => 0
  field :security, :type => Symbol
  field :posting_permission, :type => Symbol
  SECURED_WITH = [:private, :logged_in, :public]
  POSTS_ALLOWED_BY = [:members, :logged_in, :anonymous]

  validates_inclusion_of  :security, :in => SECURED_WITH
  validates_inclusion_of  :posting_permission, :in => POSTS_ALLOWED_BY
  validates_presence_of   :name
  validates_format_of     :name, :with => /^[\w\-]+$/, :on => :create, :message => "should be letters, nums, dash, underscore only."
  validates_uniqueness_of :name, :message => "must be a unique board name. Try again."
  validates_length_of     :name, :within => 1..16, :message => "should be between 1 and 16 characters" 

  references_many :topics
  references_many :users, :stored_as => :array, :inverse_of => :messageboards
  references_one :role
  
  def to_param
    "#{name.downcase}"
  end

end
