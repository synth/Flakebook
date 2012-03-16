class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :parse_facebook_cookies
  helper_method :current_facebook_user
  def parse_facebook_cookies
   @facebook_cookies = Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
  end

  # def get_oath
  #   oauth = Koala::Facebook::OAuth.new(app_id, app_secret, callback_url)
  # end

  def get_graph
    @graph = Koala::Facebook::API.new(oauth_access_token)
  end
  
  def current_facebook_user
    # oauth = Koala::Facebook::OAuth.new(Facebook::APP_ID, Facebook::SECRET, Facebook::CALLBACK_URL)
    nil
  end

  def current_facebook_client
  end

  def ensure_authenticated
    if current_facebook_user.nil?
      redirect_to login_url
    else
      current_facebook_user.fetch
    end
  end
end
