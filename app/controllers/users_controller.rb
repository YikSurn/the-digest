# The controller for users
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :get_digest,
    :toggle_subscribe]
  before_action :authenticate_user, only: [:show]
  before_action :access?, only: [:edit, :update, :destroy, :get_digest,
    :toggle_subscribe]

  include NewsDigestService

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        log_in @user
        format.html { redirect_to @user,
          notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if user_params['password'].empty?
      user_params.delete('password')
      user_params.delete('password_confirmation')
    end
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user,
          notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to login_path,
        notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # PATCH/PUT /users/1/subscription
  def toggle_subscribe
    @user.toggle!(:subscribed)
    if @user.subscribed
      redirect_to :back,
        notice: 'You have succesfully subscribed to the news digest.'
    else
      redirect_to :back,
        notice: 'You have now unsubscribed to the news digest.'
    end
  end

  # GET /users/1/digest
  def get_digest
    NewsDigestService.create_digest(@user)
    redirect_to articles_path,
      notice: 'A news digest has been sent to your email.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the internet, only allow the white list through.
  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :bio, :email, :username, :password,
      :password_confirmation, :interest_list
    )
  end

  # True only if the user account being accessed is the logged in user
  def access?
    unless current_user? @user
      respond_to do |format|
        format.html { redirect_to login_path, notice: 'Unauthorized access!',
          status: 401 }
        format.json { render json: @user.errors, status: 401 }
      end
    end
  end
end
