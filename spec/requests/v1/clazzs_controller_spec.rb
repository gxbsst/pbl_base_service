require 'rails_helper'

RSpec.describe V1::ClazzsController, :type => :request do
  let!(:user) { create :user }
  let!(:master) { create :user }
  let(:grade) { create :grade }
  describe 'GET #index' do
    let!(:clazz) { create :clazz, user_id: user.id, name: 'name' }
    before(:each) do
      get "/clazzs", {}, accept
      @json = parse_json(response.body)
    end

    it { expect(response.body).to have_json_type(Hash)}
    it { expect(@json['data'].size).to eq(1)}

    context 'with ids' do
      let!(:clazz_1) { create :clazz, user_id: user.id, name: 'name' }
      let!(:clazz_2) { create :clazz, user_id: user.id, name: 'name' }

      before(:each) do
        get "/clazzs/#{clazz_1.id},#{clazz_2.id}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json.size).to eq(2)}
    end

    context 'with clazz_id' do
      let!(:clazz_1) { create :clazz, user_id: user.id, name: 'name', grade_id: grade.id }
      let!(:clazz_2) { create :clazz, user_id: user.id, name: 'name' }
      before(:each) do
        get "/clazzs/", {grade_id:  grade.id}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(1) }
      it { expect(@json['data'][0]['id']).to eq(clazz_1.id) }
    end

  end

  describe 'GET #show' do
    context 'with found' do
      let!(:clazz) { create :clazz, user_id: user.id, name: 'name', grade_id: grade.id, master_id: master.id }
      before(:each) do
        get "/clazzs/#{clazz.id}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['id']).to eq(clazz.id.to_s) }
      it { expect(@json['name']).to eq('name') }
      it { expect(@json['grade_id']).to eq(grade.id) }
      it { expect(@json['user_id']).to eq(user.id) }
    end

    context 'with not found' do
      before(:each) do
        get '/clazzs/16720e7f-74d4-4c8f-afda-9657e659b432', {}, accept
      end

      it { expect(response.status).to  eq(404) }
    end
  end

  describe 'POST #create' do
    context 'with successful' do
      before(:each) do
        post '/clazzs', {clazz: attributes_for(:clazz, name: 'name', user_id: user.id, grade_id: grade.id) }, accept
        @json = parse_json(response.body)
      end

      it { expect(response.status).to  eq(201) }
    end
  end

  describe 'DELETE #destroy' do
    let!(:clazz) { create :clazz, user_id: user.id, name: 'name', grade_id: grade.id, master_id: master.id }
    it { expect{  delete "/clazzs/#{clazz.id}", {}, accept }.to change(Clazz, :count).from(1).to(0) }
  end
end
