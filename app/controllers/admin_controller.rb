class AdminController < ApplicationController
  before_action :authenticate_user!

  layout "admin_template"

  def dashboard
    render "static_pages/dashboard"
  end
end
