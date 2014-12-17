require 'rails_helper'

describe V1::Pbl::KnowledgeController do

  describe 'DELETE #destory' do
    let!(:project) { create :pbl_project }
    let!(:knowledge)  { create :pbl_knowledge, project_id: project.id }
    before(:each) do
      delete "/pbl/knowledge/#{knowledge.id}", {}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['id']).to eq(knowledge.id)}

  end
end