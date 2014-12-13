require 'rails_helper'

describe V1::Pbl::RulesController do
 let(:project) { create :pbl_project }

 describe 'GET #index' do
  let!(:rule_1)  { create :pbl_rule, level_1: 'level_1', project_id: project.id }
  let!(:rule_2)  { create :pbl_rule, level_1: 'level_2', project_id: project.id }

  before(:each) do
   get '/pbl/rules', {project_id: project.id}, accept
   @json = parse_json(response.body)
  end

  it { expect(response.body).to have_json_type(Hash) }
  it { expect(@json['data'][0]['level_1']).to eq('level_2') }
  it { expect(@json['data'][1]['level_1']).to eq('level_1') }

  context 'with page' do
   context 'page 1' do
    before(:each) do
     get '/pbl/rules?page=1&limit=1', {project_id: project.id}, accept
     @json = parse_json(response.body)
    end

    it { expect(@json['meta']['total_pages']).to eq(2)}
    it { expect(@json['meta']['current_page']).to eq(1)}
    it { expect(@json['meta']['per_page']).to eq('1')}

   end
  end
 end

 describe 'GET #show' do
  context 'with found' do
   let!(:rule) { create :pbl_rule, project_id: project.id }
   before(:each) do
    get "/pbl/rules/#{rule.id}", {}, accept
    @json = parse_json(response.body)
   end

   it { expect(@json['id']).to eq(rule.id.to_s) }
   it { expect(@json['level_1']).to eq('level_1') }
   it { expect(@json['level_2']).to eq('level_2') }
   it { expect(@json['level_3']).to eq('level_3') }
   it { expect(@json['level_4']).to eq('level_4') }
   it { expect(@json['level_5']).to eq('level_5') }
   it { expect(@json['level_6']).to eq('level_6') }
   it { expect(@json['level_7']).to eq('level_7') }
   it { expect(@json['weight']).to eq('weight') }
   it { expect(@json['project_id']).to eq(project.id) }
   it { expect(@json['technique_id']).to_not be_nil }
   it { expect(@json['gauge_id']).to_not be_nil }
  end

  context 'with not found' do
   let!(:rule) { create :pbl_rule, project_id: project.id }
   before(:each) do
    get '/pbl/rules/16720e7f-74d4-4c8f-afda-9657e659b432', {}, accept
   end

   it { expect(response.status).to  eq(404) }
  end
 end

 describe 'POST #create' do
  context 'with successful' do
   before(:each) do
    post '/pbl/rules', { rule: attributes_for(:pbl_rule, project_id: project.id) }, accept
    @json = parse_json(response.body)
   end

   it { expect(@json['level_2']).to eq('level_2') }
  end

  context 'with failed' do
    it { expect {post '/pbl/rules', { rule: attributes_for(:pbl_rule) }, accept }.to raise_error(RuntimeError) }
  end
 end

 describe 'PATCH #update' do
  context 'with successful' do
   let!(:rule) { create :pbl_rule, project_id: project.id }
   before(:each) do
    patch "/pbl/rules/#{rule.id}", {rule: attributes_for(:pbl_rule, level_1: 'form', project_id: project.id)}, accept
    @json = parse_json(response.body)
   end

   it { expect(@json['id']).to eq(rule.id.to_s) }
  end

  context 'with failed' do
   let!(:rule) { create :pbl_rule, level_1: 'original name', project_id: project.id }
   before(:each) do
    patch "/pbl/rules/#{rule.id}", {rule: attributes_for(:pbl_rule)}, accept
   end

   it { expect {post '/pbl/rules', { rule: attributes_for(:pbl_rule) }, accept }.to raise_error(RuntimeError) }
  end
 end

 describe 'DELETE #destroy' do
  let!(:rule) { create :pbl_rule, project_id: project.id }
  it { expect{  delete "pbl/rules/#{rule.id}", {}, accept }.to change(Pbls::Rule, :count).from(1).to(0) }
 end
end