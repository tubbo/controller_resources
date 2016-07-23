require 'spec_helper'

class TestController
  include ControllerResources

  def self.before_action(*args)
    true
  end

  resource :comment, ancestor: :post
end


RSpec.describe ControllerResources do
  let :controller do
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

  it 'has default collection actions but can add over time' do
    expect(controller.collection_actions).to eq([:index])
    controller.collection_actions << :show
    expect(controller.collection_actions).to eq([:index, :show])
  end
end
