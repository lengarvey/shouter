class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    end
    @current_user
  end

  def logged_in?
    !!current_user
  end

  def require_user
    session[:desired_request] = request.fullpath
    redirect_to login_path unless logged_in?
  end

  def require_no_user
    redirect_to root_path if logged_in?
  end

  helper_method :current_user, :logged_in?, :require_user, :require_no_user

end
