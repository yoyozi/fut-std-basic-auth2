class PostsController < ApplicationController

  before_action :set_post, only: [:show, :edit, :update, :destroy]

  before_action :authorize, except: [:show, :index]

  # GET /posts
  def index
    @posts = Post.all
  end

  # GET /posts/1
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

def create
  # when logged in the controller links current user to the post as it belongs to a user
  @post = current_user.posts.build(post_params)
  if @post.save
    redirect_to @post, notice: 'Post was successfully created.'
  else
    render :new
  end
end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params.require(:post).permit(:title, :content)
    end


  # The method to ensure that a user is logged in else cannot use the actions listed in  before action above
  def authorize
    if current_user.nil?
      redirect_to login_url, alert: "Not authorized! Please log in to post."
    else
      # If the post is not belonging to the logged in user then redirect to root url and send flash alert.
      if @post && @post.user != current_user
        redirect_to root_path, alert: "Not authorized! Only #{@post.user} has access to this post."
      end
    end
  end
end
