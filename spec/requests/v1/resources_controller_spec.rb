require 'rails_helper'

describe V1::ResourcesController do
  let(:owner) { create :pbl_project }
  describe 'GET #index' do
    let!(:resource_1)  { create :resource, owner_type: owner.class.name, owner_id: owner.id, name: 'name 1' }
    let!(:resource_2)  { create :resource, owner_type: owner.class.name, owner_id: owner.id, name: 'name 2' }

    before(:each) do
      get '/resources', {owner_type: owner.class.name, owner_id: owner.id}, accept
      @json = parse_json(response.body)
    end

    it { expect(response.body).to have_json_type(Hash) }
    it { expect(@json['data'][0]['name']).to eq('name 2') }
    it { expect(@json['data'][1]['name']).to eq('name 1') }

    context 'with page' do
      context 'page 1' do
        before(:each) do
          get 'gauges?page=1&limit=1', {}, accept
          @json = parse_json(response.body)
        end

        # it { expect(@json['meta']['total_pages']).to eq(2)}
        # it { expect(@json['meta']['current_page']).to eq(1)}
        # it { expect(@json['meta']['per_page']).to eq('1')}

      end
    end
  end

  describe 'GET #show' do
    context 'with found' do
      let!(:gauge) { create :gauge, level_1: 'level_1', technique_id: technique.id }
      before(:each) do
        get "/gauges/#{gauge.id}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['id']).to eq(gauge.id.to_s) }
      it { expect(@json['level_1']).to eq('level_1') }
      it { expect(@json['level_2']).to eq('level_2') }
      it { expect(@json['level_3']).to eq('level_3') }
      it { expect(@json['level_4']).to eq('level_4') }
      it { expect(@json['level_5']).to eq('level_5') }
      it { expect(@json['level_6']).to eq('level_6') }
      it { expect(@json['level_7']).to eq('level_7') }
      it { expect(@json['technique_id']).to eq(technique.id) }
    end

    context 'with not found' do
      let!(:gauge) { create :gauge, technique_id: technique.id }
      before(:each) do
        get '/pbl/products/16720e7f-74d4-4c8f-afda-9657e659b432', {}, accept
      end

      it { expect(response.status).to  eq(404) }
    end
  end

  describe 'POST #create' do
    context 'with successful' do
      before(:each) do
        post '/gauges', { gauge: attributes_for(:gauge, technique_id: technique.id) }, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['level_1']).to eq('level_1') }
    end
  end

  describe 'PATCH #update' do
    context 'with successful' do
      let!(:gauge) { create :gauge, technique_id: technique.id }
      before(:each) do
        patch "/gauges/#{gauge.id}", {gauge: attributes_for(:gauge, level_1: 'level_1', technique_id: technique.id)}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['id']).to eq(gauge.id) }
    end
  end

  describe 'DELETE #destroy' do
    let!(:gauge) { create :gauge, technique_id: technique.id }
    it { expect{  delete "/gauges/#{gauge.id}", {}, accept }.to change(Gauge, :count).from(1).to(0) }
  end
end