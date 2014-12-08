require 'rails_helper'

describe V1::Pbl::ProjectsController do
  describe 'GET #index' do
    let!(:project) { create :pbl_project}
    before(:each) do
      get :index, format: :json
    end

    it { expect(response).to render_template :index }
    it { expect(assigns(:projects)).to match_array([project])}
  end

  describe 'GET #show' do
    context 'with found' do
      let!(:project) { create :pbl_project }
      before(:each) do
        get :show, id: project, format: :json
      end

      it { expect(response.status).to  eq(200) }
      it { expect(response).to render_template :show}
      it { expect(assigns(:project)).to eq(project)}
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
end