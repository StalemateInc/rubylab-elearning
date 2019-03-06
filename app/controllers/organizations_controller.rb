# frozen_string_literal: true

class OrganizationsController < ApplicationController
  include Pundit
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_organization, except: %i[index create new sortable]
  before_action :set_join_request, only: :show

  # GET /organizations
  def index
    @sort_by = { 'Name': 'name', 'Members count': 'memberships',
                 'Courses count': 'ownerships', 'Creation date': 'created_at' }
    @organizations = Organization.all.paginate(page: params[:page], per_page: 10)
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

  # GET /organization/sortable
  def sortable
    @organizations = get_organizations
    respond_to do |format|
      format.js
      format.html
    end
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

  private

  def set_join_request
    @join_request = @organization.join_requests.find_by(user: current_user, status: :pending)
  end

  def set_organization
    @organization = Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(%i[name description image remove_image])
  end

  def get_organizations
    case sort_params.join('_')
    when 'name_asc'
      @organizations = Organization.order(:name).paginate(page: params[:page], per_page: 10)
    when 'name_desc'
      @organizations = Organization.order(name: :desc).paginate(page: params[:page], per_page: 10)
    when 'ownerships_asc'
      @organizations = Organization.left_outer_joins(:ownerships).group(:id).order('COUNT(ownerships.id) asc').paginate(page: params[:page], per_page: 10)
    when 'ownerships_desc'
      @organizations = Organization.left_outer_joins(:ownerships).group(:id).order('COUNT(ownerships.id) desc').paginate(page: params[:page], per_page: 10)
    when 'memberships_asc'
      @organizations = Organization.left_outer_joins(:memberships).group(:id).order('COUNT(memberships.id) asc').paginate(page: params[:page], per_page: 10)
    when 'memberships_desc'
      @organizations = Organization.left_outer_joins(:memberships).group(:id).order('COUNT(memberships.id) desc').paginate(page: params[:page], per_page: 10)
    when 'created_at_asc'
      @organizations = Organization.order(created_at: :asc).paginate(page: params[:page], per_page: 10)
    when 'created_at_desc'
      @organizations = Organization.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
    else
      @organizations = Organization.all.paginate(page: params[:page], per_page: 10)
    end
  end

  def sort_params
    params[:sort].require(%i[sort_by direction])
  end
end
