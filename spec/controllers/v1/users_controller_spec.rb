require 'rails_helper'

describe V1::UsersController, :type => :controller do
  describe 'GET #Index' do
    let!(:user) { create :user }
    subject!(:response) { get :index, format: :json }

    it { expect(response).to render_template :index }
    it { expect(assigns(:users)).to match_array(user)}
  end

end
