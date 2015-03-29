RSpec.describe Resource do
  subject do
    Resource.new :user do
      search :name
      modify :name, :password
      actions :index, :show, :edit, :update, :destroy
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

  it 'protects given actions' do
    actions = resource.send(:protected_actions).split ' '
    expect(actions).to include(:index)
    expect(actions).to include(:show)
    expect(actions).to include(:edit)
    expect(actions).to include(:update)
    expect(actions).to include(:destroy)
  end

  it 'makes use of decent_exposure' do
    expect(resource.controller_extensions).to include("expose :#{resource.model_name}")
    expect(resource.controller_extensions).to include("expose :#{resource.collection_name}")
  end

  it 'will not authenticate or authorize when libraries are not present' do
    expect(resource.controller_extensions).to_not include('before_action :authenticate_user!')
    expect(resource.controller_extensions).to_not include('authorize_actions_for')
  end

  it 'authenticates protected actions when devise is present' do
    allow(resource).to receive(:devise?).and_return true
    expect(resource.controller_extensions).to include('authorize_actions_for')
  end

  it 'authorizes protected actions when authority is present' do
    allow(resource).to receive(:authority?).and_return true
    expect(resource.controller_extensions).to include('authorize_actions_for')
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

  it 'protects actions' do
    resource.protect :custom
    expect(resource.send(:protected_actions).split(' ')).to include('custom')
    expect(resource.send(:protected_actions).split(' ')).to include('index')
  end

  it 'removes protection from actions' do
    resource.unprotect :index
    expect(resource.send(:protected_actions).split(' ')).to_not include('index')
  end

  it 'sets actions' do
    resource.actions :index, :new
    expect(resource.send(:protected_actions).split(' ')).to include('index')
    expect(resource.send(:protected_actions).split(' ')).to include('new')
    expect(resource.send(:protected_actions).split(' ')).to_not include('custom')
  end
end
