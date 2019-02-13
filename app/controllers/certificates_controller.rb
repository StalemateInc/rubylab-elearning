# frozen_string_literal: true

class CertificatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_certificate, except: :index

  # GET /user/certificates
  def index
    @certificates = current_user.certificates
  end

  # GET /user/certificates/:id
  def show; end

  private

  def set_certificate
    @certificate = Certificate.find(params[:id])
  end
end
