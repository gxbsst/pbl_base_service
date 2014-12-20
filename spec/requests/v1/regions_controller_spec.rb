require 'rails_helper'
require 'region'

describe V1::RegionsController do
  describe 'GET #index' do
    let!(:country){ Country.create!(:name => 'country') }
    let!(:province){ Province.create!(:name => 'province', parent_id: country.id) }
    let!(:city){ City.create!(:name => 'city', parent_id: province.id) }
    let!(:district){ District.create!(:name => 'district', parent_id: city.id) }
    before(:each) do
      get '/regions', {}, accept
      @json = parse_json(response.body)
    end

    it { expect(response).to render_template :index }
    it {expect(assigns[:collections].count).to eq(4)}
    it { expect(@json['data'].size).to eq(4) }
    it { expect(@json['data'][0]['name']).to eq('district') }
    it { expect(@json['data'][0]['type']).to eq('District') }
    it { expect(@json['data'][0]['id']).to eq(district.id) }

    context 'with city id as parent_id' do
      before(:each) do
        get '/regions', {parent_id: city.id }, accept
        @json = parse_json(response.body)
      end
      it { expect(@json['data'].size).to eq(1) }
      it { expect(@json['data'][0]['name']).to eq('district') }
      it { expect(@json['data'][0]['type']).to eq('District') }
      it { expect(@json['data'][0]['id']).to eq(district.id) }
    end

    context 'with province id as parent_id' do
      before(:each) do
        get '/regions', {parent_id: province.id }, accept
        @json = parse_json(response.body)
      end
      it { expect(@json['data'].size).to eq(1) }
      it { expect(@json['data'][0]['name']).to eq('city') }
      it { expect(@json['data'][0]['type']).to eq('City') }
      it { expect(@json['data'][0]['id']).to eq(city.id) }
    end

    context 'with type country' do
      before(:each) do
        get '/regions', {type: 'country' }, accept
        @json = parse_json(response.body)
      end
      it { expect(@json['data'].size).to eq(1) }
      it { expect(@json['data'][0]['name']).to eq('country') }
      it { expect(@json['data'][0]['type']).to eq('Country') }
      it { expect(@json['data'][0]['id']).to eq(country.id) }
    end

    context 'with type province' do
      before(:each) do
        get '/regions', {type: 'province' }, accept
        @json = parse_json(response.body)
      end
      it { expect(@json['data'].size).to eq(1) }
      it { expect(@json['data'][0]['name']).to eq('province') }
      it { expect(@json['data'][0]['type']).to eq('Province') }
      it { expect(@json['data'][0]['id']).to eq(province.id) }
    end
  end

  describe 'GET #show' do
    let!(:country){ Country.create!(:name => 'country') }
    let!(:province){ Province.create!(:name => 'province', parent_id: country.id) }
    let!(:city){ City.create!(:name => 'city', parent_id: province.id) }
    let!(:city_2){ City.create!(:name => 'city', parent_id: province.id) }
    let!(:district){ District.create!(:name => 'district', parent_id: city.id) }

    before(:each) do
      get "/regions/#{district.id}", {}, accept
      @json = parse_json(response.body)
    end

    it { expect(@json['name']).to eq('district') }
    it { expect(@json['type']).to eq('District') }
    it { expect(@json['id']).to eq(district.id) }

    context 'with include parents and children' do
      before(:each) do
        get "/regions/#{province.id}?include=parents,children", {}, accept
        @json = parse_json(response.body)
      end

      it { expect(@json['parents'].size).to eq(1) }
      it { expect(@json['children'].size).to eq(2) }
      it { expect(@json['children'][0]['type']).to eq('City') }
    end
  end
end