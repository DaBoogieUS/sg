class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  add_flash_types :notice_danger, :notice_success, :notice_info, :notice_warning

  before_filter :require_login
  before_action :check_perms, only: [:edit, :destroy, :new]

  private

  def require_login
    unless current_user
      redirect_to log_in_url
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    if @current_user
      @current_role = @current_user.role
    end
  end

  def check_perms
    controller = params[:controller]
    unless @current_user && @current_user.role == 'admin' || controller == 'users' || controller == 'sessions'
      if request.referer
        respond_to do |format|
          format.html { redirect_to request.referer, notice_danger: 'You don\'t have the permission to modify ' + controller + '.' }
        end
      else
        respond_to do |format|
          format.html { redirect_to root_url, notice_danger: 'You don\'t have the permission to modify ' + controller + '.' }
        end
      end
    end
  end

end
