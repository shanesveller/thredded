Factory.sequence :email do |n|
  "user#{n}@example.com"
end

Factory.sequence :name do |n|
  "fred#{n}"
end

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
