require 'rails_helper'

describe V1::Skill::CategoriesController, type: :request do
  describe 'GET #index' do
    let!(:category_1)  { create :skill_category, name: 'title' }
    let!(:category_2)  { create :skill_category, name: 'title2' }
    before(:each) do
      get '/skill/categories', {}, accept
      @json = parse_json(response.body)
    end

    it { expect(response.body).to have_json_type(Hash) }
    it { expect(@json['data'][0]['name']).to eq('title2') }
    it { expect(@json['data'][1]['name']).to eq('title') }

    context 'with page' do
      context 'page 1' do
        before(:each) do
          get '/skill/categories?page=1&limit=1', {}, accept
          @json = parse_json(response.body)
        end

        it { expect(@json['meta']['total_pages']).to eq(2)}
        it { expect(@json['meta']['current_page']).to eq(1)}
        it { expect(@json['meta']['per_page']).to eq('1')}
      end
    end

    context 'with ids' do
      let!(:category_3)  { create :skill_category, name: 'title3' }
      let!(:category_4)  { create :skill_category, name: 'title4' }
      before(:each) do
        get "/skill/categories/#{category_3.id.to_s},#{category_4.id.to_s}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(2)}
      it { expect(@json['data'][0]['name']).to eq('title4') }
      it { expect(@json['data'][1]['name']).to eq('title3') }
    end

  end

  describe 'GET #show' do
    let!(:category)  { create :skill_category, name: 'name' }
    before(:each) do
      get "/skill/categories/#{category.id.to_s}", {}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['id']).to eq(category.id.to_s) }
    it { expect(@json['name']).to eq('name') }

    context 'with include' do
      let!(:category)  { create :skill_category_with_sub_categories, sub_categories_count: 10, name: 'title'}
      before(:each) do
        get "/skill/categories/#{category.id.to_s}/?include=sub_categories", {}, accept
        @json = parse_json(response.body)
      end
      it { expect(@json['sub_categories']).to  be_a Array }
      it { expect(@json['sub_categories'].size).to eq(10) }
    end
  end

  describe 'POST #create' do
    before(:each) do
      post "/skill/categories", {category: {name: 'category title'}}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['name']).to eq('category title') }
  end

  describe 'PATCH #update' do
    let!(:category)  { create :skill_category, name: 'title' }

    before(:each) do
      patch "/skill/categories/#{category.id.to_s}", {category: {name: 'category update title'}}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['id']).to eq(category.id.to_s) }
  end
end