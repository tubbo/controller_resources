class Collection
  attr_reader :array
  include Enumerable

  def initialize
    @array = [ Post.new(id: 1) ]
  end

  delegate :each, to: :array

  def find(id)
    array.find do |post|
      post.id == id
    end
  end

  def include?(given)
    any? do |model|
      model.id == given.id
    end
  end
end

class Post
  include ActiveModel::Model

  attr_accessor :id

  class << self
    def all
      Collection.new
    end

    delegate :find, to: :all
  end
end

class PostsController < ActionController::Base
  include DecentExposure
  include ControllerResources

  resource :post do
    permit :name
  end

  def request
    req = ActionDispatch::TestRequest.new
    req.path_parameters = { 'id' => 1, 'post' => { 'name' => 'hello' } }
    req
  end
end

