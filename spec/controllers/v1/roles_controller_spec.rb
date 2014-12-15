require 'rails_helper'

describe V1::RolesController do
  let(:resource) { create :pbl_project }
  let(:user) { create :user }

  describe 'GET #index' do
    let!(:role) { create :role, name: 'teacher', resource_id: resource.id, resource_type: resource.class.name }
    let!(:user_role) { create :users_role, user_id: user.id, role_id: role.id }
    before(:each) do
      get :index, format: :json
    end

    it { expect(response).to render_template :index }
    it { expect(assigns(:roles)).to match_array([role])}
  end

  describe 'GET #show' do
    context 'with found' do
      let!(:role) { create :role, name: 'teacher', resource_id: resource.id, resource_type: resource.class.name }
      let!(:user_role) { create :users_role, user_id: user.id, role_id: role.id }

      before(:each) do
        get :show, id: role, format: :json
      end

      it { expect(response.status).to  eq(200) }
      it { expect(response).to render_template :show}
      it { expect(assigns(:role)).to eq(role)}
    end

    context 'with not found' do
      let!(:role) { create :role, name: 'teacher', resource_id: resource.id, resource_type: resource.class.name }
      let!(:user_role) { create :users_role, user_id: user.id, role_id: role.id }
      before(:each) do
        get :show, id: '16720e7f-74d4-4c8f-afda-9657e659b432', format: :json
      end

      it { expect(response.status).to  eq(404) }
      it { expect(response).to_not render_template :show}
      it { expect(assigns(:role)).to be_nil }
    end
  end

  describe 'POST #create' do
    context 'with successful' do
      before(:each) do
        post :create, role: attributes_for(:role, name: 'teacher', resource_id: resource.id, resource_type: resource.class.name.demodulize), format: :json
      end

      it { expect(response.status).to eq(201)}
      it { expect(Role.count).to eq(1) }
      it { expect(Role.first.resource_type).to eq('Project')}
    end

    context 'with failed' do
      before(:each) { post :create, role: attributes_for(:role, name: ''), format: :json }

      it { expect(Role.count).to eq(0) }
    end
  end

  describe 'PATCH #update' do
    let!(:role) { create :role, name: 'teacher', resource_id: resource.id, resource_type: resource.class.name }
    let!(:user_role) { create :users_role, user_id: user.id, role_id: role.id }

    context 'with successful' do
      before(:each) do
        patch :update, id: role, role: attributes_for(:role, name: 'role name'), format: :json
      end

      it { expect(response.status).to eq(200)}
      it { expect(Role.first.name).to eq('role name')}
    end

    context 'with failed' do
      before(:each) do
        patch :update, id: role, role: attributes_for(:role, name: ''), format: :json
      end

      it { expect(response.status).to eq(422)}
      it { expect(Role.first.name).to eq('teacher')}
    end

  end

  describe 'DELETE #destroy' do
    let!(:role) { create :role, name: 'teacher', resource_id: resource.id, resource_type: resource.class.name }
    let!(:user_role) { create :users_role, user_id: user.id, role_id: role.id }
    before(:each) do
      delete :destroy, id: role, format: :json
    end

    it { expect(response.status).to eq(200)}
    it { expect(Role.count).to eq(0)}
  end
end