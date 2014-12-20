require 'rails_helper'

describe V1::Skill::CategoriesController do

 describe 'GET #index' do
  let!(:category) { create :skill_category}
  before(:each) do
   get :index, format: :json
  end

  it { expect(response).to render_template :index }
  it { expect(assigns(:collections)).to match_array([category])}
 end

 describe 'GET #show' do
  context 'with found' do
   let!(:category) { create :skill_category }
   before(:each) do
    get :show, id: category, format: :json
   end

   it { expect(response.status).to  eq(200) }
   it { expect(response).to render_template :show}
   it { expect(assigns(:clazz_instance)).to eq(category)}
  end

  context 'with not found' do
   let!(:category) { create :skill_category }
   before(:each) do
    get :show, id: '16720e7f-74d4-4c8f-afda-9657e659b432', format: :json
   end

   it { expect(response.status).to  eq(404) }
   it { expect(response).to_not render_template :show}
   it { expect(assigns(:category)).to be_nil }
  end
 end

 describe 'POST #create' do
  context 'with successful' do
   before(:each) do
    post :create, category: attributes_for(:skill_category), format: :json
   end

   it { expect(response.status).to eq(201)}
   it {expect(Skills::Category.count).to eq(1) }
  end

  context 'with failed' do
   before(:each) do
    post :create, category: attributes_for(:skill_category, name: ''), format: :json
   end

   it { expect(response.status).to eq(422)}
   it {expect(Skills::Category.count).to eq(0) }
  end
 end

 describe 'PATCH #update' do
  context 'with successful' do
   let(:category) { create :skill_category }
   before(:each) do
    patch :update, id: category, category: attributes_for(:skill_category, name: 'title'), format: :json
   end

   it { expect(response.status).to eq(200)}
   it { expect(Skills::Category.first.name).to eq('title') }
  end

  context 'with failed' do
   let(:category) { create :skill_category, name: 'original title' }
   before(:each) do
    patch :update, id: category, category: attributes_for(:skill_category, name: ''), format: :json
   end

   it { expect(response.status).to eq(422)}
   it { expect(Skills::Category.first.name).to eq('original title') }
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