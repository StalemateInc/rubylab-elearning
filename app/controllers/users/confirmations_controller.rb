# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  # Remove the first skip_before_filter (:require_no_authentication) if you
  # don't want to enable logged users to access the confirmation page.
  # If you are using rails 5.1+ use: skip_before_action
  # skip_before_action :require_no_authentication
  skip_before_action :authenticate_user!, raise: false

  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    with_unconfirmed_confirmable do
      do_show
    end
    (redirect_to :root and return) if @confirmable.confirmed?
    unless @confirmable.errors.empty?
      self.resource = @confirmable
      render 'users/confirmations/show'
    end
  end

  # PUT /resource/confirmation
  def update
    with_unconfirmed_confirmable do
      @profile = Profile.new(profile_params)
      @confirmable.attempt_set_password(params[:user])
      @profile.user = @confirmable
      @confirmable.errors.merge!(@profile.errors) unless @profile.valid?
      if !@confirmable.errors.empty?
        self.resource = @confirmable
        do_show
      else
        @profile.save
        do_confirm
      end
    end
  end

  protected

  def with_unconfirmed_confirmable
    @confirmable = User.find_or_initialize_with_error_by(:confirmation_token, params[:confirmation_token])
    if !@confirmable.new_record?
      @confirmable.only_if_unconfirmed {yield}
    end
  end

  def do_show
    @confirmation_token = params[:confirmation_token]
    @requires_password = true
    self.resource = @confirmable
    render 'users/confirmations/show'
  end

  def do_confirm
    @confirmable.confirm
    set_flash_message :notice, :confirmed
    sign_in_and_redirect(resource_name, @confirmable)
  end

  def profile_params
    params.require(:profile).permit(%i[name surname nickname])
  end

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end
end
