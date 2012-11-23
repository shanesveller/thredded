ActiveAdmin.register Post do
  menu priority: 4

  index do
    column :id
    column :user
    column :content
    column :ip
    column :created_at
    default_actions
  end

  form do |f|
    f.inputs 'Post' do
      f.input :messageboard
      f.input :user
      f.input :user_email
      f.input :content
      f.input :ip
      f.input :filter
      f.input :source
    end
    f.buttons
  end

  filter :user
  filter :messageboard
end
