require 'rails_helper'

describe V1::SkillsController do

 describe 'GET #index' do
  let!(:skill) { create :skill }
  before(:each) do
   get :index, format: :json
  end

  it { expect(response).to render_template :index }
  it { expect(assigns(:skills)).to match_array([skill])}
 end

 describe 'GET #show' do
  context 'with found' do
   let!(:skill) { create :skill }
   before(:each) do
    get :show, id: skill, format: :json
   end

   it { expect(response.status).to  eq(200) }
   it { expect(response).to render_template :show}
   it { expect(assigns(:skill)).to eq(skill)}
  end

  context 'with not found' do
   let!(:skill) { create :skill }
   before(:each) do
    get :show, id: '16720e7f-74d4-4c8f-afda-9657e659b432', format: :json
   end

   it { expect(response.status).to  eq(404) }
   it { expect(response).to_not render_template :show}
   it { expect(assigns(:skill)).to be_nil }
  end
 end

 describe 'POST #create' do
  context 'with successful' do
   before(:each) do
    post :create, skill: attributes_for(:skill), format: :json
   end

   it { expect(response.status).to eq(201)}
   it {expect(Skill.count).to eq(1) }
  end

  context 'with failed' do
   before(:each) do
    post :create, skill: attributes_for(:skill, title: ''), format: :json
   end

   it { expect(response.status).to eq(422)}
   it {expect(Skill.count).to eq(0) }
  end
 end

 describe 'PATCH #update' do
  context 'with successful' do
   let(:skill) { create :skill }
   before(:each) do
    patch :update, id: skill, skill: attributes_for(:skill, title: 'title'), format: :json
   end

   it { expect(response.status).to eq(200)}
   it { expect(Skill.first.title).to eq('title') }
  end

  context 'with failed' do
   let(:skill) { create :skill, title: 'original title' }
   before(:each) do
    patch :update, id: skill, skill: attributes_for(:skill, title: ''), format: :json
   end

   it { expect(response.status).to eq(422)}
   it { expect(Skill.first.title).to eq('original title') }
  end
 end

 describe 'DELETE #destroy' do
  let(:skill) { create :skill }
  before(:each) do
   delete :destroy, id: skill, format: :json
  end
  it { expect(response.status).to eq(200)}
  it { expect(Skill.count).to eq(0)}
 end

end