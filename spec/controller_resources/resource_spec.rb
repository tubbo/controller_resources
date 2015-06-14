RSpec.describe Resource do
  class User; end
  subject do
    Resource.new :user do
      search :name
      modify :name, :password
    end
  end

  it 'has a name' do
    expect(resource.name).to eq('user')
  end

  it 'has search params' do
    expect(resource.search_params).to include(:name)
  end

  it 'has modify params' do
    expect(resource.modify_params).to include(:name)
    expect(resource.modify_params).to include(:password)
  end

  it 'makes use of decent_exposure' do
    expect(resource.controller_extensions).to include("expose :#{resource.model_name}")
    expect(resource.controller_extensions).to include("expose :#{resource.collection_name}")
  end

  it 'configures search params' do
    resource.search :title
    expect(resource.search_params).to include(:title)
    expect(resource.search_params).to_not include(:name)
  end

  it 'configures modify params' do
    resource.modify :token
    expect(resource.edit_params).to include(:token)
    expect(resource.edit_params).to_not include(:password)
  end

  it 'provides the user class name' do
    expect(resource.model_class).to eq(User)
  end
end
