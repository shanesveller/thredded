Factory.define :site do |f|
  f.subdomain     "site0"
  f.cached_domain "website.com"
  f.cname_alias   "website.com"
  f.permission    "public"
  f.title         "Default website"
  f.description   "default website description"
  f.home          "messageboards"
  f.email_from    "Site <email@email.com>"
  f.email_subject_prefix "[Email] "
  f.default_site  "f"
  f.association   :user
end
