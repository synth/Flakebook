class LoginController < ApplicationController
  def index
    redirect_to index_url unless current_facebook_user.nil?
  end
end
