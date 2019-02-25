Trestle.resource(:organizations) do
  menu do
    group :elearning_main, priority: :first do
      item :organizations, icon: 'fa fa-building'
    end
  end

  # Customize the table columns shown on the index view.

  table do
    column :name
    column :created_at, align: :center
    column :updated_at, align: :center
    column :state
    actions do |toolbar, instance, admin|
      toolbar.edit if admin && admin.actions.include?(:edit)
      toolbar.delete if admin && admin.actions.include?(:destroy)
      if instance.unverified?
        toolbar.link 'Approve', admin.path(:approve, id: instance.id), method: :post, class: 'btn btn-success'
        toolbar.link 'Reject', admin.path(:reject, id: instance.id), method: :post, class: 'btn btn-danger'
      end
    end
  end

  # Customize the form fields shown on the new/edit views.
  #
  form do |organization|
    text_field :name
    text_area :description
    text_field :image

    # row do
    #   col(xs: 6) { datetime_field :updated_at }
    #   col(xs: 6) { datetime_field :created_at }
    # end

    select :state, states: %i[verified unverified archived]
  end

  controller do
    def approve
      organization = admin.find_instance(params)
      organization.verified!
      flash[:success] = "Organization approved successfully"
      redirect_to admin.path(:index)
    end

    def reject
      organization = admin.find_instance(params)
      organization.destroy!
      flash[:notice] = "Creation request declined"
      redirect_to admin.path(:index)
    end

    def archive
      organization = admin.find_instance(params)
      organization.archived!
      flash[:success] = "Organization archived successfully"
      redirect_to admin.path
    end
  end

  routes do
    post :approve, on: :member
    post :reject, on: :member
  end

  # By default, all parameters passed to the update and create actions will be
  # permitted. If you do not have full trust in your users, you should explicitly
  # define the list of permitted parameters.
  #
  # For further information, see the Rails documentation on Strong Parameters:
  #   http://guides.rubyonrails.org/action_controller_overview.html#strong-parameters
  #
  # params do |params|
  #   params.require(:organization).permit(:name, ...)
  # end
end
