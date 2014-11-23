require 'rails_helper'

describe V1::SessionsController, type: :request  do

  describe 'POST #create' do
    let(:accept) { {'Accept' => 'application/vnd.ibridgebrige.com; version=1'} }
    let!(:user) { create :user, email: 'gxbssst@gmail.com', password: 'secret', first_name: 'first_name', last_name: 'last_name'}

    before(:each) do
      post '/sessions', {email: 'gxbsst@gmail.com', password: 'secret'}, accept
       @json = parse_json(response.body)
    end

    it { expect(response).to render_template 'v1/users/show' }

    it { expect(response.status).to eq(200) }
    it { expect(response.body).to have_json_type(Hash) }
    it { expect(@json['first_name']).to eq('first_name') }
    it { expect(@json['last_name']).to eq('last_name') }
  end
end