require 'rails_helper'

describe V1::Curriculum::StandardsController do
  describe 'GET #index' do
    let!(:standard_1) { create :curriculum_standard, title: 'name1'}
    let!(:standard_2) { create :curriculum_standard, title: 'name2'}

    context 'with data' do
      before(:each) do
        get '/curriculum/standards/', {}, accept
        @json = parse_json(response.body)
      end

      it { expect(response.body).to have_json_type(Hash) }
      it { expect(@json['data'][0]['title']).to eq('name2') }
      it { expect(@json['data'][1]['title']).to eq('name1') }
    end

    context 'with empty' do
      before(:each) do
        Curriculums::Standard.destroy_all
        get '/curriculum/standards/', {}, accept
        @json = parse_json(response.body)
      end

      it { expect(response.body).to have_json_type(Hash) }
      it { expect(@json['data']).to eq([])}
    end

    context 'with page' do
      context 'page 1' do
        before(:each) do
          get '/curriculum/standards?page=1&limit=1', {}, accept
          @json = parse_json(response.body)
        end

        it { expect(@json['data'][0]['title']).to eq('name2')}
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

    context 'with phase_id' do
      let(:phase) { create :curriculum_phase }
      context ' with collect phase_id' do
        let!(:standard) { create :curriculum_standard, phase_id: phase.id}
        before(:each) do
          get "/curriculum/standards?phase_id=#{phase.id}", {} , accept
          @json = parse_json(response.body)
        end
        it { expect(response.status).to eq(200)}
        it { expect(response.body).to have_json_type(Hash) }
        it {expect(@json['data'][0]['id']).to eq(standard.id)}
      end

      context 'with error phase_id' do
        before(:each) do
          get '/curriculum/standards/?phase_id=16720e7f-74d4-4c8f-afda-9657e659b432', {} , accept
          @json = parse_json(response.body)
        end

        it { expect(response.status).to eq(200)}
        it { expect(@json['data']).to be_a Array }
        it { expect(@json['meta']).to be_a Hash}
      end
    end

    context 'with include items' do
      let(:phase) { create :curriculum_phase }
      let!(:standard) { create :curriculum_standard_with_items, phase_id: phase.id, standard_items_count: 5}
      before(:each) do
        get "/curriculum/standards/?phase_id=#{phase.id.to_s}&include=items", {} , accept
        @json = parse_json(response.body)
      end

      it { expect(response.status).to eq(200)}
      it {expect(@json['data'][0]['items'].size).to eq(5)}

      context 'without items' do
        let(:phase) { create :curriculum_phase }
        let!(:standard) { create :curriculum_standard, phase_id: phase.id}
        before(:each) do
          get "/curriculum/standards/?phase_id=#{phase.id.to_s}&include=items", {} , accept
          @json = parse_json(response.body)
        end

        it { expect(response.status).to eq(200)}
        it {expect(@json['data'][0]['items'].size).to eq(0)}
      end
    end

  end

  describe 'GET #show' do
    let!(:standard) { create :curriculum_standard, title: 'name' }
    before(:each) do
      get "/curriculum/standards/#{standard.id.to_s}", {}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['id']).to eq(standard.id.to_s) }
    it { expect(@json['title']).to eq('name') }

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