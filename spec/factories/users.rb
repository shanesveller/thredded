Factory.sequence(:email) { |n| "user#{n}@example.com" }
Factory.sequence(:name)  { |n| "user#{n}" }

Factory.define :user do |user|
  user.email                 { Factory.next :email }
  user.name                  { Factory.next :name }
  user.password              { "password" }
  user.password_confirmation { "password" }
end

Factory.define :email_confirmed_user, :parent => :user do |user|
  user.email { Factory.next :email }
  user.name  { Factory.next :name }
end

Factory.define :last_user, :parent => :user do |user|
  user.sequence(:email) { |n| "other#{n}@example.com" }
  user.sequence(:name)  { |n| "other" }
end
