class PostsController < ApplicationController
  resource :post do
    permit :title, :body
  end

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
    render :new
  end

  # GET /posts/1/edit
  def edit
    render :edit
  end

  # POST /posts
  def create
    post.save
    redirect_to post
  end

  # PATCH/PUT /posts/1
  def update
    post.update(edit_params)
    redirect_to post
  end

  # DELETE /posts/1
  def destroy
    post.destroy
    redirect_to posts_path
  end
end
