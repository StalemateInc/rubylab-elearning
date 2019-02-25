Trestle.resource(:users) do
  menu do
    group :elearning_main do
      item :users, icon: 'fa fa-user'
    end
  end

  # Customize the table columns shown on the index view.
  #
  table do
    column :id
    column :admin
    column :email
    column :confirmation_token
    column :confirmed_at, align: :center
    column :created_at, align: :center
    column :updated_at, align: :center
    actions
  end

  # Customize the form fields shown on the new/edit views.
  form do |user|
    check_box :admin
    email_field :email

    row do
      col(xs: 6) { text_field :confirmation_token }
      col(xs: 6) { datetime_field :confirmed_at }
    end
  end

end
