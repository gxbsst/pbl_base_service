require 'rails_helper'

describe V1::Skill::SubCategoriesController do

  describe 'GET #show' do
    let(:sub_category) { create(:skill_sub_category, name: 'name')}
    before(:each) do
      get :show, id: sub_category, format: :json
    end

    it { expect(response).to render_template :show}
    it { expect(assigns(:clazz_instance)).to eq(sub_category)}
  end

  describe 'POST #create' do
    let(:category) { create :skill_category }
    context 'with successful' do
      before(:each) do
        post :create, sub_category: attributes_for(:skill_sub_category, category_id: category.id), format: :json
      end

      it { expect(response.status).to eq(201)}
      it {expect(Skills::SubCategory.count).to eq(1) }
    end

    context 'with failed' do
      before(:each) do
        post :create, sub_category: attributes_for(:skill_sub_category, category_id: category.id.to_s, name: ''), format: :json
      end

      it {expect(response.status).to eq(422)}
      it {expect(Skills::SubCategory.count).to eq(0) }
    end
  end

  describe 'PATCH #update' do
    context 'with successful' do
      let(:sub_category) { create :skill_sub_category}
      before(:each) do
        patch :update, id: sub_category, sub_category: attributes_for(:skill_sub_category, name: 'name update'), format: :json
      end

      it { expect(response.status).to eq(200)}
      it { expect(Skills::SubCategory.first.name).to eq('name update') }
    end

    context 'with failed' do
      let(:sub_category) { create :skill_sub_category, name: 'original name' }
      before(:each) do
        patch :update, id: sub_category, sub_category: attributes_for(:skill_sub_category, name: ''), format: :json
      end

      it { expect(response.status).to eq(422)}
      it { expect(Skills::SubCategory.first.name).to eq('original name') }
    end
  end

  describe 'DELETE #destroy' do
    let(:sub_category) { create :skill_sub_category }
    before(:each) do
      delete :destroy, id: sub_category, format: :json
    end
    it { expect(response.status).to eq(200)}
    it { expect(Skills::SubCategory.count).to eq(0)}
  end

  describe 'GET #index' do
    let!(:sub_category) { create :skill_sub_category }
    before(:each) do
      get :index, format: :json
    end

    it { expect(response).to render_template :index }
    it { expect(response.status).to eq(200) }
    it { expect(assigns(:collections)).to match_array([sub_category])}
  end
end