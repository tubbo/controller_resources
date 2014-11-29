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

    it "defines singleton and collection resources" do
      expect(subject._singleton_resource).to eq(:model)
      expect(subject._collection_resource).to eq(:models)
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
