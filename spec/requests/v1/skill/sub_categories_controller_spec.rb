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
      let!(:sub_category)  { create :skill_sub_category_with_techniques, techniques_count: 10, name: 'name'}
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

  describe 'GET #index' do
    let!(:sub_category_1) { create :skill_sub_category, name: 'name1'}
    let!(:sub_category_2) { create :skill_sub_category, name: 'name2'}
    before(:each) do
      get '/skill/sub_categories/', {}, accept
      @json = parse_json(response.body)
    end

    it { expect(response.body).to have_json_type(Hash) }
    it { expect(@json['data'][0]['name']).to eq('name2') }
    it { expect(@json['data'][1]['name']).to eq('name1') }

    context 'with page' do
      context 'page 1' do
        before(:each) do
          get '/skill/sub_categories?page=1&limit=1', {}, accept
          @json = parse_json(response.body)
        end

        it { expect(@json['data'][0]['name']).to eq('name2')}
        it { expect(@json['meta']['total_pages']).to eq(2)}
        it { expect(@json['meta']['current_page']).to eq(1)}
        it { expect(@json['meta']['per_page']).to eq('1')}
      end
    end

    context 'with ids' do
      before(:each) do
        get "/skill/sub_categories/#{sub_category_1.id.to_s},#{sub_category_2.id.to_s}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json.size).to eq(2)}
      it { expect(@json['data'][0]['name']).to eq('name2') }
      it { expect(@json['data'][1]['name']).to eq('name1') }
    end

    context 'with category_id' do
      let(:category) { create :skill_category }
      context ' with collect subject_id' do
        let!(:sub_category) { create :skill_sub_category, category_id: category.id}
        before(:each) do
          get "/skill/sub_categories?category_id=#{category.id}", {} , accept
          @json = parse_json(response.body)
        end
        it { expect(response.status).to eq(200)}
        it { expect(response.body).to have_json_type(Hash) }
        it {expect(@json['data'][0]['id']).to eq(sub_category.id)}
      end
      context 'with error category_id' do
        before(:each) do
          get "/skill/sub_categories/?category_id=16720e7f-74d4-4c8f-afda-9657e659b432", {} , accept
          @json = parse_json(response.body)
        end
        it { expect(response.status).to eq(200)}
        it { expect(@json['data']).to be_a Array }
        it { expect(@json['meta']).to be_a Hash}
      end
    end

    context 'with include techniques' do
      let(:category) { create :skill_category }
      let!(:sub_category) { create :skill_sub_category_with_techniques, category_id: category.id, techniques_count: 5}
      before(:each) do
        get "/skill/sub_categories/?category_id=#{category.id.to_s}&include=techniques", {} , accept
        @json = parse_json(response.body)
      end

      it { expect(response.status).to eq(200)}
      it {expect(@json['data'][0]['techniques'].size).to eq(5)}

      context 'without techniques' do
        let!(:sub_category) { create :skill_sub_category, category_id: category.id}
        before(:each) do
          get "/skill/sub_categories/?category_id=#{category.id.to_s}&include=techniques", {} , accept
          @json = parse_json(response.body)
        end

        it { expect(response.status).to eq(200)}
        it {expect(@json['data'][0]['techniques'].size).to eq(0)}

      end
    end

  end

end