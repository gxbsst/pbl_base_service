require 'rails_helper'

describe V1::ResourcesController do
  let(:owner) { create :pbl_project }
  describe 'GET #index' do
    let!(:resource_1)  { create :resource, owner_type: owner.class.name, owner_id: owner.id, name: 'name 1' }
    let!(:resource_2)  { create :resource, owner_type: owner.class.name, owner_id: owner.id, name: 'name 2' }

    context 'get resources' do
      before(:each) do
        get '/resources', {owner_type: owner.class.name, owner_id: owner.id}, accept
        @json = parse_json(response.body)
      end

      it { expect(response.body).to have_json_type(Hash) }
      it { expect(@json['data'][0]['name']).to eq('name 2') }
      it { expect(@json['data'][1]['name']).to eq('name 1') }
    end

    context 'with  owner_type and owner_id' do
      let(:owner) { create :pbl_project }
      let!(:resource)  { create :resource, owner_type: 'project_product', owner_id: owner.id, name: 'name 1' }
      before(:each) do
        get "/resources/project_product/#{owner.id}", {}, accept
        @json = parse_json(response.body)
      end
      it { expect(@json['data'].size).to eq(1) }
    end

    context 'with  owner_type and owner_ids' do
      let(:owner_1) { create :pbl_project }
      let(:owner_2) { create :pbl_project }
      let!(:resource_1)  { create :resource, owner_type: 'project_product', owner_id: owner_1.id, name: 'name 1' }
      let!(:resource_2)  { create :resource, owner_type: 'project_product', owner_id: owner_2.id, name: 'name 1' }
      let!(:resource_3)  { create :resource, owner_type: 'project_product' }
      before(:each) do
        get "/resources/", {owner_type: 'project_product', owner_ids: "#{owner_1.id},#{owner_2.id}"}, accept
        @json = parse_json(response.body)
      end
      it { expect(@json['data'].size).to eq(2) }
    end

    context 'with page' do
      before(:each) do
        get 'resources?page=1&limit=1', {owner_type: owner.class.name, owner_id: owner.id}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['meta']['total_pages']).to eq(2)}
      it { expect(@json['meta']['current_page']).to eq(1)}
      it { expect(@json['meta']['per_page']).to eq('1')}
    end

    context 'with include owner' do
      before(:each) do
        get 'resources?include=owner', {owner_type: owner.class.name, owner_id: owner.id}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'][0]['owner']).to be_a Array }
      it { expect(@json['data'][0]['owner'][0]['owner_type']).to eq(owner.class.name) }
      it { expect(@json['data'][0]['owner'][0]['owner_id']).to eq(owner.id) }
    end
  end

  describe 'GET #show' do
    context 'with found' do
      let!(:resource)  { create :resource, owner_type: owner.class.name, owner_id: owner.id, name: 'name 1' }
      before(:each) do
        get "/resources/#{resource.id}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['id']).to eq(resource.id.to_s) }
      it { expect(@json['name']).to eq('name 1') }
      it { expect(@json['owner_id']).to_not be_nil }
      it { expect(@json['owner_type']).to eq(owner.class.name) }
      it { expect(@json['size']).to eq('size') }
      it { expect(@json['ext']).to eq('ext') }
      it { expect(@json['mime_type']).to eq('mime_type') }
      it { expect(@json['md5']).to eq('md5') }
      it { expect(@json['key']).to eq('key') }
      it { expect(@json['exif']).to eq('exif') }
      it { expect(@json['image_info']).to eq('image_info') }
      it { expect(@json['image_ave']).to eq('image_ave') }
      it { expect(@json['persistent_id']).to eq('persistent_id') }
      it { expect(@json['avinfo']).to eq('avinfo') }
    end

    context 'with not found' do
      let!(:resource)  { create :resource, owner_type: owner.class.name, owner_id: owner.id, name: 'name 1' }
      before(:each) do
        get '/resources/16720e7f-74d4-4c8f-afda-9657e659b432', {}, accept
      end

      it { expect(response.status).to  eq(404) }
    end
  end

  describe 'POST #create' do
    context 'with successful' do
      before(:each) do
        post '/resources', { resource: attributes_for(:resource, owner_id: owner.id, owner_type: owner.class.name) }, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['name']).to eq('name') }
    end
  end

  describe 'DELETE #destroy' do
    let!(:resource)  { create :resource, owner_type: owner.class.name, owner_id: owner.id, name: 'name 1' }
    it { expect{  delete "/resources/#{resource.id}", {}, accept }.to change(Resource, :count).from(1).to(0) }
  end
end