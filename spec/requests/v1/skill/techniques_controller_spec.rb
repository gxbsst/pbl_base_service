require 'rails_helper'

describe V1::Skill::TechniquesController do
 let(:sub_category) { create :skill_sub_category }

 describe 'GET #index' do
  let!(:clazz_instance_1)  { create :skill_technique,  sub_category_id: sub_category.id, title: 'title_1' }
  let!(:clazz_instance_2)  { create :skill_technique,  sub_category_id: sub_category.id, title: 'title_2' }

  before(:each) do
   get '/skill/techniques', {sub_category_id: sub_category.id}, accept
   @json = parse_json(response.body)
  end

  it { expect(response.body).to have_json_type(Hash) }

  context 'with page' do
   context 'page 1' do
    before(:each) do
     get '/skill/techniques?page=1&limit=1', {sub_category_id: sub_category.id}, accept
     @json = parse_json(response.body)
    end

    it { expect(@json['data'][0]['title']).to eq('title_2')}
    it { expect(@json['meta']['total_pages']).to eq(2)}
    it { expect(@json['meta']['current_page']).to eq(1)}
    it { expect(@json['meta']['per_page']).to eq('1')}
   end
  end
 end

 describe 'GET #show' do
  context 'with found' do
   let!(:clazz_instance) { create :skill_technique, sub_category_id: sub_category.id, title: 'title' }
   before(:each) do
    get "/skill/techniques/#{clazz_instance.id}", {}, accept
    @json = parse_json(response.body)
   end

   it { expect(@json['id']).to eq(clazz_instance.id.to_s) }
   it { expect(@json['sub_category_id']).to eq(sub_category.id) }
   it { expect(@json['title']).to eq('title') }
  end

  context 'with not found' do
   let!(:technique) { create :skill_technique, sub_category_id: sub_category.id }
   before(:each) do
    get '/skill/techniques/16720e7f-74d4-4c8f-afda-9657e659b432', {}, accept
   end

   it { expect(response.status).to  eq(404) }
  end
 end

 describe 'POST #create' do
  context 'with successful' do
   before(:each) do
    post '/skill/techniques', { technique: attributes_for(:skill_technique, sub_category_id: sub_category.id) }, accept
    @json = parse_json(response.body)
   end

   it { expect(@json['sub_category_id']).to eq(sub_category.id) }
  end

  context 'with failed' do
    it { expect {post '/skill/techniques', { technique: attributes_for(:skill_technique) }, accept }.to raise_error(RuntimeError) }
  end
 end

 describe 'DELETE #destroy' do
  let!(:technique) { create :skill_technique, sub_category_id: sub_category.id }
  it { expect{  delete "skill/techniques/#{technique.id}", {}, accept }.to change(Skills::Technique, :count).from(1).to(0) }
 end
end