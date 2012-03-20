# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :category do |c|
  c.name "Test Cat"
  c.description "A test category"
  c.association :messageboard
end
