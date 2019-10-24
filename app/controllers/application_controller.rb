class ApplicationController < ActionController::Base
  before_action :set_locale
  include SessionsHelper

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

  def not_login
    return if logged_in?

    flash[:danger] = t "please_login"
    redirect_to login_path
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end
end
