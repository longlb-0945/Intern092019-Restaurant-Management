class ApplicationController < ActionController::Base
  before_action :set_locale

  before_action :configure_permitted_parameters, if: :devise_controller?

  def check_admin
    return true if current_user&.admin?

    flash[:danger] = t "access_denied"
    redirect_to root_path
  end

  def guest_not_allow
    return true unless current_user&.guest?

    flash[:danger] = t "access_denied"
    redirect_to root_path
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
end
