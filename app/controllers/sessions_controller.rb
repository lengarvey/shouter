class SessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]

  def new
  end

  def create
    if user = User.find_by_email(params[:email]).try(:authenticate, params[:password])
      session[:user_id] = user.id
      if session[:desired_request]
        redirect_to session[:desired_request]
      else
        redirect_to shouts_path
      end
    else
      render 'new'
    end
  end

  def destroy
    reset_session
    redirect_to login_path
  end
end
