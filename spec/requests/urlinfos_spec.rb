require 'rails_helper'

RSpec.describe 'Urlinfos API', type: :request do
  # initialize test data
  let!(:urlinfos) { create_list(:urlinfo, 10) }
  let(:urlinfo_id) { urlinfos.first.id }
  let(:urlinfo_url) { urlinfos.first.url }
  let(:urlinfo_domain_name) { urlinfos.first.domain_name }
  let(:urlinfo_query_string) { urlinfos.first.query_string }
  let(:urlinfo_created_by) { urlinfos.first.created_by }

  # Test suite for GET /urlinfos
  describe 'GET /urlinfos' do
    # make HTTP get request before each example
    before { get '/urlinfos' }

    it 'returns urlinfos' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /urlinfos/:id' do
    before { get "/urlinfos/#{urlinfo_id}" }

    context 'when the record exists' do
      it 'returns the urlinfo' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(urlinfo_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:urlinfo_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Url/)
      end
    end
  end

  describe 'GET /urlinfo/:created_by/:domain_name/:query_string' do
    before { get "/urlinfo/#{urlinfo_created_by}/#{urlinfo_domain_name}/#{urlinfo_query_string}" }

    context 'when the record exists' do
      it 'returns the urlinfo' do
        expect(json).not_to be_empty
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'POST /urlinfo/:created_by/:domain_name/:query_string' do
    let(:valid_attributes) { { url: 'www.google.com/?q=abc', malware: true, created_by: '1', domain_name: 'www.google.com', query_string: 'q=abc' } }

    context 'when the request is valid' do
      before { post '/urlinfo/1/www.google.com/q=abc', params: valid_attributes }

      it 'creates a urlinfo' do
        expect(json['url']).to eq('www.google.com/?q=abc')
        expect(json['malware']).to eq(true)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid - missing domain_name' do
      before { post '/urlinfos', params: { url: 'www.yahoo.com', malware: true, created_by: '1' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Domain name can't be blank/)
      end
    end

    context 'when the request is invalid - missing created_by' do
      before { post '/urlinfos', params: { url: 'www.yahoo.com', malware: true } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Created by can't be blank/)
      end
    end

    context 'when the request is invalid - missing malware' do
      before { post '/urlinfos', params: { url: 'www.yahoo.com' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Malware can't be blank/)
      end
    end
  end

  describe 'DELETE /urlinfo/:created_by/:domain_name/:query_string' do
    before { delete '/urlinfo/1/www.google.com/q=abc' }

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
end
