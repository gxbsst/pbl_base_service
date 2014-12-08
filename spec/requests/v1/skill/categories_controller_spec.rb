require 'rails_helper'

describe V1::Skill::CategoriesController do
  describe 'GET #show' do
    let(:category) { create(:skill_category, name: 'name')}
    before(:each) do
      get "skill/categories/#{category.id.to_s}", {}, accept
      @json  = parse_json(response.body)
    end

    it { expect(@json['id']).to eq(category.id.to_s) }
    it { expect(@json['name']).to eq('name') }
    it { expect(@json['skill_id']).to eq(category.skill_id.to_s) }

    context 'with include' do
      let!(:category)  { create :skill_category_with_technique, techniques_count: 10, name: 'name'}
      before(:each) do
        get "/skill/categories/#{category.id.to_s}/?include=techniques", {}, accept
        @json = parse_json(response.body)
      end
      it { expect(@json['techniques']).to  be_a Array }
      it { expect(@json['techniques'].size).to eq(10) }
    end
  end

  describe 'POST #create' do
    let(:skill) { create :skill}
    before(:each) do
      post "/skill/categories", {category: {name: 'cat name', skill_id: skill.id.to_s}}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['name']).to eq('cat name') }
  end

  describe 'PATCH #update' do
    let!(:skill)  { create :skill }
    let!(:category) { create :skill_category, skill_id: skill.id.to_s}
    before(:each) do
      patch "/skill/categories/#{category.id.to_s}", {category: {name: 'cate update name'}}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['id']).to eq(category.id.to_s) }
  end

  describe 'DELETE #destory' do
    let(:category) { create :skill_category }
    before(:each) do
      delete "/skill/categories/#{category.id.to_s}", {}, accept
      @json = parse_json(response.body)
    end

    it { expect(Skills::Category.count).to eq(0)}

  end
end