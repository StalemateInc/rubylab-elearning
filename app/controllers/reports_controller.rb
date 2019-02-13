# frozen_string_literal: true

class ReportsController < ApplicationController
  include Pundit
  before_action :authenticate_user!
  before_action :set_organization

  # GET organizations/:id/manage/reports
  def index
    authorize @organization, policy_class: ReportPolicy
  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
  end
end
