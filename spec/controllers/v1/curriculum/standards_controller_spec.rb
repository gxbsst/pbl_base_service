require 'rails_helper'

describe V1::Curriculum::StandardsController do

  describe 'GET #show' do
    context 'with found' do
      let!(:standard) { create :curriculum_standard }
      before(:each) do
        get :show, id: standard, format: :json
      end

      it { expect(response.status).to  eq(200) }
      it { expect(response).to render_template :show}
      it { expect(assigns(:standard)).to eq(standard)}
    end

    context 'with not found' do
      let!(:standard) { create :curriculum_standard }
      before(:each) do
        get :show, id: '16720e7f-74d4-4c8f-afda-9657e659b432', format: :json
      end

      it { expect(response.status).to  eq(404) }
      it { expect(response).to_not render_template :show}
      it { expect(assigns(:standard)).to be_nil }
    end
  end

  describe 'POST #create' do

    let(:phase) { create :curriculum_phase}
    context 'with successful' do
      before(:each) do
        post :create, standard: attributes_for(:curriculum_standard, title: 'title', phase_id: phase.id.to_s ), format: :json
      end

      it { expect(response.status).to eq(201)}
      it { expect(Curriculums::Standard.count).to eq(1) }
    end

    context 'with failed' do
      before(:each) do
        post :create, standard: attributes_for(:curriculum_standard,  phase_id: phase.id.to_s, title: ''), format: :json
      end

      it { expect(response.status).to eq(422)}
      it {expect(Curriculums::Standard.count).to eq(0) }
    end
  end

  describe 'PATCH #update' do
    context 'with successful' do
      let(:standard) { create :curriculum_standard }
      before(:each) do
        patch :update, id: standard, standard: attributes_for(:curriculum_standard, title: 'title'), format: :json
      end

      it { expect(response.status).to eq(200)}
      it { expect(Curriculums::Standard.first.title).to eq('title') }
    end

    context 'with failed' do
      let(:standard) { create :curriculum_standard, title: 'original title' }
      before(:each) do
        patch :update, id: standard, standard: attributes_for(:curriculum_standard, title: ''), format: :json
      end

      it { expect(response.status).to eq(422)}
      it { expect(Curriculums::Standard.first.title).to eq('original title') }
    end
  end

  describe 'DELETE #destroy' do
    let(:standard) { create :curriculum_standard }
    before(:each) do
      delete :destroy, id: standard, format: :json
    end
    it { expect(response.status).to eq(200)}
    it { expect(Curriculums::Standard.count).to eq(0)}
  end

  describe 'GET #Index' do
    let!(:standard) { create :curriculum_standard }
    before(:each) do
      get :index, format: :json
    end

    it { expect(response).to render_template :index }
    it { expect(response.status).to eq(200) }
    it { expect(assigns(:standards)).to match_array([standard])}
  end

end