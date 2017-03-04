class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update]
  before_filter :isloggedin

  # A Pundit action to check all are verified: Can be removed later
  after_action :verify_authorized
  #before_filter :puser_only, :except => :show


  # GET /users
  def index
    #@users = User.all
    # Scope so pusers cannot see admin users
    @users = policy_scope(User)
    authorize User
  end

  # GET /users/1
  def show
    authorize @user
  end


  # GET /users/1/edit
  def edit

   authorize @user
  end


  # PATCH/PUT /users/1
  def update
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
    end

    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
    authorize @user
  end


  private

  def isloggedin
    if current_user.nil?
      redirect_to login_url, alert: "Log in required."
    end
  end


  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

end
