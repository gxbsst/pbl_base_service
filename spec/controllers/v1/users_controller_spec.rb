require 'rails_helper'

describe V1::UsersController, :type => :controller do

  describe 'GET #Index' do
    let!(:user) { create :user }
    subject!(:response) { get :index, format: :json }

    it { expect(response).to render_template :index }
    it { expect(assigns(:collections)).to match_array(User.first)}
  end

  describe 'POST #Create' do
    subject!(:response) { post :create, user: attributes_for(:user), format: :json }
    it { expect(User.count).to eq(1) }
  end

  describe 'PATCH #update ' do
    let(:user) { create :user }
    subject!(:response) { patch :update, id: user, user: attributes_for(:user, first_name: 'hello'), format: :json }
    it { expect(User.first.first_name).to eq('hello') }
  end

  describe 'GET #Show' do
    context 'with id' do
      let!(:user) { create :user, username: 'username', email: 'gxbsst@gmail.com'}
      subject!(:response) { get :show, id: user, format: :json }

      it { expect(User.count).to eq(1)}
      it { expect(response).to render_template :show }
      it { expect(user).to eq(User.last) }
    end

    context 'with username' do
      let!(:user) { create :user, username: 'username', email: 'gxbsst@gmail.com'}
      before(:each) do
        get :show, id: 'username', format: :json
      end

      it { expect(User.count).to eq(1)}
      it { expect(response).to render_template :show }
      it { expect(user.reload).to eq(User.last) }
    end

    context 'with email' do
      let!(:user) { create :user, username: 'username', email: 'gxbsst@gmail.com'}

      before(:each) do
        get :show, id: 'gxbsst@gmail.com', format: :json
      end

      it { expect(User.count).to eq(1)}
      it { expect(response).to render_template :show }
      it { expect(user.reload).to eq(User.first) }
    end
  end

  describe 'DELETE #destory' do
    let!(:user) { create :user }
    before(:each) do
      delete :destroy, id: user, format: :json
    end
    it { expect(User.count).to eq(0) }
    # subject!(:response) { delete :destroy, id: user, format: :json }
    # it { user.reload; expect{ delete :destroy, id: user, format: :json}.to change(User, :count).from(1).to(0) }
  end
end
