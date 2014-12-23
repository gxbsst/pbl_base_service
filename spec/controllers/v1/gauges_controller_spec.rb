require 'rails_helper'

describe V1::GaugesController do
  let(:technique ) { create :skill_technique }
  describe 'GET #index' do
    let(:gauge ) { create :gauge, technique_id: technique.id }
    before(:each) do
      get :index, format: :json
    end

    it { expect(response).to render_template :index }
    it { expect(assigns(:collections)).to match_array([gauge])}
  end

  describe 'GET #show' do
    context 'with found' do
      let(:gauge ) { create :gauge, technique_id: technique.id }
      before(:each) do
        get :show, id: gauge, format: :json
      end

      it { expect(response.status).to  eq(200) }
      it { expect(response).to render_template :show}
      it { expect(assigns(:clazz_instance)).to eq(gauge)}
    end

    context 'with not found' do
      let(:gauge ) { create :gauge, technique_id: technique.id }
      before(:each) do
        get :show, id: '16720e7f-74d4-4c8f-afda-9657e659b432', format: :json
      end

      it { expect(response.status).to  eq(404) }
      it { expect(response).to_not render_template :show}
      it { expect(assigns(:gauge)).to be_nil }
    end
  end

  describe 'POST #create' do
    context 'with successful' do
      before(:each) do
        post :create, gauge: attributes_for(:gauge, technique_id: technique.id), format: :json
      end

      it { expect(response.status).to eq(201)}
      it { expect(Gauge.count).to eq(1) }
    end

    context 'with failed when without technique_id' do
      before(:each) do
        post :create, gauge: attributes_for(:gauge), format: :json
      end

      it { expect(response.status).to eq(422)}
      it { expect(Gauge.count).to eq(0) }
    end
  end

  describe 'PATCH #update' do
    let(:gauge ) { create :gauge, technique_id: technique.id }
    before(:each) do
      patch :update, id: gauge, gauge: attributes_for(:gauge, level_1: 'updated_level_1'), format: :json
    end

    it { expect(response.status).to eq(200)}
    it { expect(Gauge.first.level_1).to eq('updated_level_1') }
  end

  describe 'DELETE #destroy' do
    let(:gauge ) { create :gauge, technique_id: technique.id }
    before(:each) do
      delete :destroy, id: gauge, format: :json
    end
    it { expect(response.status).to eq(200)}
    it { expect(Gauge.count).to eq(0)}
  end
end