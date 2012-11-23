ActiveAdmin.register User do
  menu priority: 1

  controller do
    defaults finder: :find_by_name
  end

  index do
    column :id
    column :name
    column :email
    column :last_sign_in_at
    column :created_at
    default_actions
  end
end
