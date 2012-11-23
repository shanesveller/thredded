ActiveAdmin.register Role do
  menu parent: 'Users'

  config.sort_order = 'user_id_asc'

  index do
    column :user, :sortable => :user_id
    column :level
    column :messageboard, :sortable => :messageboard_id
    default_actions
  end

  form do |f|
    f.inputs 'User Roles' do
      f.input :user
      f.input :level, as: :select, collection: Role::ROLES
      f.input :messageboard
    end
    f.buttons
  end

end
