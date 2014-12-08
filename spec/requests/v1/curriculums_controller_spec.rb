require 'rails_helper'

describe V1::CurriculumsController do
  describe 'GET #index' do
    let!(:curriculum1) { create :curriculum, subject: 'subject1'}
    let!(:curriculum2) { create :curriculum, subject: 'subject2'}
    before(:each) do
      get '/subjects/', {}, accept
      @json = parse_json(response.body)
    end

    it { expect(response.body).to have_json_type(Array) }
    it { expect(@json[0]['subject']).to eq('subject2') }
    it { expect(@json[1]['subject']).to eq('subject1') }

    context 'with page' do
      context 'page 1' do
        before(:each) do
          get '/subjects?page=1&limit=1', {}, accept
          @json = parse_json(response.body)
        end

        it { expect(@json[0]['subject']).to eq('subject2')}
      end
    end

    context 'with ids' do
      let!(:curriculum3) { create :curriculum, subject: 'subject3'}
      let!(:curriculum4) { create :curriculum, subject: 'subject4'}
      before(:each) do
        get "/subjects/#{curriculum3.id.to_s},#{curriculum4.id.to_s}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json.size).to eq(2)}
      it { expect(@json[0]['subject']).to eq('subject4') }
      it { expect(@json[1]['subject']).to eq('subject3') }
    end
  end

  describe 'GET #show' do
    let!(:curriculum)  { create :curriculum, subject: 'subject' }
    before(:each) do
      get "/subjects/#{curriculum.id.to_s}", {}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['id']).to eq(curriculum.id.to_s) }
    it { expect(@json['subject']).to eq('subject') }

    context 'with include' do
      let!(:curriculum)  { create :curriculum_with_phases, phases_count: 10 }
      before(:each) do
        get "/subjects/#{curriculum.id.to_s}/?include=phases", {}, accept
        @json = parse_json(response.body)
      end
      it { expect(@json['phases']).to  be_a Array }
      it { expect(@json['phases'].size).to eq(10) }
    end
  end

  describe 'POST #create' do
    before(:each) do
      post "/subjects", {curriculum: {subject: 'curriculum subject'}}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['subject']).to eq('curriculum subject') }
  end

  describe 'PATCH #update' do
    let!(:curriculum)  { create :curriculum }

    before(:each) do
      patch "/subjects/#{curriculum.id.to_s}", {curriculum: {subject: 'subject'}}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['id']).to eq(curriculum.id.to_s) }
  end
end