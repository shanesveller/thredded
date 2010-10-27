class Role
  include Mongoid::Document
  field :level, :type => Symbol
  references_one :messageboard
  embedded_in :user, :inverse_of => :roles
end