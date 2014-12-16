require 'rails_helper'

describe V1::ProductFormsController do

 describe 'GET #index' do
  let!(:clazz_instance_1)  { create :product_form, name: 'name_1', description: 'description_1'}
  let!(:clazz_instance_2)  { create :product_form, name: 'name_2', description: 'description_1'}

  before(:each) do
   get '/product_forms', {}, accept
   @json = parse_json(response.body)
  end

  it { expect(response.body).to have_json_type(Hash) }

  context 'with page' do
   context 'page 1' do
    before(:each) do
     get '/product_forms?page=1&limit=1', {}, accept
     @json = parse_json(response.body)
    end

    it { expect(@json['meta']['total_pages']).to eq(2)}
    it { expect(@json['meta']['current_page']).to eq(1)}
    it { expect(@json['meta']['per_page']).to eq('1')}
   end
  end

  context 'with ids' do
   before(:each) do
    get "/product_forms/#{clazz_instance_1.id.to_s},#{clazz_instance_2.id.to_s}", {}, accept
    @json = parse_json(response.body)
   end

   it { expect(@json['data'].size).to eq(2)}
   it { expect(@json['data'][0]['name']).to eq('name_2') }
   it { expect(@json['data'][1]['name']).to eq('name_1') }
  end
 end

 describe 'GET #show' do
  context 'with found' do
   let!(:clazz_instance) { create :product_form }
   before(:each) do
    get "/product_forms/#{clazz_instance.id}", {}, accept
    @json = parse_json(response.body)
   end

   it { expect(@json['id']).to eq(clazz_instance.id.to_s) }
   it { expect(@json['name']).to eq(clazz_instance.name) }
   it { expect(@json['description']).to eq(clazz_instance.description) }
  end

  context 'with not found' do
   let!(:clazz_instance) { create :product_form }
   before(:each) do
    get '/product_forms/16720e7f-74d4-4c8f-afda-9657e659b432', {}, accept
   end

   it { expect(response.status).to  eq(404) }
  end
 end

 describe 'POST #create' do
  context 'with successful' do
   before(:each) do
    post '/product_forms', { product_form: attributes_for(:product_form) }, accept
    @json = parse_json(response.body)
   end

   it { expect(@json['name']).to eq('name') }
  end

  context 'with failed' do
    it { expect {post '/product_forms', { product_form: attributes_for(:product_form) }, accept }.not_to raise_error }
  end
 end

 describe 'DELETE #destroy' do
  let!(:clazz_instance) { create :product_form }
  it { expect{  delete "/product_forms/#{clazz_instance.id}", {}, accept }.to change(ProductForm, :count).from(1).to(0) }
 end
end