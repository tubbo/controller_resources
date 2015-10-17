class PostsController < ApplicationController
  resource :post do
    permit :title, :body
  end

  # GET /posts
  def index
    respond_with posts
  end

  # GET /posts/1
  def show
    respond_with post
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
    respond_with post
  end

  # PATCH/PUT /posts/1
  def update
    post.update(edit_params)
    respond_with post
  end

  # DELETE /posts/1
  def destroy
    post.destroy
    respond_with post
  end
end
