class SessionsController < ApplicationController
  skip_before_filter :require_login
  def new
    if @current_user
      redirect_to root_url, notice_success: "Logged in!"
    else
      @no_top_nav = true
      @dark_body = true
    end
  end
  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice_warning: "Logged out!"
  end
  def create
    user = User.authenticate(params[:username], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to root_url, notice_success: "Logged in!"
    else
      redirect_to log_in_url, notice_danger: "Invalid username or password."
    end
  end
end
