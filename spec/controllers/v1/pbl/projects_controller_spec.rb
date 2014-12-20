require 'rails_helper'

describe V1::Pbl::ProjectsController do
  describe 'GET #index' do
    let!(:project) { create :pbl_project}
    before(:each) do
      get :index, format: :json
    end

    it { expect(response).to render_template :index }
    it { expect(assigns(:collections)).to match_array([project])}
  end

  describe 'GET #show' do
    context 'with found' do
      let!(:project) { create :pbl_project }
      before(:each) do
        get :show, id: project, format: :json
      end

      it { expect(response.status).to  eq(200) }
      it { expect(response).to render_template :show}
      it { expect(assigns(:clazz_instance)).to eq(project)}
    end

    context 'with not found' do
      let!(:project) { create :pbl_project }
      before(:each) do
        get :show, id: '16720e7f-74d4-4c8f-afda-9657e659b432', format: :json
      end

      it { expect(response.status).to  eq(404) }
      it { expect(response).to_not render_template :show}
      it { expect(assigns(:project)).to be_nil }
    end
  end

  describe 'POST #create' do
    context 'with successful' do
      before(:each) do
        post :create, project: attributes_for(:pbl_project), format: :json
      end

      it { expect(response.status).to eq(201)}
      it { expect(Pbls::Project.count).to eq(1) }
    end

    context 'with failed' do
      before(:each) do
        post :create, project: attributes_for(:pbl_project, name: ''), format: :json
      end

      it { expect(response.status).to eq(201)}
      it {expect(Pbls::Project.count).to eq(1) }
    end
  end

  describe 'PATCH #update' do
    context 'with successful' do
      let(:project) { create :pbl_project }
      before(:each) do
        patch :update, id: project, project: attributes_for(:pbl_project, name: 'name'), format: :json
      end

      it { expect(response.status).to eq(200)}
      it { expect(Pbls::Project.first.name).to eq('name') }
    end

    context 'with failed' do
      let(:project) { create :pbl_project, name: 'original name' }
      before(:each) do
        patch :update, id: project, project: attributes_for(:pbl_project, name: ''), format: :json
      end

      it { expect(response.status).to eq(200)}
      it { expect(Pbls::Project.first.name).to eq('') }
    end
  end

  describe 'DELETE #destroy' do
    let(:project) { create :pbl_project }
    before(:each) do
      delete :destroy, id: project, format: :json
    end
    it { expect(response.status).to eq(200)}
    it { expect(Pbls::Project.count).to eq(0)}
  end
end