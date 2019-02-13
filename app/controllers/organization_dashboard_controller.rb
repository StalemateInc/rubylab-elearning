# frozen_string_literal: true

class OrganizationDashboardController < ApplicationController
  include Pundit
  before_action :set_organization

  # GET /organizations/:id/manage
  def index
    authorize @organization, policy_class: OrganizationDashboardPolicy
    @courses = @organization.created_courses
  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
  end
end
