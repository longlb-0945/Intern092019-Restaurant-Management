class AdminController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :admin

  layout "admin_template"

  def dashboard
    render "static_pages/dashboard"
  end

  def params_for_search class_name_s
    @q = class_name_s.ransack(params[:q])
  end
end
