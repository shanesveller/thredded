class Messageboard
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, :type => String
  field :description, :type => String
  field :theme, :type => String  
  field :topic_count, :type => Integer
  
  field :security, :type => Symbol
  SECURED_WITH = [:public, :private, :logged_in]
  validates_inclusion_of :security, :in => SECURED_WITH
end
