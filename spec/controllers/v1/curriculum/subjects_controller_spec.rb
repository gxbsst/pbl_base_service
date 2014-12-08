require 'rails_helper'

describe V1::Curriculum::SubjectsController do

  describe 'GET #index' do
    let!(:subject) { create :curriculum_subject }
    before(:each) do
      get :index, format: :json
    end

    it { expect(response).to render_template :index }
    it { expect(assigns(:subjects)).to match_array([subject])}
  end

  describe 'GET #show' do
    context 'with found' do
      let!(:subject) { create :curriculum_subject }
      before(:each) do
        get :show, id: subject, format: :json
      end

      it { expect(response.status).to  eq(200) }
      it { expect(response).to render_template :show}
      it { expect(assigns(:subject)).to eq(subject)}
    end

    context 'with not found' do
      let!(:subject) { create :curriculum_subject }
      before(:each) do
        get :show, id: '16720e7f-74d4-4c8f-afda-9657e659b432', format: :json
      end

      it { expect(response.status).to  eq(404) }
      it { expect(response).to_not render_template :show}
      it { expect(assigns(:subject)).to be_nil }
    end
  end

  describe 'POST #create' do
    context 'with successful' do
      before(:each) do
        post :create, subject: attributes_for(:curriculum_subject), format: :json
      end

      it { expect(response.status).to eq(201)}
      it { expect(Curriculums::Subject.count).to eq(1) }
    end

    context 'with failed' do
      before(:each) do
        post :create, subject: attributes_for(:curriculum_subject, name: ''), format: :json
      end

      it { expect(response.status).to eq(422)}
      it {expect(Curriculums::Subject.count).to eq(0) }
    end
  end

  describe 'PATCH #update' do
    context 'with successful' do
      let(:subject) { create :curriculum_subject }
      before(:each) do
        patch :update, id: subject, subject: attributes_for(:curriculum_subject, name: 'name'), format: :json
      end

      it { expect(response.status).to eq(200)}
      it { expect(Curriculums::Subject.first.name).to eq('name') }
    end

    context 'with failed' do
      let(:subject) { create :curriculum_subject, name: 'original name' }
      before(:each) do
        patch :update, id: subject, subject: attributes_for(:curriculum_subject, name: ''), format: :json
      end

      it { expect(response.status).to eq(422)}
      it { expect(Curriculums::Subject.first.name).to eq('original name') }
    end
  end

  describe 'DELETE #destroy' do
    let(:subject) { create :curriculum_subject }
    before(:each) do
      delete :destroy, id: subject, format: :json
    end
    it { expect(response.status).to eq(200)}
    it { expect(Curriculums::Subject.count).to eq(0)}
  end

end