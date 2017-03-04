class AdminrolesPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end


  # Methods for each controller action

  def index?
    # Is the current user an admin? If they are they can visit index page, if not 
    # they get failure notice that is setup in the application controller
     @current_user.admin?
  end

  def edit?
    #@current_user.admin? || @current_user.puser? || 
     @current_user.admin?
  end

  def show?
    # If the user is an admin is allowed to show a users page or the current user is viewing his own user page
    #@current_user.admin? || @current_user.puser? || 
    @current_user.admin?
  end

  def update?
    @current_user.admin?
  end

  def destroy?
    @current_user.admin?
  end

  def new?
    @current_user.admin?
  end

  def create?
    @current_user.admin?
  end

end