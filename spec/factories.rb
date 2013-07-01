include ActionDispatch::TestProcess

FactoryGirl.define do
  sequence(:user_email) { |n| "user#{n}@example.com" }
  sequence(:user_name) { |n| "user#{n}" }
  sequence(:other_email) { |n| "other#{n}@email.com" }
  sequence(:other_name) { |n| "other#{n}" }
  sequence(:password) { |n| "password#{n}" }
  sequence(:topic_hash) { |n| "hash#{n}" }

  factory :attachment do
    attachment    { fixture_file_upload('spec/samples/img.png', 'image/png') }
    content_type  'image/png'
    file_size     1000

    factory :imgpng

    factory :pdfpng do
      attachment  { fixture_file_upload('spec/samples/pdf.png', 'image/png') }
    end

    factory :txtpng do
      attachment  { fixture_file_upload('spec/samples/txt.png', 'image/png') }
    end

    factory :zippng do
      attachment  { fixture_file_upload('spec/samples/zip.png', 'image/png') }
    end
  end

  factory :category do
    sequence(:name) { |n| "category#{n}" }
    sequence(:description) { |n| "Category #{n}" }

    trait :beer do
      name 'Beer'
      description 'Nectar of the Gods!'
    end
  end

  factory :email, class: OpenStruct do
    to 'email-token'
    from 'user@email.com'
    subject 'email subject'
    body 'Hello!'
    attachments {[]}

    trait :with_attachment do
      attachments {[
        ActionDispatch::Http::UploadedFile.new({
          filename: 'img.png',
          type: 'image/png',
          tempfile: File.new("#{File.expand_path File.dirname(__FILE__)}/samples/img.png")
        })
      ]}
    end

    trait :with_attachments do
      attachments {[
        ActionDispatch::Http::UploadedFile.new({
          filename: 'img.png',
          type: 'image/png',
          tempfile: File.new("#{File.expand_path File.dirname(__FILE__)}/samples/img.png")
        }),
        ActionDispatch::Http::UploadedFile.new({
          filename: 'zip.png',
          type: 'image/png',
          tempfile: File.new("#{File.expand_path File.dirname(__FILE__)}/samples/zip.png")
        })
      ]}
    end
  end

  factory :identity do
    uid '1'
    provider 'github'
  end

  factory :messageboard do
    sequence(:name) { |n| "messageboard#{n}" }
    sequence(:title) { |n| "Messageboard #{n}" }
    description 'This is a description of the messageboard'
    security 'public'
    posting_permission  'anonymous'

    trait :logged_in do
      security 'logged_in'
    end

    trait :private do
      security 'private'
    end

    trait :public do
      security 'public'
    end

    trait :restricted_to_logged_in do
      security 'logged_in'
    end

    trait :postable_for_logged_in do
      posting_permission 'logged_in'
    end
  end

  factory :post do
    user
    topic
    messageboard

    sequence(:content) { |n| "A post about the number #{n}" }
    ip '127.0.0.1'
    filter 'bbcode'
  end

  factory :post_notification

  factory :post_with_no_associations, class: 'Post' do
    sequence(:content) { |n| "A post about the number #{n}" }
    ip '127.0.0.1'
    filter 'bbcode'
  end

  factory :preference do
    notify_on_mention false
    notify_on_message false
  end

  factory :private_topic do
    user
    messageboard
    title 'New private topic started here'
    association :last_user, factory: :user
  end

  factory :private_user do
    private_topic_id 1
    user_id 1
  end

  factory :role do
    level 'admin'
    messageboard

    factory :role_admin do
      level 'admin'
    end

    factory :role_superadmin do
      level 'superadmin'
    end

    factory :role_moderator do
      level 'moderator'
    end

    factory :role_member do
      level 'member'
    end
  end

  factory :app_config do
    permission           'public'
    title                'Default website'
    description          'default website description'
    email_from           'Site <email@email.com>'
    email_subject_prefix '[Email] '
    incoming_email_host  'reply.email.com'
  end

  factory :topic do
    ignore do
      with_posts 0
      with_categories 0
    end

    user
    messageboard
    association :last_user, factory: :user

    title 'New topic started here'
    hash_id { FactoryGirl.generate(:topic_hash) }

    trait :locked do
      locked 't'
    end

    trait :unlocked do
      locked 'f'
    end

    after(:create) do |topic, evaluator|
      evaluator.with_posts.times do
        create(:post, topic: topic, messageboard: topic.messageboard)
      end

      evaluator.with_categories.times do
        topic.categories << create(:category)
      end
    end
  end

  factory :user do
    email { FactoryGirl.generate(:user_email) }
    name  { FactoryGirl.generate(:user_name) }
    current_sign_in_at 10.minutes.ago
    last_sign_in_at    10.minutes.ago
    current_sign_in_ip '192.168.1.1'
    last_sign_in_ip    '192.168.1.1'
    superadmin         'f'
    time_zone          'Eastern Time (US & Canada)'
    password

    factory :email_confirmed_user do
      email              { FactoryGirl.generate(:user_email) }
      name               { FactoryGirl.generate(:user_name) }
    end

    factory :last_user do
      email              { FactoryGirl.generate(:other_email) }
      name               { FactoryGirl.generate(:other_name) }
    end

    trait :superadmin do
      superadmin 't'
    end
  end

  factory :user_topic_read do
    user_id 1
    topic_id 1
    post_id 1
    page 1
  end
end
