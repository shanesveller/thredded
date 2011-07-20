Factory.define :role do |f|
  f.level 'admin'
  f.association :messageboard
end
