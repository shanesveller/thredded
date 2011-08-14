Factory.define :site do |f|
  f.slug "thredded"
  f.permission "public"
  f.domain ""
  f.title "Default website"
  f.description "default website description"
  f.association :user
end
