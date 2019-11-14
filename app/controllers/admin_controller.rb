class AdminController < ApplicationController
  before_action :authenticate_user!

  layout "admin_template"

  def dashboard
    render "static_pages/dashboard"
  end

  def params_for_search class_name
    @q = class_name.ransack(params[:q])
  end
end
