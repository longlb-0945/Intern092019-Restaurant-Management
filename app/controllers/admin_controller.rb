class AdminController < ApplicationController
  layout "admin_template"

  def dashboard
    render "static_pages/dashboard"
  end
end
