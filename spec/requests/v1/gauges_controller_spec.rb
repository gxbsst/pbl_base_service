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

    it { expect(response.body).to have_json_type(Hash) }
    it { expect(@json['data'][0]['level_2']).to eq('level_2') }
    it { expect(@json['data'][1]['level_1']).to eq('level_1') }

    context 'with page' do
      context 'page 1' do
        before(:each) do
          get 'gauges?page=1&limit=1', {}, accept
          @json = parse_json(response.body)
        end

        it { expect(@json['meta']['total_pages']).to eq(2)}
        it { expect(@json['meta']['current_page']).to eq(1)}
        it { expect(@json['meta']['per_page']).to eq('1')}
      end
    end

    context 'with technique_ids' do
      let(:technique_1) { create :skill_technique }
      let(:technique_2) { create :skill_technique }
      let(:technique_3) { create :skill_technique }
      let!(:gauge_1)  { create :gauge, level_1: 'level_1', technique_id: technique_1.id, reference_count: 2 }
      let!(:gauge_2)  { create :gauge, level_2: 'level_2', technique_id: technique_2.id, reference_count: 1 }
      let!(:gauge_3)  { create :gauge, level_2: 'level_3', technique_id: technique_3.id }
      before(:each) do
        get "gauges?technique_ids=#{technique_1.id},#{technique_2.id}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(2) }
      it { expect(@json['data'][0]['reference_count']).to eq(2) }
      it { expect(@json['data'][0]['level_1']).to eq('level_1') }
      it { expect(@json['data'][1]['reference_count']).to eq(1) }
      it { expect(@json['data'][1]['level_2']).to eq('level_2') }
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

  describe 'GET #recommends' do
    let(:technique_1) { create :skill_technique }
    let!(:gauge_1_1)  { create :gauge, level_1: 'technique_1 level_1', technique_id: technique_1.id, reference_count: 1 }
    let!(:gauge_1_2)  { create :gauge, level_1: 'technique_1 level_2', technique_id: technique_1.id, reference_count: 2 }
    let!(:gauge_1_3)  { create :gauge, level_1: 'technique_1 level_3', technique_id: technique_1.id, reference_count: 3 }
    let!(:gauge_1_4)  { create :gauge, level_1: 'technique_1 level_1', technique_id: technique_1.id, reference_count: 0 }

    let(:technique_2) { create :skill_technique }
    let!(:gauge_2_1)  { create :gauge, level_1: 'technique_2 level_1', technique_id: technique_2.id, reference_count: 1 }
    let!(:gauge_2_2)  { create :gauge, level_1: 'technique_2 level_2', technique_id: technique_2.id, reference_count: 2 }
    let!(:gauge_2_3)  { create :gauge, level_1: 'technique_2 level_3', technique_id: technique_2.id, reference_count: 3 }
    let!(:gauge_2_4)  { create :gauge, level_1: 'level_1', technique_id: technique_2.id, reference_count: 0 }

    let(:technique_3) { create :skill_technique }
    let!(:gauge_3_1)  { create :gauge, level_1: 'technique_3 level_1', technique_id: technique_3.id, reference_count: 1 }
    let!(:gauge_3_2)  { create :gauge, level_1: 'technique_3 level_2', technique_id: technique_3.id, reference_count: 2 }
    let!(:gauge_3_3)  { create :gauge, level_1: 'technique_3 level_3', technique_id: technique_3.id, reference_count: 3 }
    let!(:gauge_3_4)  { create :gauge, level_1: 'level_1', technique_id: technique_3.id, reference_count: 0 }
    before(:each) do
      @technique_ids = [technique_1.id, technique_2.id]
      get 'gauges/recommends', {limit: 3, technique_ids: "#{technique_1.id},#{technique_2.id}"}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['data'].size).to eq(2)}

    it { expect(@technique_ids).to include(@json['data'][0]['technique_id'])}
    it { expect(@technique_ids).to include(@json['data'][1]['technique_id'])}
    it { expect(@json['data'][0]['gauges'].size).to eq(3)}
    it { expect(@json['data'][1]['gauges'].size).to eq(3)}
    # it { expect(@json[technique_1.id][0]['level_1']).to eq('technique_1 level_3')}
    # it { expect(@json[technique_1.id][1]['level_1']).to eq('technique_1 level_2')}
    # it { expect(@json[technique_1.id][2]['level_1']).to eq('technique_1 level_1')}
    #
    # it { expect(@json[technique_2.id].size).to eq(3)}
    # it { expect(@json[technique_2.id][0]['level_1']).to eq('technique_2 level_3')}
    # it { expect(@json[technique_2.id][1]['level_1']).to eq('technique_2 level_2')}
    # it { expect(@json[technique_2.id][2]['level_1']).to eq('technique_2 level_1')}
    #
    # it { expect(@json[technique_3.id].size).to eq(3)}
    # it { expect(@json[technique_3.id][0]['level_1']).to eq('technique_3 level_3')}
    # it { expect(@json[technique_3.id][1]['level_1']).to eq('technique_3 level_2')}
    # it { expect(@json[technique_3.id][2]['level_1']).to eq('technique_3 level_1')}
  end
end