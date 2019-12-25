class ApplicationController < ActionController::Base
  include SessionsHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # TODO: This really need to be tweaked!
  def is_admin?
    @is_admin ||= session.key?("logged_in") and session[:logged_in] == true
  end

  def require_admin
    unless is_admin?
      flash[:danger] = 'Only admins can access this page.'
      redirect_to root_path
    end
  end
end
