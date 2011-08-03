Factory.define :site do |f|
  f.slug "thredded"
  f.permission "public"
  f.domain ""
  f.association :user
end
