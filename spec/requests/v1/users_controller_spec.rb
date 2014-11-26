require 'rails_helper'

describe V1::UsersController, type: :request do
  let(:accept) { {'Accept' => 'application/vnd.ibridgebrige.com; version=1'} }
  describe 'GET #Index' do
    let!(:user) { create :user, first_name: 'first_name', last_name: 'last_name', age: 20, gender: 0 }
    before(:each) do
      get '/users', {} , accept
      @json = parse_json(response.body)
    end

    it { expect(response.status).to eq(200)}
    it { expect(response.body).to have_json_type(Array) }
    it {expect(@json[0]['first_name']).to eq('first_name')}
    it {expect(@json[0]['last_name']).to eq('last_name')}
    it {expect(@json[0]['age']).to eq(20)}
    it {expect(@json[0]['gender']).to eq(0)}
  end

  describe 'GET #Show' do
    let!(:user) { create :user, username: 'user.namea@BC*&', email: 'gxbsst@gmail.com', first_name: 'first_name', last_name: 'last_name', age: 20, gender: 0 }

    context 'with id' do
      before(:each) do
        get "/users/#{user.id}", {} , accept
        @json = parse_json(response.body)
      end

      it { expect(response.status).to eq(200)}
      it { expect(response.body).to have_json_type(Hash) }
      it {expect(@json['first_name']).to eq('first_name')}
      it {expect(@json['last_name']).to eq('last_name')}
      it {expect(@json['age']).to eq(20)}
      it {expect(@json['gender']).to eq(0)}
    end

    context 'with email' do
      before(:each) do
        get "/users/#{user.email}", {} , accept
        @json = parse_json(response.body)
      end
      it { expect(response.status).to eq(200)}
      it { expect(response.body).to have_json_type(Hash) }
      it {expect(@json['first_name']).to eq('first_name')}
      it {expect(@json['last_name']).to eq('last_name')}
      it {expect(@json['age']).to eq(20)}
      it {expect(@json['gender']).to eq(0)}
    end

    context 'with username' do
      before(:each) do
        get "/users/#{user.username}", {} , accept
        @json = parse_json(response.body)
      end
      it { expect(response.status).to eq(200)}
      it { expect(response.body).to have_json_type(Hash) }
      it {expect(@json['first_name']).to eq('first_name')}
      it {expect(@json['last_name']).to eq('last_name')}
      it {expect(@json['age']).to eq(20)}
      it {expect(@json['gender']).to eq(0)}
    end
  end

  describe 'DELETE #destory' do
    let!(:user) { create :user, first_name: 'first_name', last_name: 'last_name', age: 20, gender: 0 }
    before(:each) do
      delete "/users/#{user.id}", {} , accept
      @json = parse_json(response.body)
    end

    it {expect(@json['id']).to eq(user.id.to_s)}
  end

  describe 'POST #create' do
    before(:each) do
      post "/users", {user: attributes_for(:user) } , accept
      @json = parse_json(response.body)
    end

    it {expect(@json['id']).to_not be_nil}
  end
end
