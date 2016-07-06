require 'spec_helper'

RSpec.describe ControllerResources do
  class TestController < ActionController::Base
    include ControllerResources

    resource :comment, ancestor: :post
  end

  subject do
    TestController
  end

  it 'can be included into a controller' do
    expect(controller.ancestors).to include(ControllerResources)
  end

  it 'defines resource name' do
    expect(controller.resource_name).to eq 'comment'
  end

  it 'defines ancestor name' do
    expect(controller.resource_ancestor_name).to eq 'post'
  end

  it 'has default collection actions' do
    expect(controller.collection_actions).to eq([:index])
  end

  it 'can add collection actions' do
    controller.collection_actions << :show
    expect(controller.collection_actions).to eq([:index, :show])
  end
end
