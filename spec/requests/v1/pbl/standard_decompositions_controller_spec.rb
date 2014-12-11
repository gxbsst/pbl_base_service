require 'rails_helper'

RSpec.describe V1::Pbl::StandardDecompositionsController, :type => :request do
  describe 'POST #create' do
    context 'with project_id' do
      let!(:project) { create :pbl_project }
      before(:each) do
        post '/pbl/standard_decompositions', {standard_decomposition: attributes_for(:standard_decomposition, project_id: project.id)}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['id']).to_not be_nil }
      it { expect(@json['role']).to eq('role') }
      it { expect(@json['verb']).to eq('verb') }
      it { expect(@json['technique']).to eq('technique') }
      it { expect(@json['noun']).to eq('noun') }
      it { expect(@json['product_name']).to eq('product_name') }
      it { expect(@json['project_id']).to eq(project.id) }
    end

    context 'without project_id' do
      before(:each) do
        post '/pbl/standard_decompositions', {standard_decomposition: attributes_for(:standard_decomposition, project_id: nil)}, accept
        @json = parse_json(response.body)
      end

      it { expect(response.status).to eq(422) }
      it { expect(@json['error']['project']).to be_a Array }
    end
  end

  describe 'DELETE #destory' do
    let(:project) { create :pbl_project }
    let!(:standard_decomposition) { create :standard_decomposition, project_id: project.id}
    before(:each) do
      delete "/pbl/standard_decompositions/#{standard_decomposition.id}", {}, accept
    end
    it { expect(Pbls::StandardDecomposition.count).to eq(0) }
  end

end
