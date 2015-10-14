class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Include our session helper
  include SessionsHelper

  helper_method :is_current_user?

  def authenticate_user
    unless current_user
      redirect_to login_path, notice: 'Unauthorized access!', status: 401
    end
  end

  def is_current_user? user
    current_user.id == user.id
  end
end
