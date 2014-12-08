require 'rails_helper'

describe V1::Curriculum::SubjectsController do
  describe 'GET #index' do
    let!(:subject1) { create :curriculum_subject, name: 'name1'}
    let!(:subject2) { create :curriculum_subject, name: 'name2'}
    before(:each) do
      get '/curriculum/subjects/', {}, accept
      @json = parse_json(response.body)
    end

    it { expect(response.body).to have_json_type(Array) }
    it { expect(@json[0]['name']).to eq('name2') }
    it { expect(@json[1]['name']).to eq('name1') }

    context 'with page' do
      context 'page 1' do
        before(:each) do
          get '/curriculum/subjects?page=1&limit=1', {}, accept
          @json = parse_json(response.body)
        end

        it { expect(@json[0]['name']).to eq('name2')}
      end
    end

    context 'with ids' do
      let!(:subject3) { create :curriculum_subject, name: 'name3'}
      let!(:subject4) { create :curriculum_subject, name: 'name4'}
      before(:each) do
        get "/curriculum/subjects/#{subject3.id.to_s},#{subject4.id.to_s}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json.size).to eq(2)}
      it { expect(@json[0]['name']).to eq('name4') }
      it { expect(@json[1]['name']).to eq('name3') }
    end
  end

  describe 'GET #show' do
    let!(:subject)  { create :curriculum_subject, name: 'name' }
    before(:each) do
      get "/curriculum/subjects/#{subject.id.to_s}", {}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['id']).to eq(subject.id.to_s) }
    it { expect(@json['name']).to eq('name') }

    context 'with include' do
      let!(:subject)  { create :curriculum_subject_with_phases, phases_count: 10 }
      before(:each) do
        get "/curriculum/subjects/#{subject.id.to_s}/?include=phases", {}, accept
        @json = parse_json(response.body)
      end
      it { expect(@json['phases']).to  be_a Array }
      it { expect(@json['phases'].size).to eq(10) }
    end
  end

  describe 'POST #create' do
    before(:each) do
      post "/curriculum/subjects", {subject: {name: 'name'}}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['name']).to eq('name') }
  end

  describe 'PATCH #update' do
    let!(:subject)  { create :curriculum_subject }

    before(:each) do
      patch "/curriculum/subjects/#{subject.id.to_s}", {subject: {name: 'name'}}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['id']).to eq(subject.id.to_s) }
  end
end