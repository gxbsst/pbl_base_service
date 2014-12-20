require 'rails_helper'

describe V1::Curriculum::PhasesController do
  describe 'GET #index' do
    let!(:phase_1) { create :curriculum_phase, name: 'name1'}
    let!(:phase_2) { create :curriculum_phase, name: 'name2'}
    before(:each) do
      get '/curriculum/phases/', {}, accept
      @json = parse_json(response.body)
    end

    it { expect(response.body).to have_json_type(Hash) }
    it { expect(@json['data'][0]['name']).to eq('name2') }
    it { expect(@json['data'][1]['name']).to eq('name1') }

    context 'with page' do
      context 'page 1' do
        before(:each) do
          get '/curriculum/phases?page=1&limit=1', {}, accept
          @json = parse_json(response.body)
        end

        it { expect(@json['data'][0]['name']).to eq('name2')}
        it { expect(@json['meta']['total_pages']).to eq(2)}
        it { expect(@json['meta']['current_page']).to eq(1)}
        it { expect(@json['meta']['per_page']).to eq('1')}
      end
    end

    context 'with ids' do
      let!(:phase_3) { create :curriculum_phase, name: 'name3'}
      let!(:phase_4) { create :curriculum_phase, name: 'name4'}
      before(:each) do
        get "/curriculum/phases/#{phase_3.id.to_s},#{phase_4.id.to_s}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json.size).to eq(2)}
      it { expect(@json['data'][0]['name']).to eq('name4') }
      it { expect(@json['data'][1]['name']).to eq('name3') }
    end

    context 'with subject_id' do
      let(:subject) { create :curriculum_subject }
      context ' with collect subject_id' do
        let!(:phase) { create :curriculum_phase, subject_id: subject.id}
        before(:each) do
          get "/curriculum/phases?subject_id=#{subject.id}", {} , accept
          @json = parse_json(response.body)
        end
        it { expect(response.status).to eq(200)}
        it { expect(response.body).to have_json_type(Hash) }
        it {expect(@json['data'][0]['id']).to eq(phase.id)}
      end
      context 'with error subject_id' do
        before(:each) do
          get "/curriculum/phases/?subject_id=16720e7f-74d4-4c8f-afda-9657e659b432", {} , accept
          @json = parse_json(response.body)
        end
        it { expect(response.status).to eq(200)}
        it { expect(@json['data']).to be_a Array }
        it { expect(@json['meta']).to be_a Hash}
      end
    end
  end

  describe 'GET #show' do
    let!(:phase) { create :curriculum_phase, name: 'name' }
    before(:each) do
      get "/curriculum/phases/#{phase.id.to_s}", {}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['id']).to eq(phase.id.to_s) }
    it { expect(@json['name']).to eq('name') }

    context 'with include' do
      pending
    end
  end

  describe "DELETE #destroy" do
   pending
  end

  describe "PATCH #update g" do
    pending
  end

end