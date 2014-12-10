require 'rails_helper'

describe V1::Skill::SubCategoriesController do
  describe 'GET #show' do
    let(:sub_category) { create(:skill_sub_category, name: 'name')}
    before(:each) do
      get "skill/sub_categories/#{sub_category.id.to_s}", {}, accept
      @json  = parse_json(response.body)
    end

    it { expect(@json['id']).to eq(sub_category.id.to_s) }
    it { expect(@json['name']).to eq('name') }

    context 'with include' do
      let!(:sub_category)  { create :skill_sub_category_with_technique, techniques_count: 10, name: 'name'}
      before(:each) do
        get "/skill/sub_categories/#{sub_category.id.to_s}/?include=techniques", {}, accept
        @json = parse_json(response.body)
      end
      it { expect(@json['techniques']).to  be_a Array }
      it { expect(@json['techniques'].size).to eq(10) }
    end
  end

  describe 'POST #create' do
    let(:category) { create :skill_category }
    before(:each) do
      post "/skill/sub_categories", {sub_category: {name: 'cat name', category_id: category.id.to_s}}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['name']).to eq('cat name') }
  end

  describe 'PATCH #update' do
    let!(:category) { create :skill_category }
    let!(:sub_category) { create :skill_sub_category, category_id: category.id }
    before(:each) do
      patch "/skill/sub_categories/#{sub_category.id.to_s}", {sub_category: {name: 'cate update name'}}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['id']).to eq(sub_category.id.to_s) }
  end

  describe 'DELETE #destory' do
    let(:sub_category) { create :skill_sub_category }
    before(:each) do
      delete "/skill/sub_categories/#{sub_category.id.to_s}", {}, accept
      @json = parse_json(response.body)
    end

    it { expect(Skills::SubCategory.count).to eq(0)}

  end
end