# frozen_string_literal: true

class OrganizationsController < ApplicationController
  include Pundit
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_organization, except: %i[index create new]
  before_action :set_join_request, only: :show

  # GET /organizations
  def index
    @organizations = Organization.all
  end

  # POST /organizations
  def create
    @organization = Organization.new(organization_params)
    redirect_to @organization if @organization.save
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
  end

  # GET /organizations/:id/edit
  def edit
    authorize @organization
  end

  # GET /organizations/:id
  def show; end

  # PATCH /organizations/:id
  def update
    authorize @organization
    redirect_to @organization if @organization.update(organization_params)
  end

  # DELETE /organizations/:id
  def destroy
    authorize @organization
    redirect_to organizations_path if @organization.destroy
  end

  # POST /organizations/:id/leave
  def leave
    membership = @organization.memberships.find_by(user: current_user)
    if membership.destroy
      flash[:success] = 'You have successfully left the organization.'
    else
      flash[:notice] = 'Error occurred while leaving the group.'
    end
    respond_to do |format|
      format.js
    end
  end

  def new_import
  end

  def create_import
    import_params = {}
    if params[:organization][:file] && params[:organization][:file].content_type == 'text/csv'
      import_params[:file] = params[:organization][:file]
    end
    import_params[:email] = params[:organization][:email] if params[:organization][:email] != [""]
    import_params[:organization_id] = params[:id]
    result = ImportUsersForOrganization.call(import_params)
    if result.success?
      @users = @organization.users
      respond_to do |format|
        format.js { @users }
      end
    else
      respond_to do |format|
        format.json { redirect_to @organization }
      end
    end
  end

  private

  def set_join_request
    @join_request = @organization.join_requests.find_by(user: current_user, status: :pending)
  end

  def set_organization
    @organization = Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(%i[name description])
  end
end
