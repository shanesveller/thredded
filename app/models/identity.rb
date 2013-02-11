class Identity < ActiveRecord::Base
  attr_accessible :provider, :uid, :user_id

  belongs_to :user

  def self.from_omniauth(auth_hash)
    where(auth_hash.slice('provider', 'uid')).first ||
      create_from_omniauth(auth_hash)
  end

  private

  def self.create_from_omniauth(auth_hash)
    identity = Identity.new(provider: auth_hash['provider'], uid: auth_hash['uid'])
    identity.user = User.from_omniauth(auth_hash)
    identity.save!
    identity
  end
end
