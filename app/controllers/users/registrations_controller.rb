class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def create
    super
    attach_image
  end

  def update
    super
    attach_image
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  end

  private

  def attach_image
    if params[:user][:image].blank?
      if params[:action].eql? "create"
        @user.image.attach(io: File.open(Rails.root
          .join("app", "assets", "images", "default_user.png")),
          filename: "default_user.png")
      end
    else
      @user.image.attach params[:user][:image]
    end
  end
end
