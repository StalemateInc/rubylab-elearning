# frozen_string_literal: true

class CertificatesController < ApplicationController
  before_action :set_certificate, except: :index

  def index
    @certificates = current_user.certificates
  end

  def show; end

  private

  def set_certificate
    @certificate = Certificate.find(params[:id])
  end
end
