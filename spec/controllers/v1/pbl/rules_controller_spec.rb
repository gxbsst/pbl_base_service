require 'rails_helper'

describe V1::Pbl::RulesController do
  let(:project) { create :pbl_project }
  let(:gauge) { create :gauge }
  let(:technique) { create :skill_technique }
  describe 'GET #index' do
    let!(:rule) { create :pbl_rule, project_id: project.id, gauge_id: gauge.id, technique_id: technique.id }
    before(:each) do
      get :index, project_id: project.id, format: :json
    end

    it { expect(response).to render_template :index }
    it { expect(assigns(:collections)).to match_array([rule])}
  end

  describe 'GET #show' do
    context 'with found' do
      let(:rule) { create :pbl_rule, project_id: project.id, gauge_id: gauge.id, technique_id: technique.id }

      before(:each) do
        get :show, id: rule, format: :json
      end

      it { expect(response.status).to  eq(200) }
      it { expect(response).to render_template :show}
      it { expect(assigns(:clazz_instance)).to eq(rule)}
    end

    context 'with not found' do
      let(:rule) { create :pbl_rule, project_id: project.id, gauge_id: gauge.id, technique_id: technique.id }
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
        post :create, rule: attributes_for(:pbl_rule, project_id: project.id, technique_id: technique.id,  gauge_id: gauge.id), format: :json
      end

      it { expect(response.status).to eq(201)}
      it { expect(Pbls::Rule.count).to eq(1) }
      it { expect(Pbls::Rule.first.project).to eq(project) }
      it { expect(Pbls::Rule.first.technique).to eq(technique) }
      it { expect(Pbls::Rule.first.gauge).to eq(gauge) }
    end

    context 'with failed' do
      it { expect{post :create, rule: attributes_for(:pbl_rule), format: :json}.to_not raise_error() }
    end
  end

  describe 'PATCH #update' do
    context 'with successful' do
      let!(:rule) { create :pbl_rule, project_id: project.id }
      before(:each) do
        patch :update, id: rule, rule: attributes_for(:pbl_rule, project_id: project.id, level_1: 'level'), format: :json
      end

      it { expect(response.status).to eq(200)}
      it { expect(Pbls::Rule.first.level_1).to eq('level')}
    end
  end

  describe 'DELETE #destroy' do
    let!(:rule) { create :pbl_rule, project_id: project.id }
    before(:each) do
      delete :destroy, id: rule, format: :json
    end
    it { expect(response.status).to eq(200)}
    it { expect(Pbls::Rule.count).to eq(0)}
  end
end