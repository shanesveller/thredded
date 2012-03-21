FactoryGirl.define  do
  sequence(:subdomain) { |n| "site#{n}" }

  factory :site do
    user
    subdomain
    cached_domain        "website.com"
    cname_alias          "website.com"
    permission           "public"
    title                "Default website"
    description          "default website description"
    home                 "messageboards"
    email_from           "Site <email@email.com>"
    email_subject_prefix "[Email] "
    default_site         "f"
  end
end
