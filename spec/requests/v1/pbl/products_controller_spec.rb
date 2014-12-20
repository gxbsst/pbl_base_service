require 'rails_helper'

describe V1::Pbl::ProductsController do
 describe 'GET #index' do
  let(:project) { create :pbl_project }
  let!(:product_1)  { create :pbl_product, project_id: project.id }
  let!(:product_2)  { create :pbl_product, project_id: project.id }

  before(:each) do
   get '/pbl/products', {project_id: project.id}, accept
   @json = parse_json(response.body)
  end

  it { expect(response.body).to have_json_type(Hash) }

  context 'with page' do
   context 'page 1' do
    before(:each) do
     get '/pbl/products?page=1&limit=1', {project_id: project.id}, accept
     @json = parse_json(response.body)
    end

    it { expect(@json['meta']['total_pages']).to eq(2)}
    it { expect(@json['meta']['current_page']).to eq(1)}
    it { expect(@json['meta']['per_page']).to eq('1')}
   end
  end

  context 'with include product_form' do
   let!(:product_form) { create :product_form }
   let!(:product) { create :pbl_product, project_id: project.id, product_form_id: product_form.id}
   before(:each) do
    get '/pbl/products', {project_id: project.id, include: 'product_form'}, accept
    @json = parse_json(response.body)
   end

   it { expect(@json['data'][0]['product_form']).to be_a Hash}
   it { expect(@json['data'][0]['product_form']['product_form_id']).to eq(product_form.id)}
   it { expect(@json['data'][0]['product_form']['product_form_uri']).to eq("/product_forms/#{product_form.id}")}
  end

  context 'with include resources' do
   let!(:product) { create :pbl_product_with_resources, project_id: project.id, resources_count: 5}
   before(:each) do
    get '/pbl/products', {project_id: project.id, include: 'resources'}, accept
    @json = parse_json(response.body)
   end

   it { expect(@json['data'][0]['resources']).to be_a Hash}
   it { expect(@json['data'][0]['resources']['owner_type']).to eq('project_product')}
   it { expect(@json['data'][0]['resources']['owner_id']).to eq(product.id)}
   it { expect(@json['data'][0]['resources']['resource_uri']).to eq("/resources/project_product/#{product.id}")}
  end

  context 'with include product_form & resources' do
   let!(:product_form) { create :product_form }
   let!(:product) { create :pbl_product_with_resources, project_id: project.id, resources_count: 5, product_form_id: product_form.id}
   before(:each) do
    get '/pbl/products', {project_id: project.id, include: 'resources,product_form'}, accept
    @json = parse_json(response.body)
   end
   it { expect(@json['data'][0]['product_form']['product_form_id']).to eq(product_form.id)}
   it { expect(@json['data'][0]['resources']['owner_type']).to eq('project_product')}
   it { expect(@json['data'][0]['resources']).to be_a Hash}
   it { expect(@json['data'][0]['product_form']).to be_a Hash}
  end
 end

 describe 'GET #show' do
  context 'with found' do
   let!(:project) { create :pbl_project }
   let!(:product_form) { create :product_form }
   let!(:product) { create :pbl_product, project_id: project.id, product_form_id: product_form.id }
   before(:each) do
    get "/pbl/products/#{product.id}", {}, accept
    @json = parse_json(response.body)
   end

   it { expect(@json['id']).to eq(product.id.to_s) }
   it { expect(@json['project_id']).to eq(project.id) }
   it { expect(@json['description']).to eq('description') }
   it { expect(@json['product_form_id']).to eq(product_form.id) }

   context 'with include product_form' do
    let(:product_form) { create :product_form }
    let!(:product)  { create :pbl_product, product_form_id: product_form.id, project_id: project.id}
    before(:each) do
     get "/pbl/products/#{product.id.to_s}?include=product_form", {project_id: project.id}, accept
     @json = parse_json(response.body)
    end

    it { expect(assigns(:include_product_form)).to eq(true)}
    it { expect(@json['product_form']).to be_a String }
    it { expect(@json['product_form']).to eq(product.product_form.id) }
   end
  end

  context 'with not found' do
   let!(:project) { create :pbl_project }
   let!(:product) { create :pbl_product, project_id: project.id }
   before(:each) do
    get '/pbl/products/16720e7f-74d4-4c8f-afda-9657e659b432', {}, accept
   end

   it { expect(response.status).to  eq(404) }
  end
 end

 describe 'POST #create' do
  let!(:project) { create :pbl_project }
  context 'with successful' do

   before(:each) do
    post '/pbl/products', { product: attributes_for(:pbl_product, project_id: project.id) }, accept
    @json = parse_json(response.body)
   end

  end

  context 'with failed' do
   it { expect {post '/pbl/products', { product: attributes_for(:pbl_product) }, accept }.to_not raise_error() }
  end
 end

 describe 'PATCH #update' do
  context 'with successful' do
   let!(:project) { create :pbl_project }
   let!(:product) { create :pbl_product, project_id: project.id }
   before(:each) do
    patch "/pbl/products/#{product.id}", {product: attributes_for(:pbl_product, project_id: project.id)}, accept
    @json = parse_json(response.body)
   end

   it { expect(@json['id']).to eq(product.id.to_s) }
  end

  context 'with failed' do
   let!(:project) { create :pbl_project }
   let!(:product) { create :pbl_product, project_id: project.id }
   before(:each) do
    patch "/pbl/products/#{product.id}", {product: attributes_for(:pbl_product)}, accept
   end

   it { expect {post '/pbl/products', { product: attributes_for(:pbl_product) }, accept }.to_not raise_error() }
  end
 end

 describe 'DELETE #destroy' do
  let!(:project) { create :pbl_project }
  let!(:product) { create :pbl_product, project_id: project.id }
  it { expect{  delete "pbl/products/#{product.id}", {}, accept }.to change(Pbls::Product, :count).from(1).to(0) }
 end
end