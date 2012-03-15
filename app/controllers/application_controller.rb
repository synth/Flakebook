class ApplicationController < ActionController::Base
  include Facebooker2::Rails::Controller
  protect_from_forgery
  def ensure_authenticated
    if current_facebook_user.nil?
      redirect_to login_url
    else
      current_facebook_user.fetch
    end
  end
end
