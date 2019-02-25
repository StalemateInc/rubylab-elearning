Trestle.resource(:profiles) do
  menu do
    group :elearning_main do
      item :profiles, icon: 'fa fa-id-card'
    end
  end

  table do
    column :name
    column :surname
    column :nickname
    column :address
    column :birthday, align: :center
    actions
  end

  form do |profile|
    row do
      col(xs: 4) { text_field :name }
      col(xs: 4) { text_field :surname }
      col(xs: 4) { text_field :nickname }
    end

    datetime_field :birthday
    file_field :image
    select :user, User.all
  end

end
