require 'rails_helper'

describe V1::SessionsController, type: :request  do

  describe 'POST #create' do
    let!(:user) { create :user, email: 'gxbsst@gmail.com', password: 'secret', first_name: 'first_name', last_name: 'last_name'}

    context 'success' do
      before(:each) do
        post '/sessions', {login: 'gxbsst@gmail.com', password: 'secret'}, accept
        @json = parse_json(response.body)
      end

      it { expect(User.count).to eq(1)}
      it { expect(User.first.email).to eq('gxbsst@gmail.com')}
      it { expect(response).to render_template 'v1/users/show' }
      it { expect(response.status).to eq(200) }
      it { expect(response.body).to have_json_type(Hash) }
      it { expect(@json['first_name']).to eq('first_name') }
      it { expect(@json['last_name']).to eq('last_name') }
    end

    context 'failed' do
      context 'with error password' do
        before(:each) do
          post '/sessions', {login: 'gxbsst@gmail.com', password: 'error'}, accept
          @json = parse_json(response.body)
        end

        it { expect(@json['error']).to eq('Not Found')}
        it { expect(response.status).to eq(404) }
      end

      context 'with error email' do
        before(:each) do
          post '/sessions', {login: 'error@gmail.com', password: 'error'}, accept
          @json = parse_json(response.body)
        end

        it { expect(@json['error']).to eq('Not Found')}
        it { expect(response.status).to eq(404) }
      end
    end
  end

end

