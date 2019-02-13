# frozen_string_literal: true

class OrganizationDashboardController < ApplicationController
  before_action :set_organization

  # GET /organizations/:id/manage
  def index
    @courses = @organization.created_courses
  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
  end
end