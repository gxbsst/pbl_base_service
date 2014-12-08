require 'rails_helper'

describe V1::Curriculum::PhasesController do

  describe 'GET #show' do
    let(:phase) { create(:curriculum_phase, name: 'name')}
    before(:each) do
      get :show, id: phase, format: :json
    end

    it { expect(response).to render_template :show}
    it { expect(assigns(:phase)).to eq(phase)}
  end

  describe 'POST #create' do
    let(:subject) { create :curriculum_subject}
    context 'with successful' do
      before(:each) do
        post :create, phase: attributes_for(:curriculum_phase, subject_id: subject.id.to_s), format: :json
      end

      it { expect(response.status).to eq(201)}
      it {expect(Curriculums::Phase.count).to eq(1) }
    end

    context 'with failed' do
      before(:each) do
        post :create, phase: attributes_for(:curriculum_phase, subject_id: subject.id.to_s, name: ''), format: :json
      end

      it { expect(response.status).to eq(422)}
      it {expect(Curriculums::Phase.count).to eq(0) }
    end
  end

  describe 'PATCH #update' do
    context 'with successful' do
      let(:phase) { create :curriculum_phase}
      before(:each) do
        patch :update, id: phase, phase: attributes_for(:curriculum_phase, name: 'name update'), format: :json
      end

      it { expect(response.status).to eq(200)}
      it { expect(Curriculums::Phase.first.name).to eq('name update') }
    end

    context 'with failed' do
      let(:phase) { create :curriculum_phase, name: 'original name' }
      before(:each) do
        patch :update, id:phase, phase: attributes_for(:curriculum_phase, name: ''), format: :json
      end

      it { expect(response.status).to eq(422)}
      it { expect(Curriculums::Phase.first.name).to eq('original name') }
    end
  end

  describe 'DELETE #destroy' do
    let(:phase) { create :curriculum_phase }
    before(:each) do
      delete :destroy, id: phase, format: :json
    end
    it { expect(response.status).to eq(200)}
    it { expect(Curriculums::Phase.count).to eq(0)}
  end

end