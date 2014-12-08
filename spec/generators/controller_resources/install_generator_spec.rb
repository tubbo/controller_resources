require 'spec_helper'
require 'generators/controller_resources/install_generator'

module ControllerResources
  RSpec.describe InstallGenerator, :type => :generator do
    destination Rails.root.join('tmp/generators')

    before do
      prepare_destination and run_generator
    end

    it "creates the locale file" do
      assert_file "config/locales/responders.en.yml", <<YAML
en:
  flash:
    actions:
      create:
        notice: '%{resource_name} was successfully created.'
        # alert: '%{resource_name} could not be created.'
      update:
        notice: '%{resource_name} was successfully updated.'
        # alert: '%{resource_name} could not be updated.'
      destroy:
        notice: '%{resource_name} was successfully destroyed.'
        alert: '%{resource_name} could not be destroyed.'
YAML
    end
  end
end
