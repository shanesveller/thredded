FactoryGirl.define  do
  factory :site do
    subdomain            "site0"
    cached_domain        "website.com"
    cname_alias          "website.com"
    permission           "public"
    title                "Default website"
    description          "default website description"
    home                 "messageboards"
    email_from           "Site <email@email.com>"
    email_subject_prefix "[Email] "
    default_site         "f"
    # association   :user
  end
end
