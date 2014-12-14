# require 'rails_helper'
#
# describe V1::RolesController do
#   let(:resource) { create :pbl_project }
#   let(:user) { create :user }
#   let(:user_role) { create :user_role, user_id: user.id }
#   describe 'GET #index' do
#     let!(:role) { create :role, name: 'teacher', resource_id: resource.id, resource_type: technique.id }
#     before(:each) do
#       get :index, role: role.id, format: :json
#     end
#
#     it { expect(response).to render_template :index }
#     it { expect(assigns(:roles)).to match_array([role])}
#   end
#
#   describe 'GET #show' do
#     context 'with found' do
#       let(:rule) { create :pbl_rule, project_id: project.id, gauge_id: gauge.id, technique_id: technique.id }
#
#       before(:each) do
#         get :show, id: rule, format: :json
#       end
#
#       it { expect(response.status).to  eq(200) }
#       it { expect(response).to render_template :show}
#       it { expect(assigns(:rule)).to eq(rule)}
#     end
#
#     context 'with not found' do
#       let(:rule) { create :pbl_rule, project_id: project.id, gauge_id: gauge.id, technique_id: technique.id }
#       before(:each) do
#         get :show, id: '16720e7f-74d4-4c8f-afda-9657e659b432', format: :json
#       end
#
#       it { expect(response.status).to  eq(404) }
#       it { expect(response).to_not render_template :show}
#       it { expect(assigns(:rule)).to be_nil }
#     end
#   end
#
#   describe 'POST #create' do
#     context 'with successful' do
#       before(:each) do
#         post :create, rule: attributes_for(:pbl_rule, project_id: project.id, technique_id: technique.id,  gauge_id: gauge.id), format: :json
#       end
#
#       it { expect(response.status).to eq(201)}
#       it { expect(Pbls::Rule.count).to eq(1) }
#       it { expect(Pbls::Rule.first.project).to eq(project) }
#       it { expect(Pbls::Rule.first.technique).to eq(technique) }
#       it { expect(Pbls::Rule.first.gauge).to eq(gauge) }
#     end
#
#     context 'with failed' do
#       it { expect{post :create, rule: attributes_for(:pbl_rule), format: :json}.to raise_error(RuntimeError) }
#     end
#   end
#
#   describe 'PATCH #update' do
#     context 'with successful' do
#       let!(:rule) { create :pbl_rule, project_id: project.id }
#       before(:each) do
#         patch :update, id: rule, rule: attributes_for(:pbl_rule, project_id: project.id, level_1: 'level'), format: :json
#       end
#
#       it { expect(response.status).to eq(200)}
#       it { expect(Pbls::Rule.first.level_1).to eq('level')}
#     end
#   end
#
#   describe 'DELETE #destroy' do
#     let!(:rule) { create :pbl_rule, project_id: project.id }
#     before(:each) do
#       delete :destroy, id: rule, format: :json
#     end
#     it { expect(response.status).to eq(200)}
#     it { expect(Pbls::Rule.count).to eq(0)}
#   end
# end