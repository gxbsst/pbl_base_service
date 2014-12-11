require 'rails_helper'

RSpec.describe V1::Pbl::StandardDecompositionsController, :type => :controller do
  describe 'POST #create' do
    let(:project) { create :pbl_project }
    before(:each) do
     post :create, standard_decomposition: attributes_for(:standard_decomposition, project_id: project.id), format: :json
    end

    it { expect(response).to render_template :show }
    it { expect(Pbls::StandardDecomposition.count).to eq(1)}
  end
end
