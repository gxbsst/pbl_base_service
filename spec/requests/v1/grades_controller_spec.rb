require 'rails_helper'

RSpec.describe V1::GradesController, :type => :request do
  let!(:user) { create :user }
  let!(:master) { create :user }
  let(:school) { create :school }
  describe 'GET #index' do
    let!(:grade) { create :grade, user_id: user.id, name: 'name' }
    before(:each) do
      get "/grades", {}, accept
      @json = parse_json(response.body)
    end

    it { expect(response.body).to have_json_type(Hash)}
    it { expect(@json['data'].size).to eq(1)}

    context 'with ids' do
      let!(:grade_1) { create :grade, user_id: user.id, name: 'name' }
      let!(:grade_2) { create :grade, user_id: user.id, name: 'name' }

      before(:each) do
        get "/grades/#{grade_1.id},#{grade_2.id}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json.size).to eq(2)}
    end

    context 'with school_id' do
      let!(:grade_1) { create :grade, user_id: user.id, name: 'name', school_id: school.id }
      let!(:grade_2) { create :grade, user_id: user.id, name: 'name' }
      before(:each) do
        get "/grades/", {school_id:  school.id}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(1) }
      it { expect(@json['data'][0]['id']).to eq(grade_1.id) }
    end

  end

  describe 'GET #show' do
    context 'with found' do
      let!(:grade) { create :grade, user_id: user.id, name: 'name', school_id: school.id, master_id: master.id }
      before(:each) do
        get "/grades/#{grade.id}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['id']).to eq(grade.id.to_s) }
      it { expect(@json['name']).to eq('name') }
      it { expect(@json['school_id']).to eq(school.id) }
      it { expect(@json['user_id']).to eq(user.id) }
    end

    context 'with not found' do
      before(:each) do
        get '/grades/16720e7f-74d4-4c8f-afda-9657e659b432', {}, accept
      end

      it { expect(response.status).to  eq(404) }
    end
  end

  describe 'POST #create' do
    context 'with successful' do
      before(:each) do
        post '/grades', {grade: attributes_for(:grade, name: 'name', user_id: user.id, school_id: school.id) }, accept
        @json = parse_json(response.body)
      end

      it { expect(response.status).to  eq(201) }
    end
  end

  describe 'DELETE #destroy' do
    let!(:grade) { create :grade, user_id: user.id, name: 'name', school_id: school.id, master_id: master.id }
    it { expect{  delete "/grades/#{grade.id}", {}, accept }.to change(Grade, :count).from(1).to(0) }
  end
end
