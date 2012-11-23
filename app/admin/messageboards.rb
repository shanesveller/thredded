ActiveAdmin.register Messageboard do
  menu priority: 2

  config.sort_order = 'id_asc'

  controller do
    defaults finder: :find_by_name
  end

  form do |f|
    f.inputs 'Messageboard' do
      f.input :site
      f.input :name
      f.input :title
      f.input :description
      f.input :security, as: :select, collection: Messageboard::SECURITY
      f.input :posting_permission, as: :select, collection: Messageboard::PERMISSIONS
    end
    f.buttons
  end
end
