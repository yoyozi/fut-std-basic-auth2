class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_filter :admin, only: [:destroy, :edit, :update, :new, :create, :index]
  before_action :authorize, only: [:show, :edit, :update]


  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
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
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private

    def authorize

      if current_user.nil?
        redirect_to login_url, alert: "Not authorized! Log in required."
      else

        #if !current_user.admin || { current_user.id != @user.id }
        #    redirect_to root_url, alert: "Not authorized! Only admins and #{@user.first_name} has access to this user profile."
        #end

        #if the logged in user has the same id as the instance user.id (own record) or if the user is an admin
        if current_user.id != @user.id  
              redirect_to root_url, alert: "Not authorized! Only #{@user.first_name} has access to this user profile."
        end
      end
    end
  

  def admin

      if current_user.nil? || current_user.admin 
        redirect_to login_url, alert: "Not authorized! Log in required."
      else
      #if current_user == User
        if !current_user.admin 
            redirect_to root_url, alert: "Not authorized!" 
        end
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
