require 'spec_helper'

module ControllerResources
  RSpec.describe Extension do
    class MockController < ActionController::Base
      include Extension

      resource :model do |r|
        r.search :name
        r.modify :name, :password
      end
    end

    subject { MockController }

    let(:controller) { subject.new }

    let(:resource) { subject._resource }

    it "defines a resource object" do
      expect(resource).to be_present
      expect(resource).to be_a(Resource)
    end

    it "configures the resource object" do
      expect(resource.model_name).to eq(:model)
      expect(resource.collection_name).to eq(:models)
    end

    it "saves params" do
      expect(resource.search_params).to eq([:name])
      expect(resource.edit_params).to eq([:name, :password])
    end

    it "publishes params to instance method" do
      expect(controller).to respond_to(:search_params)
      expect(controller).to respond_to(:edit_params)
    end
  end
end
