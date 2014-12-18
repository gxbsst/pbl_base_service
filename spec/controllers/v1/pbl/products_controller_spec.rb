require 'rails_helper'

describe V1::Pbl::ProductsController do
 let(:project) { create :pbl_project }
 describe 'GET #index' do
  let!(:product) { create :pbl_product, project_id: project.id }
  before(:each) do
   get :index, project_id: project.id, format: :json
  end

  it { expect(response).to render_template :index }
  it { expect(assigns(:products)).to match_array([product])}
 end

 describe 'GET #show' do
  context 'with found' do
   let!(:project) { create :pbl_project }
   let!(:product) { create :pbl_product, project_id: project.id }
   before(:each) do
    get :show, id: product, format: :json
   end

   it { expect(response.status).to  eq(200) }
   it { expect(response).to render_template :show}
   it { expect(assigns(:product)).to eq(product)}
  end

  context 'with not found' do
   let!(:project) { create :pbl_project }
   let!(:product) { create :pbl_product, project_id: project.id }
   before(:each) do
    get :show, id: '16720e7f-74d4-4c8f-afda-9657e659b432', format: :json
   end

   it { expect(response.status).to  eq(404) }
   it { expect(response).to_not render_template :show}
   it { expect(assigns(:product)).to be_nil }
  end
 end

 describe 'POST #create' do
  let!(:project) { create :pbl_project }
  context 'with successful' do

   before(:each) do
    post :create, product: attributes_for(:pbl_product, project_id: project.id), format: :json
   end

   it { expect(response.status).to eq(201)}
   it { expect(Pbls::Product.count).to eq(1) }
  end

  context 'with failed' do
   before(:each) do
    post :create, product: attributes_for(:pbl_product, project_id: project.id), format: :json
   end

   it { expect(response.status).to eq(201)}
   it {expect(Pbls::Product.count).to eq(1) }
  end
 end

 describe 'PATCH #update' do
  context 'with successful' do
   let!(:project) { create :pbl_project }
   let!(:product) { create :pbl_product, project_id: project.id }
   before(:each) do
    patch :update, id: product, product: attributes_for(:pbl_product, project_id: project.id), format: :json
   end

   it { expect(response.status).to eq(200)}
  end

  context 'with failed' do
   let!(:project) { create :pbl_project }
   let!(:product) { create :pbl_product, project_id: project.id }
   before(:each) do
    patch :update, id: product, product: attributes_for(:pbl_product, project_id: project.id), format: :json
   end

   it { expect(response.status).to eq(200)}
  end
 end

 describe 'DELETE #destroy' do
  let!(:project) { create :pbl_project }
  let!(:product) { create :pbl_product, project_id: project.id }
  before(:each) do
   delete :destroy, id: product, format: :json
  end
  it { expect(response.status).to eq(200)}
  it { expect(Pbls::Product.count).to eq(0)}
 end
end