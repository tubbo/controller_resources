class PostsController < ApplicationController
  resource :post

  # GET /posts
  def index
    render :index
  end

  # GET /posts/1
  def show
    render :show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    render :edit
  end

  # POST /posts
  def create
    @post = Post.create edit_params
    flash[:notice] = 'Post created.'
    redirect_to @post
  end

  # PATCH/PUT /posts/1
  def update
    @post.update edit_params
    flash[:notice] = 'Post updated.'
    redirect_to @post
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
    flash[:notice] = 'Post deleted.'
    redirect_to posts_path
  end

  private

  def edit_params
    params.require(:post).permit :title, :body
  end
end
