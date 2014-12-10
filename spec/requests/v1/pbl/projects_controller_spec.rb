require 'rails_helper'

describe V1::Pbl::ProjectsController, type: :request do
  describe 'GET #index' do
    let!(:project_1)  { create :pbl_project, name: 'name' }
    let!(:project_2)  { create :pbl_project, name: 'name2' }
    before(:each) do
      get '/pbl/projects', {}, accept
      @json = parse_json(response.body)
    end

    it { expect(response.body).to have_json_type(Array) }
    it { expect(@json[0]['name']).to eq('name2') }
    it { expect(@json[1]['name']).to eq('name') }

    context 'with page' do
      context 'page 1' do
        before(:each) do
          get '/pbl/projects?page=1&limit=1', {}, accept
          @json = parse_json(response.body)
        end

        it { expect(@json[0]['name']).to eq('name2')}
      end
    end

    context 'with ids' do
      let!(:project_3)  { create :pbl_project, name: 'name3' }
      let!(:project_4)  { create :pbl_project, name: 'name4' }
      before(:each) do
        get "/pbl/projects/#{project_3.id.to_s},#{project_4.id.to_s}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json.size).to eq(2)}
      it { expect(@json[0]['name']).to eq('name4') }
      it { expect(@json[1]['name']).to eq('name3') }
    end

  end

  describe 'GET #show' do
    let!(:project)  { create :pbl_project, name: 'name' }
    before(:each) do
      get "/pbl/projects/#{project.id.to_s}", {}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['id']).to eq(project.id.to_s) }
    it { expect(@json['name']).to eq('name') }

    # context 'with include' do
    #   let!(:skill)  { create :skill_with_categories, categories_count: 10,  title: 'title'}
    #   before(:each) do
    #     get "/skills/#{skill.id.to_s}/?include=categories", {}, accept
    #     @json = parse_json(response.body)
    #   end
    #   it { expect(@json['categories']).to  be_a Array }
    #   it { expect(@json['categories'].size).to eq(10) }
    # end
  end

  describe 'POST #create' do
    before(:each) do
      post "/pbl/projects", {project: {name: 'name'}}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['name']).to eq('name') }

    describe 'standard_decompositions' do
      before(:each) do
        post "/pbl/projects", {project: attributes_for(:pbl_project, standard_decompositions_attributes: [attributes_for(:pbl_standard_decomposition, role: 'admin')])}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['standard_decompositions'][0]['role']).to eq('admin')}
    end
  end

  describe 'PATCH #update' do
    let!(:project)  { create :pbl_project, name: 'name' }

    before(:each) do
      patch "/pbl/projects/#{project.id.to_s}", {project: {name: 'skill update title'}}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['id']).to eq(project.id.to_s) }

    describe 'standard_decompositions' do
      context 'update with new standard decomposition' do
        let!(:project) { create :pbl_project_with_standard_decompositions, decompositions_count: 1}
        before(:each) do
          patch "/pbl/projects/#{project.id.to_s}", {project: attributes_for(:pbl_project, standard_decompositions_attributes: [attributes_for(:pbl_standard_decomposition, role: 'admin')])}, accept
          @json = parse_json(response.body)
        end

        it { expect(@json['standard_decompositions'].size).to eq(2) }
      end

      context 'update with new standard decomposition' do
        let!(:project) { create :pbl_project_with_standard_decompositions, decompositions_count: 1}
        before(:each) do
          patch "/pbl/projects/#{project.id.to_s}", {project: attributes_for(:pbl_project, standard_decompositions_attributes: [{id: project.standard_decompositions.first.id, _destroy: true}])}, accept
          @json = parse_json(response.body)
        end

        it { expect(@json['standard_decompositions'].size).to eq(0) }
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:project) { create :pbl_project }
    it { expect{  delete "pbl/projects/#{project.id}", {}, accept }.to change(Pbls::Project, :count).from(1).to(0) }

    describe 'standard_decompositions' do
      let!(:project) { create :pbl_project_with_standard_decompositions, decompositions_count: 1}
      it { expect{  delete "pbl/projects/#{project.id}", {}, accept }.to change(Pbls::StandardDecomposition, :count).from(1).to(0) }
    end
  end
end