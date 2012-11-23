ActiveAdmin.register Topic do
  menu priority: 3

  controller do
    defaults finder: :find_by_slug
  end

  index do
    column :id
    column :title
    column :sticky
    column :locked
    column :state
    column :created_at
    column :updated_at
    default_actions
  end

  form do |f|
    f.inputs 'Messageboard' do
      f.input :messageboard
      f.input :user
      f.input :last_user
      f.input :sticky
      f.input :locked
      f.input :slug
      f.input :state, as: :select, collection: Topic::STATES
    end
    f.buttons
  end

  scope :first_messageboard, default: true do |topic|
    topic.where(messageboard_id: Messageboard.first.id)
  end
end
