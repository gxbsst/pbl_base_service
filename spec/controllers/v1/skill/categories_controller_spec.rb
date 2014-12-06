require 'rails_helper'

describe V1::Skill::CategoriesController do

  describe 'GET #show' do
    let(:category) { create(:skill_category, name: 'name')}
    before(:each) do
      get :show, id: category, format: :json
    end

    it { expect(response).to render_template :show}
    it { expect(assigns(:category)).to eq(category)}
  end

  describe 'POST #create' do
    let(:skill) { create :skill}
    context 'with successful' do
      before(:each) do
        post :create, category: attributes_for(:skill_category, skill_id: skill.id.to_s), format: :json
      end

      it { expect(response.status).to eq(201)}
      it {expect(Skills::Category.count).to eq(1) }
    end

    context 'with failed' do
      before(:each) do
        post :create, category: attributes_for(:skill_category, skill_id: skill.id.to_s, name: ''), format: :json
      end

      it { expect(response.status).to eq(422)}
      it {expect(Skills::Category.count).to eq(0) }
    end
  end

  describe 'PATCH #update' do
    context 'with successful' do
      let(:category) { create :skill_category}
      before(:each) do
        patch :update, id: category, category: attributes_for(:skill_category, name: 'name update'), format: :json
      end

      it { expect(response.status).to eq(200)}
      it { expect(Skills::Category.first.name).to eq('name update') }
    end

    context 'with failed' do
      let(:category) { create :skill_category, name: 'original name' }
      before(:each) do
        patch :update, id:category, category: attributes_for(:skill_category, name: ''), format: :json
      end

      it { expect(response.status).to eq(422)}
      it { expect(Skills::Category.first.name).to eq('original name') }
    end
  end

  describe 'DELETE #destroy' do
    let(:category) { create :skill_category }
    before(:each) do
      delete :destroy, id: category, format: :json
    end
    it { expect(response.status).to eq(200)}
    it { expect(Skills::Category.count).to eq(0)}
  end

end