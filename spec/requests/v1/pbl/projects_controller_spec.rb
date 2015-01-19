# encoding: utf-8
require 'rails_helper'

describe V1::Pbl::ProjectsController, type: :request do
  describe 'GET #index' do
    let!(:project_1)  { create :pbl_project, name: 'name' }
    let!(:project_2)  { create :pbl_project, name: 'name2' }
    before(:each) do
      get '/pbl/projects', {}, accept
      @json = parse_json(response.body)
    end
    it { expect(response.body).to have_json_type(Hash) }
    it { expect(@json['data'][0]['name']).to eq('name2') }
    it { expect(@json['data'][1]['name']).to eq('name') }

    context 'with page' do
      context 'page 1' do
        before(:each) do
          get '/pbl/projects?page=1&limit=1', {}, accept
          @json = parse_json(response.body)
        end

        it { expect(@json['data'][0]['name']).to eq('name2')}
        it { expect(@json['meta']['total_pages']).to eq(2)}
        it { expect(@json['meta']['current_page']).to eq(1)}
        it { expect(@json['meta']['per_page']).to eq('1')}

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
      it { expect(@json['data'][0]['name']).to eq('name4') }
      it { expect(@json['data'][1]['name']).to eq('name3') }
    end

    context 'with user_id' do
      let!(:user) { create :user }
      let!(:project_1)  { create :pbl_project, name: 'name3', user_id: user.id }
      let!(:project_2)  { create :pbl_project, name: 'name4', user_id: user.id}
      let!(:project_3)  { create :pbl_project, name: 'name3' }

      before(:each) do
        get "/pbl/projects/", {user_id: user.id}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json.size).to eq(2)}
      it { expect(@json['data'][0]['name']).to eq('name4') }
      it { expect(@json['data'][1]['name']).to eq('name3') }
    end

    context 'with name' do
      let!(:user) { create :user }
      let!(:project_1)  { create :pbl_project, name: 'name3', user_id: user.id }
      let!(:project_2)  { create :pbl_project, name: 'nam4', user_id: user.id}
      let!(:project_3)  { create :pbl_project, name: 'name3' }

      before(:each) do
        get "/pbl/projects/", {name: 'name'}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(2)}
      # it { expect(@json['data'][1]['name']).to eq('name3') }
    end

    context 'with subject && phase && technique'  do

      let!(:user) { create :user }

      let!(:category) { create :skill_category, name: '分类'}
      let!(:sub_category) { create :skill_sub_category, name: '分类', category_id: category.id }
      let!(:technique) { create :skill_technique,  sub_category_id: sub_category.id }

      let!(:subject) { create :curriculum_subject, name: '数学' }
      let!(:phase) { create :curriculum_phase, subject_id: subject.id, name: '一年级'}
      let!(:standard) { create :curriculum_standard, phase_id: phase.id}
      let!(:standard_item) { create :curriculum_item, standard_id: standard.id}

      let!(:project)  { create :pbl_project, name: 'name3', user_id: user.id }
      let!(:pbl_standard_item) { create :pbl_standard_item, project_id: project.id, standard_item_id: standard_item.id}
      let!(:pbl_technique) { create :pbl_technique, project_id: project.id, technique_id: technique.id}

      context 'with subject' do
        before(:each) do
          get "/pbl/projects/", {subject: '数学', order: 'asc'}, accept
          @json = parse_json(response.body)
        end

        it { expect(@json['data'].size).to eq(1)}
        it { expect(assigns(:collections).count).to eq(1)}
      end

      context 'with phase' do
        before(:each) do
          get "/pbl/projects/", {phase: '一年级'}, accept
          @json = parse_json(response.body)
        end

        it { expect(@json['data'].size).to eq(1)}
        it { expect(assigns(:collections).count).to eq(1)}
      end

      context 'with technique' do
        before(:each) do
          get "/pbl/projects/", {technique: '分类'}, accept
          @json = parse_json(response.body)
        end

        it { expect(@json['data'].size).to eq(1)}
        it { expect(assigns(:collections).count).to eq(1)}
      end

      context 'with phase and subject' do
        before(:each) do
          get "/pbl/projects/", {phase: '一年级', subject: '数学'}, accept
          @json = parse_json(response.body)
        end

        it { expect(@json['data'].size).to eq(1)}
        it { expect(assigns(:collections).count).to eq(1)}
      end

      context 'with technique and subject' do
        before(:each) do
          get "/pbl/projects/", {technique: '分类', subject: '数学'}, accept
          @json = parse_json(response.body)
        end

        it { expect(@json['data'].size).to eq(1)}
        it { expect(assigns(:collections).count).to eq(1)}
      end
    end

  end

  describe 'GET #show' do
    let(:user) { create :user }
    let(:region) { create :region }
    let!(:project)  { create :pbl_project, name: 'name', grade: '1', user_id: user.id, region_id: region.id , start_at: Time.now}
    before(:each) do
      get "/pbl/projects/#{project.id.to_s}", {}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['id']).to eq(project.id.to_s) }
    it { expect(@json['name']).to eq('name') }
    it { expect(@json['user_id']).to eq(user.id) }
    it { expect(@json['rule_head']).to eq('rule_head') }
    it { expect(@json['rule_template']).to eq('rule_template') }
    it { expect(@json['public']).to  be_falsey}
    it { expect(@json['grade']).to  eq(1)}
    it { expect(@json['region_id']).to  eq(region.id)}
    it { expect(@json['start_at']).to_not be_nil}

    context 'with include techniques' do
      let!(:project)  { create :pbl_project_with_techniques, name: 'name', user_id: user.id, techniques_count: 5}
      before(:each) do
        get "/pbl/projects/#{project.id.to_s}?include=techniques", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(assigns(:include_techniques)).to eq(true)}
      it { expect(@json['techniques'].size).to eq(5) }
      it { expect(@json['techniques'][0]).to be_a Hash }
      it { expect(@json['techniques']).to eq(project.techniques.map{|i| {"id" => i.id, "technique_id" => i.technique_id}}) }

      context 'with include techniques without data' do
        let!(:project)  { create :pbl_project, name: 'name', user_id: user.id}
        before(:each) do
          get "/pbl/projects/#{project.id.to_s}?include=techniques", {}, accept
          @json = parse_json(response.body)
        end

        it { expect(assigns(:include_techniques)).to eq(true)}
        it { expect(@json['techniques'].size).to eq(0) }
        it { expect(@json['techniques']).to match_array([]) }
      end
    end

    context 'with include standard_items' do
      let!(:project)  { create :pbl_project_with_standard_items, name: 'name', user_id: user.id, standard_items_count: 5}
      before(:each) do
        get "/pbl/projects/#{project.id.to_s}?include=standard_items", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(assigns(:include_standard_items)).to eq(true)}
      it { expect(@json['standard_items'].size).to eq(5) }
      it { expect(@json['standard_items']).to  eq(project.standard_items.map{|i| {"id" => i.id, "standard_item_id" => i.standard_item_id}}) }
    end

    context 'with include rules' do
      let!(:project)  { create :pbl_project_with_rules, name: 'name', user_id: user.id, rules_count: 5}
      before(:each) do
        get "/pbl/projects/#{project.id.to_s}?include=rules", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(assigns(:include_rules)).to eq(true)}
      it { expect(@json['rules'].size).to eq(5) }
      it { expect(@json['rules']).to eq(project.rules.map{|i| {"id" => i.id, "gauge_id" => i.gauge_id}}) }
    end

    context 'with include standard_decompositions' do
      let!(:project)  { create :pbl_project_with_standard_decompositions, name: 'name', user_id: user.id, decompositions_count: 5}
      before(:each) do
        get "/pbl/projects/#{project.id.to_s}?include=standard_decompositions", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(assigns(:include_standard_decompositions)).to eq(true)}
      it { expect(@json['standard_decompositions'].size).to eq(5) }
      it { expect(@json['standard_decompositions'][0]['project_id']).to eq(project.id) }
    end

    context 'with include standard_items & techniques' do
      let!(:project)  { create :pbl_project_with_standard_items_and_techniques, name: 'name', user_id: user.id, standard_items_and_techniques_count: 5}
      before(:each) do
        get "/pbl/projects/#{project.id.to_s}?include=standard_items,techniques", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(assigns(:include_techniques)).to eq(true)}
      it { expect(assigns(:include_standard_items)).to eq(true)}
      it { expect(@json['standard_items'].size).to eq(5) }
      it { expect(@json['standard_items']).to  eq(project.standard_items.map{|i| {"id" => i.id, "standard_item_id" => i.standard_item_id}}) }
      it { expect(@json['techniques'].size).to eq(5) }
      it { expect(@json['techniques']).to eq(project.techniques.map{|i| {"id" => i.id, "technique_id" => i.technique_id}}) }
    end

    context 'with include knowledge' do
      let!(:project)  { create :pbl_project_with_knowledge, name: 'name', user_id: user.id, knowledge_count: 5}
      before(:each) do
        get "/pbl/projects/#{project.id.to_s}?include=knowledge", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(assigns(:include_knowledge)).to eq(true)}
      it { expect(@json['knowledge'].size).to eq(5) }
      it { expect(@json['knowledge'][0]['project_id']).to eq(project.id) }
    end

    context 'with include tasks' do
      let!(:project)  { create :pbl_project_with_tasks, name: 'name', user_id: user.id, tasks_count: 5}
      before(:each) do
        get "/pbl/projects/#{project.id.to_s}?include=tasks", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(assigns(:include_tasks)).to eq(true)}
      it { expect(@json['tasks'].size).to eq(5) }
      it { expect(@json['tasks'][0]['project_id']).to eq(project.id) }

      context 'with include tasks and tasks_count with 0' do
        let!(:project)  { create :pbl_project_with_tasks, name: 'name', user_id: user.id, tasks_count: 0}
        before(:each) do
          get "/pbl/projects/#{project.id.to_s}?include=tasks", {}, accept
          @json = parse_json(response.body)
        end
        it { expect(@json['tasks']).to be_a Array }
      end

      context 'with encode url' do
        let!(:project)  { create :pbl_project_with_tasks, name: 'name', user_id: user.id, tasks_count: 5}
        let!(:knowledge) { create :pbl_knowledge, project_id: project.id}
        before(:each) do
          get "/pbl/projects/#{project.id.to_s}?include=tasks%2Cknowledge", {}, accept
          @json = parse_json(response.body)
        end
        it { expect(assigns(:include_tasks)).to eq(true)}
        it { expect(assigns(:include_knowledge)).to eq(true)}
        it { expect(@json['tasks'].size).to eq(5) }
        it { expect(@json['knowledge'].size).to eq(1) }
        it { expect(@json['tasks'][0]['project_id']).to eq(project.id) }

      end
    end


    context 'with include region' do
      let(:region) {create :region }
      let!(:project)  { create :pbl_project, name: 'name', user_id: user.id, region_id: region.id}
      before(:each) do
        get "/pbl/projects/#{project.id.to_s}?include=region", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(assigns(:include_region)).to eq(true)}
      it { expect(@json['region']['region_id']).to eq(region.id) }
      it { expect(@json['region']['region_uri']).to eq("/regions/#{region.id}?include=parents") }
    end

  end

  describe 'POST #create' do
    before(:each) do
      post "/pbl/projects", {project: attributes_for(:pbl_project, name: 'name', tag_list: 'a,b,c', duration_unit: '1')}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['name']).to eq('name') }
    it { expect(@json['tag_list']).to match_array(['a', 'b', 'c']) }
    it { expect(@json['duration_unit']).to eq('1') }

    context 'without params[:project]' do
      before(:each) do
        post "/pbl/projects", {}, accept
      end

      it { expect( response.status ).to eq(201)}
    end

    # describe 'standard_decompositions' do
    #   let(:project) { create :pbl_project }
    #   before(:each) do
    #     post "/pbl/projects", {project: attributes_for(:pbl_project, standard_decompositions_attributes: [attributes_for(:standard_decomposition, role: 'admin', project_id: project.id)])}, accept
    #     @json = parse_json(response.body)
    #   end
    #
    #   it { expect( response.body).to eq('.')}
    #
    #   # it { expect(@json['standard_decompositions'][0]['role']).to eq('admin')}
    # end

    describe 'categories' do
      let!(:technique) { create :skill_technique }
      before(:each) do
        Pbls::Project.delete_all
        post "/pbl/projects", {project: attributes_for(:pbl_project, project_techniques_attributes: [technique_id: technique.id])}, accept
      end

      it { expect(Pbls::ProjectTechnique.count).to be(1)}
      it { expect(Pbls::ProjectTechnique.first.technique_id.to_s).to eq(technique.id.to_s)}
      it { expect(Pbls::ProjectTechnique.first.project_id.to_s).to eq(Pbls::Project.last.id.to_s)}
    end
  end

  describe 'PATCH #update' do
    let!(:project)  { create :pbl_project, name: 'name' }

    before(:each) do
      patch "/pbl/projects/#{project.id.to_s}", {project: {name: 'skill update title'}}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['id']).to eq(project.id.to_s) }

    # describe 'standard_decompositions' do
      # context 'update with new standard decomposition' do
      #   let!(:project) { create :pbl_project_with_standard_decompositions, decompositions_count: 1}
      #   before(:each) do
      #     patch "/pbl/projects/#{project.id.to_s}", {project: attributes_for(:pbl_project, standard_decompositions_attributes: [attributes_for(:standard_decomposition, role: 'admin')])}, accept
      #     @json = parse_json(response.body)
      #   end
      #
      #   it { expect(@json['standard_decompositions'].size).to eq(2) }
      # end
      #
      # context 'update with new standard decomposition' do
      #   let!(:project) { create :pbl_project_with_standard_decompositions, decompositions_count: 1}
      #   before(:each) do
      #     patch "/pbl/projects/#{project.id.to_s}", {project: attributes_for(:pbl_project, standard_decompositions_attributes: [{id: project.standard_decompositions.first.id, _destroy: true}])}, accept
      #     @json = parse_json(response.body)
      #   end
      #
      #   it { expect(@json['standard_decompositions'].size).to eq(0) }
      # end
    # end

    describe 'skill_techniques' do
      # let!(:technique) { create :skill_technique }
      # let!(:project) { create :pbl_project, project_techniques_attributes: [technique_id: technique.id] }
      # before(:each) do
      #   patch "/pbl/projects/#{project.id}", {project: {project_techniques_attributes: [technique_id: technique.id, _destroy: true]}}, accept
      # end
      #
      # it { expect(Pbls::ProjectTechnique.count).to be(0) }
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

  describe 'PATCH #release' do
    let!(:project) { create :pbl_project }
    before(:each) do
      patch "/pbl/projects/#{project.id}/actions/release", {}, accept
      @json = parse_json(response.body)
    end

    it { project.reload; expect(project.state).to eq('release')}

  end
end