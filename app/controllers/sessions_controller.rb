class SessionsController < ApplicationController

  # Before actions to check paramters
  before_action :check_params, only: [:login]
  before_action :authenticate_user, only: [:logout]

  def unauth
  end

  # Find a user with the username and password pair, log in that user if they exist
  def login
    # Find a user with params
    user = User.authenticate(@credentials[:username], @credentials[:password])
    respond_to do |format|
      if user
        # Save them in the session
        log_in user
        format.html { redirect_to articles_path, notice: 'Successfully logged in.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { redirect_to login_path, notice: 'Your username/password was incorrect.', status: 403 }
        format.json { render json: @user.errors, status: 403 }
      end
    end
  end

  # Log out the user in the session and redirect to the unauth thing
  def logout
    log_out
    redirect_to login_path
  end

  # Private controller methods
  private
  def check_params
    params.require(:credentials).permit(:username, :password)
    @credentials = params[:credentials]
  end

end
