require 'spec_helper'

# :nodoc:
class User
end

# :nodoc:
module ControllerResources
  RSpec.describe Resource do
    subject do
      Resource.new :user do |r|
        r.search :name
        r.modify :name, :password
      end
    end

    it 'has a name' do
      expect(subject.name).to eq('user')
    end

    it 'starts with given search params' do
      expect(subject.search_params).to include(:name)
    end

    it 'starts with given editing params' do
      expect(subject.edit_params).to include(:name)
      expect(subject.edit_params).to include(:password)
    end

    it 'configures search params' do
      subject.search :title
      expect(subject.search_params).to include(:title)
      expect(subject.search_params).to_not include(:name)
    end

    it 'configures editing params' do
      subject.modify :token
      expect(subject.edit_params).to include(:token)
      expect(subject.edit_params).to_not include(:password)
    end

    it 'provides the user class name' do
      expect(subject.model_class).to eq(User)
    end
  end
end
