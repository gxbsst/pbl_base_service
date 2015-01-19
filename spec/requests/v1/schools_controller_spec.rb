require 'rails_helper'

RSpec.describe V1::SchoolsController, :type => :request do
  let!(:user) { create :user }
  let!(:master) { create :user }
  let(:region) { create :region }
  describe 'GET #index' do
    let!(:school) { create :school, user_id: user.id, name: 'name' }
    before(:each) do
      get "/schools", {}, accept
      @json = parse_json(response.body)
    end

    it { expect(response.body).to have_json_type(Hash)}
    it { expect(@json['data'].size).to eq(1)}

    context 'with ids' do
      let!(:school_1) { create :school, user_id: user.id, name: 'name' }
      let!(:school_2) { create :school, user_id: user.id, name: 'name' }

      before(:each) do
        get "/schools/#{school_1.id},#{school_2.id}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json.size).to eq(2)}
    end

    context 'with region_id' do
      let!(:school_1) { create :school, user_id: user.id, name: 'name', region_id: region.id }
      let!(:school_2) { create :school, user_id: user.id, name: 'name' }
      before(:each) do
        get "/schools/", {region_id:  region.id}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(1) }
      it { expect(@json['data'][0]['id']).to eq(school_1.id) }
    end

    context 'with country_id' do
      let!(:school_1) { create :school, user_id: user.id, name: 'name', region_id: region.id, country_id: region.id, province_id: region.id, city_id: region.id, district_id: region.id }
      let!(:school_2) { create :school, user_id: user.id, name: 'name' }
      before(:each) do
        get "/schools/", {region_id: region.id, country_id:  region.id, city_id: region.id, province_id: region.id, district_id: region.id}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['data'].size).to eq(1) }
      it { expect(@json['data'][0]['id']).to eq(school_1.id) }
    end

  end

  describe 'GET #show' do
    context 'with found' do
      let!(:school) { create :school, user_id: user.id, name: 'name', region_id: region.id, master_id: master.id }
      before(:each) do
        get "/schools/#{school.id}", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['id']).to eq(school.id.to_s) }
      it { expect(@json['name']).to eq('name') }
      it { expect(@json['region_id']).to eq(region.id) }
      it { expect(@json['user_id']).to eq(user.id) }
    end

    context 'with not found' do
      before(:each) do
        get '/schools/16720e7f-74d4-4c8f-afda-9657e659b432', {}, accept
      end

      it { expect(response.status).to  eq(404) }
    end
  end

  describe 'POST #create' do
    context 'with successful' do
      before(:each) do
        post '/schools', {school: attributes_for(:school, name: 'name', user_id: user.id, region_id: region.id) }, accept
        @json = parse_json(response.body)
      end

      it { expect(response.status).to  eq(201) }
    end
  end

  describe 'DELETE #destroy' do
    let!(:school) { create :school, user_id: user.id, name: 'name', region_id: region.id, master_id: master.id }
    it { expect{  delete "/schools/#{school.id}", {}, accept }.to change(School, :count).from(1).to(0) }
  end
end
