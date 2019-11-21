class Users::RegistrationsController < Devise::RegistrationsController
  after_action :attach_regis, only: %i(create update)

  protected

  def update_resource resource, params
    if current_user[:provider].present?
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end

  private

  def attach_regis
    @user.attach_image params, :user
  end
end
