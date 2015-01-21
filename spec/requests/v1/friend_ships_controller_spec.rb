require 'rails_helper'

RSpec.describe V1::FriendShipsController, :type => :request do
  let!(:user) { create :user, email: 'www@dd.com', username: 'user...' }
  let!(:parent) { create :user, email: 'ww2w@dd.com', username: 'user....' }
  describe 'GET #index' do
    let!(:friend_ship) { create :friend_ship, friend_id: parent.id, user_id: user.id, relation: '000' }
    before(:each) do
      get "/friend_ships", {}, accept
      @json = parse_json(response.body)
    end

    it { expect(response.body).to have_json_type(Hash)}
    it { expect(@json['data'].size).to eq(1)}

    context 'with ids' do
      let!(:parent111) { create :user, email: 'ww2w@ddddd.com', username: 'user....l.' }
      let!(:parent112) { create :user, email: 'ww22w@ddddd.com', username: 'us2er....l.' }
      let!(:friend_ship1) { create :friend_ship, friend_id: parent111.id, user_id: user.id, relation: '000' }
      let!(:friend_ship2) { create :friend_ship, friend_id: parent112.id, user_id: user.id, relation: '000' }

      before(:each) do
        get "/friend_ships/#{friend_ship1.id},#{friend_ship2.id}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(2)}
    end

    context 'with  friend_id OR user_id' do
      let!(:user_1) { create :user, email: 'www1@dd.com', username: 'user.2222..' }
      let!(:parent_1) { create :user, email: 'ww2w1@dd.com', username: 'user.222...' }
      let!(:friend_ship1) { create :friend_ship, friend_id: parent_1.id, user_id: user_1.id, relation: '000' }
      before(:each) do
        get "/friend_ships/", {friend_id: parent_1.id, user_id: user_1.id}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(1) }
      it { expect(@json['data'][0]['id']).to eq(friend_ship1.id) }
    end

  end

  describe 'GET #show' do
    context 'with found' do
      let!(:friend_ship) { create :friend_ship, friend_id: parent.id, user_id: user.id, relation: '000' }
      before(:each) do
        get "/friend_ships/#{friend_ship.id}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['id']).to eq(friend_ship.id) }
      it { expect(@json['user_id']).to eq(user.id) }
      it { expect(@json['friend_id']).to eq(parent.id) }
      it { expect(@json['relation']).to  eq('000')}
    end

    context 'with not found' do
      before(:each) do
        get '/friend_ships/16720e7f-74d4-4c8f-afda-9657e659b432', {}, accept
      end

      it { expect(response.status).to  eq(404) }
    end
  end

  describe 'POST #create' do
    let!(:user) { create :user, email: 'www@dd.com', username: 'user...' }
    let!(:parent) { create :user, email: 'ww2w@dd.com', username: 'user....' }

    context 'with hash' do
      before(:each) do
        post '/friend_ships', {friend_ship: attributes_for(:friend_ship, user_id: user.id, friend_id: parent.id, relation: '0000') }, accept
        @json = parse_json(response.body)
        @friends = FriendShip.all.order(created_at: :desc)
      end

      it { expect(response.status).to  eq(201) }
      it { expect(@json['user_id']).to  eq(user.id)}
      it { expect(FriendShip.count).to eq(2)}
      it { expect(@friends[0].user_id).to eq(parent.id)}
      it { expect(@friends[1].user_id).to eq(user.id)}
    end

  end

  describe 'DELETE #destroy' do
    let!(:friend_ship) { create :friend_ship, friend_id: parent.id, user_id: user.id, relation: '000' }
    it { expect{  delete "/friend_ships/#{friend_ship.id}", {}, accept }.to change(FriendShip, :count).from(1).to(0) }
  end
end
