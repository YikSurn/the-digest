# The main controller
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Include our session helper
  include SessionsHelper

  helper_method :current_user?

  def authenticate_user
    redirect_to login_path, notice: 'Unauthorized access!',
                            status: 401 unless current_user
  end

  def current_user?(user)
    current_user.id == user.id
  end
end
