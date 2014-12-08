require 'rails_helper'

describe V1::Curriculum::CurriculumsController do

  describe 'GET #show' do
    context 'with found' do
      let!(:curriculum) { create :curriculum_curriculum }
      before(:each) do
        get :show, id: curriculum, format: :json
      end

      it { expect(response.status).to  eq(200) }
      it { expect(response).to render_template :show}
      it { expect(assigns(:curriculum)).to eq(curriculum)}
    end

    context 'with not found' do
      let!(:curriculum) { create :curriculum_curriculum }
      before(:each) do
        get :show, id: '16720e7f-74d4-4c8f-afda-9657e659b432', format: :json
      end

      it { expect(response.status).to  eq(404) }
      it { expect(response).to_not render_template :show}
      it { expect(assigns(:curriculum)).to be_nil }
    end
  end

  describe 'POST #create' do

    let(:phase) { create :curriculum_phase}
    context 'with successful' do
      before(:each) do
        post :create, curriculum: attributes_for(:curriculum_curriculum, title: 'title', phase_id: phase.id.to_s ), format: :json
      end

      it { expect(response.status).to eq(201)}
      it { expect(Curriculums::Curriculum.count).to eq(1) }
    end

    context 'with failed' do
      before(:each) do
        post :create, curriculum: attributes_for(:curriculum_curriculum,  phase_id: phase.id.to_s, title: ''), format: :json
      end

      it { expect(response.status).to eq(422)}
      it {expect(Curriculums::Curriculum.count).to eq(0) }
    end
  end

  describe 'PATCH #update' do
    context 'with successful' do
      let(:curriculum) { create :curriculum_curriculum }
      before(:each) do
        patch :update, id: curriculum, curriculum: attributes_for(:curriculum_curriculum, title: 'title'), format: :json
      end

      it { expect(response.status).to eq(200)}
      it { expect(Curriculums::Curriculum.first.title).to eq('title') }
    end

    context 'with failed' do
      let(:curriculum) { create :curriculum_curriculum, title: 'original title' }
      before(:each) do
        patch :update, id: curriculum, curriculum: attributes_for(:curriculum_curriculum, title: ''), format: :json
      end

      it { expect(response.status).to eq(422)}
      it { expect(Curriculums::Curriculum.first.title).to eq('original title') }
    end
  end

  describe 'DELETE #destroy' do
    let(:curriculum) { create :curriculum_curriculum }
    before(:each) do
      delete :destroy, id: curriculum, format: :json
    end
    it { expect(response.status).to eq(200)}
    it { expect(Curriculums::Curriculum.count).to eq(0)}
  end

end