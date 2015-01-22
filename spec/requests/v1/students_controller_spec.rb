require 'rails_helper'

RSpec.describe V1::StudentsController, :type => :request do
  let!(:user) { create :user }
  let(:clazz) { create :clazz }
  describe 'GET #index' do
    let!(:student) { create :student, user_id: user.id, clazz_id: clazz.id }
    before(:each) do
      get "/students", {}, accept
      @json = parse_json(response.body)
    end

    it { expect(response.body).to have_json_type(Hash)}
    it { expect(@json['data'].size).to eq(1)}

    context 'with ids' do
      let!(:student_1) { create :student, user_id: user.id, clazz_id: clazz.id }
      let!(:student_2) { create :student, user_id: user.id, clazz_id: clazz.id }
      let!(:student_3) { create :student, user_id: user.id, clazz_id: clazz.id }

      before(:each) do
        get "/students/#{student_1.id},#{student_2.id}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json.size).to eq(2)}
    end

    context 'with clazz_id' do
      let(:clazz_1) { create :clazz }
      let!(:student_1) { create :student, user_id: user.id, clazz_id: clazz_1.id }
      let!(:student_2) { create :student, user_id: user.id }
      before(:each) do
        get "/students/", {clazz_id: clazz_1.id}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(1) }
      it { expect(@json['data'][0]['id']).to eq(student_1.id) }
    end

    context 'with user_id' do
      let(:clazz_1) { create :clazz }
      let(:user_1) { create :user}
      let!(:student_1) { create :student, user_id: user_1.id, clazz_id: clazz_1.id }
      let!(:student_2) { create :student, user_id: user.id }
      before(:each) do
        get "/students/", {user_id: user_1.id}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(1) }
    end

  end

  describe 'GET #show' do
    context 'with found' do
      let!(:student) { create :student, user_id: user.id, clazz_id: clazz.id }
      before(:each) do
        get "/students/#{student.id}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['id']).to eq(student.id.to_s) }
      it { expect(@json['clazz_id']).to eq(clazz.id) }
      it { expect(@json['user_id']).to eq(user.id) }
      it { expect(@json['role']).to eq([]) }
      it { expect(@json['user']['avatar']).to eq('avatar') }
    end

    context 'with not found' do
      before(:each) do
        get '/students/16720e7f-74d4-4c8f-afda-9657e659b432', {}, accept
      end

      it { expect(response.status).to  eq(404) }
    end
  end

  describe 'POST #create' do
    context 'with successful' do
      before(:each) do
        post '/students', {student: attributes_for(:student, user_id: user.id, clazz_id: clazz.id) }, accept
        @json = parse_json(response.body)
      end

      it { expect(response.status).to  eq(201) }
    end
  end

  describe 'DELETE #destroy' do
    let!(:student) { create :student, user_id: user.id, clazz_id: clazz.id }
    it { expect{  delete "/students/#{student.id}", {}, accept }.to change(Student, :count).from(1).to(0) }
  end
end
