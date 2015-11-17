class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :logged_in?

  protected
  def authenticate_user
    if session[:user_id] && User.exists?(session[:user_id])
        @current_user = User.find(session[:user_id])
        return true
    else
        redirect_to(:controller => 'sessions', :action => 'login')
        return false
    end
  end

  def save_login_state
    if session[:user_id] && User.exists?(session[:user_id])
        redirect_to(:controller => 'sessions', :action => 'home')
        return false
    else
        return true
    end
  end

  def logged_in?
    session[:user_id] &&
    User.exists?(session[:user_id]) &&
    User.find(session[:user_id]).username
  end

  def is_admin?
    logged_in?
  end

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find(session[:user_id])
  end
  

end
