require 'rails_helper'

describe V1::Pbl::TechniquesController do
  let(:project) { create :pbl_project }
  let(:technique) { create :skill_technique }
  describe 'GET #index' do
    let!(:clazz_instance) { create :pbl_technique, project_id: project.id, technique_id: technique.id }
    before(:each) do
      get :index, project_id: project.id, format: :json
    end

    it { expect(response).to render_template :index }
    it { expect(assigns(:collections)).to match_array([clazz_instance])}
  end

  describe 'GET #show' do
    context 'with found' do
      let(:clazz_instance) { create :pbl_technique, project_id: project.id,  technique_id: technique.id }

      before(:each) do
        get :show, id: clazz_instance, format: :json
      end

      it { expect(response.status).to  eq(200) }
      it { expect(response).to render_template :show}
      it { expect(assigns(:clazz_instance)).to eq(clazz_instance)}
    end

    context 'with not found' do
      let(:clazz_instance) { create :pbl_technique, project_id: project.id,  technique_id: technique.id }
      before(:each) do
        get :show, id: '16720e7f-74d4-4c8f-afda-9657e659b432', format: :json
      end

      it { expect(response.status).to  eq(404) }
      it { expect(response).to_not render_template :show}
      it { expect(assigns(:clazz_instance)).to be_nil }
    end
  end

  describe 'POST #create' do
    context 'with successful' do
      before(:each) do
        post :create, technique: attributes_for(:pbl_technique, project_id: project.id, technique_id: technique.id), format: :json
      end

      it { expect(response.status).to eq(201)}
      it { expect(Pbls::Technique.count).to eq(1) }
      it { expect(Pbls::Technique.first.project).to eq(project) }
    end

    context 'with failed' do
      it { expect{post :create, technique: attributes_for(:pbl_technique), format: :json}.to_not raise_error() }
    end
  end

  # describe 'PATCH #update' do
  #   context 'with successful' do
  #     let!(:clazz_instance) { create :pbl_techniqiue, project_id: project.id }
  #     before(:each) do
  #       patch :update, id: clazz_instance, technique: attributes_for(:pbl_techniqiue, project_id: project.id), format: :json
  #     end
  #
  #     it { expect(response.status).to eq(200)}
  #     it { expect(Pbls::Rule.first.level_1).to eq('level')}
  #   end
  # end

  describe 'DELETE #destroy' do
    let!(:clazz_instance) { create :pbl_technique, project_id: project.id }
    before(:each) do
      delete :destroy, id: clazz_instance, format: :json
    end
    it { expect(response.status).to eq(200)}
    it { expect(Pbls::Technique.count).to eq(0)}
  end
end