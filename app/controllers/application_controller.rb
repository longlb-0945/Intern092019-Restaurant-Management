class ApplicationController < ActionController::Base
  before_action :set_locale, :params_for_search_ransack
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :load_category_nav, if: :admin_controller?
  load_and_authorize_resource
  skip_authorize_resource if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    flash[:warning] = exception.message
    redirect_to root_url
  end

  def check_guest
    return if current_user&.guest?

    flash[:danger] = t "access_denied"
    redirect_to root_path
  end

  def params_for_search_ransack
    @q = Product.ransack(params[:q])
  end

  protected
  def configure_permitted_parameters
    added_attrs = [:name, :email, :password,
      :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def load_category_nav
    @nav_categories = Category.pluck :id, :name
  end

  def admin_controller?
    !params[:controller].match?("^admin/")
  end
end
