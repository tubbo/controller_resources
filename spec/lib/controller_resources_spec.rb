require 'spec_helper'

RSpec.describe ControllerResources, type: :lib do
  subject do
    PostsController.new
  end

  it 'defines model_name' do
    expect(subject.model_name).to eq :post
  end

  it 'defines collection_name' do
    expect(subject.collection_name).to eq :posts
  end

  it 'computes model from model_name' do
    expect(subject).to respond_to :model
    expect(subject.model).to be_a Post
    expect(subject.post).to eq subject.model
  end

  it 'computes collection from collection_name' do
    expect(subject).to respond_to :collection
    expect(subject.collection).to be_a Collection
    expect(subject.collection).to include(subject.model)
    expect(subject.posts).to eq subject.collection
  end

  it 'defines edit_params' do
    expect(subject.edit_params).to be_present
  end
end
