module FacebookHelper
  def check_fb_login
    session["devise.facebook_data.fb_login"] == true &&
      session.delete("devise.facebook_data.fb_login")
  end
end
