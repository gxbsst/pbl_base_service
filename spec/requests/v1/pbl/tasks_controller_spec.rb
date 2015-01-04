require 'rails_helper'

describe V1::Pbl::TasksController do
  let(:project) { create :pbl_project }

  describe 'GET #index' do
    let!(:clazz_instance_1)  { create :pbl_task,  project_id: project.id }
    let!(:clazz_instance_2)  { create :pbl_task,  project_id: project.id }

    before(:each) do
      get '/pbl/tasks', {project_id: project.id}, accept
      @json = parse_json(response.body)
    end

    it { expect(response.body).to have_json_type(Hash) }

    context 'with page' do
      context 'page 1' do
        before(:each) do
          get '/pbl/tasks?page=1&limit=1', {project_id: project.id}, accept
          @json = parse_json(response.body)
        end

        it { expect(@json['meta']['total_pages']).to eq(2)}
        it { expect(@json['meta']['current_page']).to eq(1)}
        it { expect(@json['meta']['per_page']).to eq('1')}

      end
    end
  end

  describe 'GET #show' do
    context 'with found' do
      let!(:clazz_instance) { create :pbl_task, project_id: project.id, start_at: Time.now, submit_way: 'user' }
      before(:each) do
        get "/pbl/tasks/#{clazz_instance.id}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['id']).to eq(clazz_instance.id.to_s) }
      it { expect(@json['project_id']).to eq(project.id) }
      it { expect(@json['start_at']).to_not  be_nil}
      it { expect(@json['submit_way']).to eq('user')}
      it { expect(@json['final']).to be(false)}
    end

    context 'with not found' do
      let!(:clazz_instance) { create :pbl_task, project_id: project.id }
      before(:each) do
        get '/pbl/rules/16720e7f-74d4-4c8f-afda-9657e659b432', {}, accept
      end

      it { expect(response.status).to  eq(404) }
    end
  end

  describe 'POST #create' do
    context 'with successful' do
      before(:each) do
        post '/pbl/tasks', { task: attributes_for(:pbl_task, project_id: project.id) }, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['project_id']).to eq(project.id) }
    end

    context 'with failed' do
      it { expect {post '/pbl/tasks', { task: attributes_for(:pbl_task) }, accept }.to_not raise_error() }
    end
  end

  describe 'DELETE #destroy' do
    let!(:clazz_instance) { create :pbl_task, project_id: project.id }
    it { expect{  delete "pbl/tasks/#{clazz_instance.id}", {}, accept }.to change(Pbls::Task, :count).from(1).to(0) }
  end
end