require 'rails_helper'

describe V1::SkillsController, type: :request do
  describe 'GET #index' do
    let!(:skill_1)  { create :skill, title: 'title' }
    let!(:skill_2)  { create :skill, title: 'title2' }
    before(:each) do
      get '/skills', {}, accept
      @json = parse_json(response.body)
    end

    it { expect(response.body).to have_json_type(Array) }
    it { expect(@json[0]['title']).to eq('title2') }
    it { expect(@json[1]['title']).to eq('title') }

    context 'with page' do
      context 'page 1' do
        before(:each) do
          get '/skills?page=1&limit=1', {}, accept
          @json = parse_json(response.body)
        end

        it { expect(@json[0]['title']).to eq('title2')}
      end

    end

    context 'with ids' do
      let!(:skill_3)  { create :skill, title: 'title3' }
      let!(:skill_4)  { create :skill, title: 'title4' }
      before(:each) do
        get "/skills/#{skill_3.id.to_s},#{skill_4.id.to_s}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json.size).to eq(2)}
      it { expect(@json[0]['title']).to eq('title4') }
      it { expect(@json[1]['title']).to eq('title3') }
    end

  end

  describe 'GET #show' do
    let!(:skill)  { create :skill, title: 'title' }
    before(:each) do
      get "/skills/#{skill.id.to_s}", {}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['id']).to eq(skill.id.to_s) }
    it { expect(@json['title']).to eq('title') }

    context 'with include' do
      let!(:skill)  { create :skill_with_categories, categories_count: 10,  title: 'title'}
      before(:each) do
        get "/skills/#{skill.id.to_s}/?include=categories", {}, accept
        @json = parse_json(response.body)
      end
      it { expect(@json['categories']).to  be_a Array }
      it { expect(@json['categories'].size).to eq(10) }
    end
  end

  describe 'POST #create' do
    before(:each) do
      post "/skills", {skill: {title: 'skill title'}}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['title']).to eq('skill title') }
  end

  describe 'PATCH #update' do
    let!(:skill)  { create :skill, title: 'title' }

    before(:each) do
      patch "/skills/#{skill.id.to_s}", {skill: {title: 'skill update title'}}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['id']).to eq(skill.id.to_s) }
  end
end