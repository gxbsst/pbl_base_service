require 'rails_helper'

describe V1::Curriculum::StandardItemsController do
  let(:standard) { create :curriculum_standard }

  describe 'GET #index' do
    let!(:clazz_instance_1)  { create :curriculum_item,  standard_id: standard.id }
    let!(:clazz_instance_2)  { create :curriculum_item,  standard_id: standard.id }

    before(:each) do
      get '/curriculum/standard_items', {standard_id: standard.id}, accept
      @json = parse_json(response.body)
    end

    it { expect(response.body).to have_json_type(Hash) }

    context 'with page' do
      context 'page 1' do
        before(:each) do
          get '/curriculum/standard_items?page=1&limit=1', {standard_id: standard.id}, accept
          @json = parse_json(response.body)
        end

        it { expect(@json['meta']['total_pages']).to eq(2)}
        it { expect(@json['meta']['current_page']).to eq(1)}
        it { expect(@json['meta']['per_page']).to eq('1')}

      end
    end

    context 'with ids' do
      before(:each) do
        get "/curriculum/standard_items/#{clazz_instance_1.id.to_s},#{clazz_instance_2.id.to_s}", {standard_id: standard.id}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(2)}

      context 'with include parents' do
        before(:each) do
          get "/curriculum/standard_items/#{clazz_instance_1.id.to_s},#{clazz_instance_2.id.to_s}", {include: 'parents'}, accept
          @json = parse_json(response.body)
        end

        it { expect(@json['data'][1]['parents']).to be_a Hash  }
        it { expect(@json['data'][1]['parents']['standard']['id']).to  eq(clazz_instance_1.standard.id)}
        it { expect(@json['data'][1]['parents']['phase']['id']).to  eq(clazz_instance_1.standard.phase.id)}
        it { expect(@json['data'][1]['parents']['subject']['id']).to  eq(clazz_instance_1.standard.phase.subject.id)}
        it { expect(@json['data'][0]['parents']['standard']['id']).to  eq(clazz_instance_2.standard.id)}
        it { expect(@json['data'][0]['parents']['phase']['id']).to  eq(clazz_instance_2.standard.phase.id)}
        it { expect(@json['data'][0]['parents']['subject']['id']).to  eq(clazz_instance_2.standard.phase.subject.id)}
      end
    end
  end

  describe 'GET #show' do
    context 'with found' do
      let!(:clazz_instance) { create :curriculum_item,  standard_id: standard.id, is_category: true }
      before(:each) do
        get "/curriculum/standard_items/#{clazz_instance.id}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['id']).to eq(clazz_instance.id.to_s) }
      it { expect(@json['standard_id']).to eq(standard.id) }
      it { expect(@json['is_category']).to eq(true) }
    end

    context 'with not found' do
      let!(:clazz_instance) { create :curriculum_item,  standard_id: standard.id }
      before(:each) do
        get '/curriculum/standard_items/16720e7f-74d4-4c8f-afda-9657e659b432', {}, accept
      end

      it { expect(response.status).to  eq(404) }
    end

    context 'with include parents' do
      let!(:clazz_instance) { create :curriculum_item,  standard_id: standard.id, is_category: true }
      before(:each) do
        get "/curriculum/standard_items/#{clazz_instance.id}", {include: 'parents'}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['parents']['standard']['id']).to  eq(standard.id)}
      it { expect(@json['parents']['phase']['id']).to  eq(standard.phase.id)}
      it { expect(@json['parents']['subject']['id']).to  eq(standard.phase.subject.id)}
    end
  end

  describe 'POST #create' do
    context 'with successful' do
      before(:each) do
        post '/curriculum/standard_items', { standard_item: attributes_for(:curriculum_item, standard_id: standard.id) }, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['standard_id']).to eq(standard.id) }
    end

    context 'with failed' do
      it { expect {post '/curriculum/standard_items', { standard_item: attributes_for(:curriculum_item) }, accept }.to_not raise_error() }
    end
  end

  describe 'DELETE #destroy' do
    let!(:clazz_instance) { create :curriculum_item, standard_id: standard.id }
    it { expect{  delete "curriculum/standard_items/#{clazz_instance.id}", {}, accept }.to change(Curriculums::StandardItem, :count).from(1).to(0) }
  end
end