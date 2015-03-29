require 'spec_helper'

module ControllerResources
  RSpec.describe Extension do
    class MockController < ActionController::Base
      include Extension

      resource :model do
        search :name
        modify :name, :password
      end
    end

    subject { MockController }
    let(:controller) { subject.new }

    it "defines a resource object" do
      expect(subject._resource).to be_present
      expect(subject._resource).to be_a(Resource)
    end

    it "configures the resource object" do
      expect(subject._resource.model_name).to eq('model')
      expect(subject._resource.collection_name).to eq('models')
    end

    it "saves params" do
      expect(subject._search_params).to eq([:name])
      expect(subject._edit_params).to eq([:name, :password])
    end

    it "publishes params to instance method" do
      expect(controller).to respond_to(:search_params)
      expect(controller).to respond_to(:edit_params)
    end
  end
end
