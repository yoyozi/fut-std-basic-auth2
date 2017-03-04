class AdminrolesController < ApplicationController
  before_filter :isloggedin
  before_filter :isadmin

  def index 
  	@users = User.all 
  	authorize User
  end

   # GET /users/new
  def new
    @user = User.new
    authorize @user
  end

  def edit
  	@user = User.find(params[:id])
  end

  ## POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to adminrole_path(@user), notice: 'User was successfully created.'
    else
      render :new
    end
    authorize @user
  end

    # GET /users/1
  def show
  	@user = User.find(params[:id])
    authorize @user
  end

  # PATCH/PUT /users/1
  def update
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
    end
    if @user.update(user_params)
      redirect_to adminrole_path(@user), notice: 'User was successfully updated.'
    else
      render :edit
    end
    authorize @user
  end

 ## DELETE /users/1
    def destroy
      @user = User.find(params[:id])
      @user.destroy
        redirect_to adminroles_path, notice: 'User was successfully destroyed.'
      authorize User
    end

  private

  def isadmin
    if !current_user.admin?
      redirect_to login_url, alert: "Access denied."
    end
  end

  def isloggedin
    if current_user.nil?
      redirect_to login_url, alert: "Log in required."
    end
  end


  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role)
  end

end

