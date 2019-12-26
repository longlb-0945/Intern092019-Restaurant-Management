class ApplicationController < ActionController::Base
  before_action :set_locale, :params_for_search_ransack
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :load_category_nav, :load_guest_notification, if: :admin_controller?

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

  def new_notification_job noti_type, order_id, user_id
    noti_title = "Order #{noti_type}"
    noti_text = "Your ORDER[#{order_id}] has been #{noti_type}!"
    noti = User.find(user_id).notifications.create(title: noti_title, text: noti_text)

    ActionCable.server.broadcast("noti_channel_user_#{user_id}", noti: noti)
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

  def load_guest_notification
    if current_user
      @notifications = current_user.notifications.order_by("status", "asc").order_by("created_at", "asc")
      @notifications_unread = current_user.notifications.unread.size
    end
  end

  def admin_controller?
    !params[:controller].match?("^admin/")
  end
end
