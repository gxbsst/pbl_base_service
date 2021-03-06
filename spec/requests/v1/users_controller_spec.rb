require 'rails_helper'

describe V1::UsersController, type: :request do
  describe 'GET #Index' do
    let!(:user) { create :user, first_name: 'first_name', last_name: 'last_name', age: 20, gender: 0 }
    before(:each) do
      get '/users', {} , accept
      @json = parse_json(response.body)
    end

    it { expect(response.status).to eq(200)}
    it { expect(response.body).to have_json_type(Hash) }
    it {expect(@json['data'][0]['first_name']).to eq('first_name')}
    it {expect(@json['data'][0]['last_name']).to eq('last_name')}
    it {expect(@json['data'][0]['age']).to eq(20)}
    it {expect(@json['data'][0]['gender']).to eq(0)}

    context 'with role_name, role_resource_type, role_resource_id' do
      let(:user) { create :user }
    end


    context 'with ids' do
      let!(:user_3)  { create :user, username: 'name3' }
      let!(:user_4)  { create :user, username: 'name4' }
      before(:each) do
        get "/users/#{user_3.id.to_s},#{user_4.id.to_s}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json.size).to eq(2)}
      it { expect(@json['data'].size).to eq(2)}
      it { expect(@json['data'][0]['username']).to eq('name4') }
      it { expect(@json['data'][1]['username']).to eq('name3') }
    end

    context 'with username' do
      let!(:user_3)  { create :user, username: 'abcccc' }
      let!(:user_4)  { create :user, username: 'name4' }
      before(:each) do
        get "/users/", {username: 'abcccc'}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(1)}
    end
  end

  describe 'GET #Show' do
    let(:school) { create :school }
    let(:clazz) { create :clazz }

    let!(:user) { create :user, bio: 'bio', username: 'user.namea@BC*&', email: 'gxbsst@gmail.com', first_name: 'first_name', last_name: 'last_name', age: 20, gender: 0, avatar: 'avatar', school_id: school.id, grade_id: [123], clazz_id: [clazz.id], title: 'title' }

    context 'with id' do

      before(:each) do
        get "/users/#{user.id}", {} , accept
        @json = parse_json(response.body)
      end

      it { expect(response.status).to eq(200)}
      it { expect(response.body).to have_json_type(Hash) }
      it {expect(@json['id']).to eq(user.id)}
      it {expect(@json['first_name']).to eq('first_name')}
      it {expect(@json['last_name']).to eq('last_name')}
      it {expect(@json['age']).to eq(20)}
      it {expect(@json['avatar']).to eq('avatar')}
      it {expect(@json['gender']).to eq(0)}
      it {expect(@json['type']).to eq('Teacher')}
      it {expect(@json['interests']).to eq([])}
      it {expect(@json['disciplines']).to eq([])}
      it {expect(@json['nickname']).to eq('nickname')}
      it {expect(@json['realname']).to eq('realname')}
      it {expect(@json['school_id']).to eq(school.id)}
      it {expect(@json['grade_id']).to eq(['123'])}
      it {expect(@json['clazz_id']).to eq([clazz.id])}
      it {expect(@json['title']).to eq('title')}
      it {expect(@json['bio']).to eq('bio')}
    end

    context 'with email' do
      context ' with collect email' do
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

      context 'with error email' do
        before(:each) do
          get "/users/#{user.email}1111", {} , accept
          @json = parse_json(response.body)
        end
        it { expect(response.status).to_not eq(200)}
        it { expect(response.body).to have_json_type(Hash) }
        it {expect(@json['first_name']).to_not eq('first_name')}
        it {expect(@json['last_name']).to_not eq('last_name')}
        it {expect(@json['age']).to_not eq(20)}
        it {expect(@json['gender']).to_not eq(0)}
      end

      context 'with include friends' do
        let(:friend) { create :user }
        let!(:friend_ship) { create :friend_ship, user_id: user.id, friend_id: friend.id }
        before(:each) do
          get "/users/#{user.id}", {include: 'friends'} , accept
          @json = parse_json(response.body)
        end
        it { expect(FriendShip.count).to eq(1)}
        it { expect(user.friends.count).to eq(1)}
        it {expect(@json['friends'][0]['id']).to eq(friend.id)}
        it {expect(@json['friends'][0]['username']).to eq(friend.username)}
      end

      context 'with include school' do
        let(:school) { create :school }
        let(:user) { create :user, school_id: school.id}
        before(:each) do
          get "/users/#{user.id}", {include: 'school'} , accept
          @json = parse_json(response.body)
        end
        it { expect(user.school.id).to eq(school.id)}
        it {expect(@json['school']['id']).to eq(school.id)}
      end
    end

    context 'with username' do
      context 'with collect username' do
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


      context 'with error username' do
        before(:each) do
          get "/users/#{user.username}1", {} , accept
          @json = parse_json(response.body)
        end
        it { expect(response.status).to eq(404)}
        it { expect(response.body).to have_json_type(Hash) }
        it {expect(@json['first_name']).to_not eq('first_name')}
        it {expect(@json['last_name']).to_not eq('last_name')}
        it {expect(@json['age']).to_not eq(20)}
        it {expect(@json['gender']).to_not eq(0)}
      end
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

  describe 'errors' do
    let(:user) { User.new }
    before(:each) do
      allow(User).to receive(:new).and_return(user)
      post "/users", {user: attributes_for(:user) } , accept
    end

    it { expect(user.errors[:email]).to eq(['blank', 'email_format'])}

  end
end
