require 'rails_helper'

describe V1::UsersController, :type => :controller do
  describe 'GET #Index' do
    let!(:user) { create :user }
    subject!(:response) { get :index, format: :json }

    it { expect(response).to render_template :index }
    it { expect(assigns(:users)).to match_array(User.first)}
  end

  describe 'POST #Create' do
    subject!(:response) { post :create, user: attributes_for(:user) }
    it { expect(User.count).to eq(1) }
  end

  describe 'PATCH #update ' do
    let(:user) { create :user }
    subject!(:response) { patch :update, id: user, user: {first_name: 'hello'} }
    it { expect(User.first.first_name).to eq('hello') }
  end

  describe 'GET #Show' do
    let(:user) { create :user }
    subject!(:response) { get :show, id: user, format: :json }
    it { expect(response).to render_template :show }
    it { expect(assigns(:user)).to eq(User.first) }
  end

  describe 'DELETE #destory' do
    let(:user) { create :user }
    subject!(:response) { delete :destroy, id: user, format: :json }
    it { expect(User.count).to eq(0) }
  end
end
