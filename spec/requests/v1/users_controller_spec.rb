require 'rails_helper'

describe V1::UsersController, type: :request do
  describe 'GET #Index' do
    let(:accept) { {'Accept' => 'application/vnd.ibridgebrige.com; version=1'} }
    let!(:user) { create :user, first_name: 'first_name' }
    before(:each) do
      get '/users', {} , accept
      @json = parse_json(response.body)
    end

    it { expect(response.status).to eq(200)}
    it { expect(response.body).to have_json_type(Array) }
    it {expect(@json[0]).to eq('..')}
  end
end
