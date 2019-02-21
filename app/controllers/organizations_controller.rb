# frozen_string_literal: true

class OrganizationsController < ApplicationController
  include Pundit
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_organization, except: %i[index create new]
  before_action :set_join_request, only: :show
  before_action :set_keyword, :get_organizations, only: :index

  # GET /organizations
  def index
    @organizations
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

  def get_organizations
    case @keyword
    when "wordsA"
      @organizations = Organization.order(:name).paginate(page: params[:page], per_page: 10)
    when "wordsZ"
      @organizations = Organization.order(name: :desc).paginate(page: params[:page], per_page: 10)
    when "course"
      #select organizations.id, organizations.name, organizations.state, organizations.updated_at,
      #organizations.created_at, organizations.description from organizations
      #left join ownerships on ownerships.ownable_id = organizations.id
      #group by organizations.id
      #order by count(ownerships) desc ;
    when "members"
      #select organizations.id, organizations.name, organizations.state, organizations.updated_at,
      #organizations.created_at, organizations.description from organizations
      #join memberships on memberships.organization_id = organizations.id
      #group by organizations.id
      #order by count(memberships) desc ;
    when "new"
      @organizations = Organization.order(:created_at).paginate(page: params[:page], per_page: 10)
    when "old"
      @organizations = Organization.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
    else
      @organizations = Organization.all.paginate(page: params[:page], per_page: 10)
    end
  end

  def set_keyword
    @keyword = keyword_params
  end

  def keyword_params
    params[:keyword].nil? ? nil : params.require(:keyword)
  end
end
