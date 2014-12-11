require 'rails_helper'

describe V1::GaugesController do
  let(:technique) { create :skill_technique }
  describe 'GET #index' do
    let!(:gauge_1)  { create :gauge, level_1: 'level_1', technique_id: technique.id }
    let!(:gauge_2)  { create :gauge, level_2: 'level_2', technique_id: technique.id }

    before(:each) do
      get '/gauges', {}, accept
      @json = parse_json(response.body)
    end

    it { expect(response.body).to have_json_type(Array) }
    it { expect(@json[0]['level_2']).to eq('level_2') }
    it { expect(@json[1]['level_1']).to eq('level_1') }
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