class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_by uid: request.env["omniauth.auth"].uid

    session["devise.facebook_data"] = request.env["omniauth.auth"]
    session["devise.facebook_data.fb_login"] = true
    if @user&.persisted?
      redirect_to new_user_session_url
    else
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end
