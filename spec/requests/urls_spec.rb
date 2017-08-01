require 'rails_helper'

RSpec.describe 'Urls API', type: :request do
  # initialize test data
  let!(:urls) { create_list(:url, 10) }
  let(:url_id) { urls.first.id }

  # Test suite for GET /urls
  describe 'GET /urls' do
    # make HTTP get request before each example
    before { get '/urls' }

    it 'returns urls' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /urls/:id' do
    before { get "/urls/#{url_id}" }

    context 'when the record exists' do
      it 'returns the url' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(url_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:url_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match (/Couldn't find Url/)
      end
    end
  end

  describe 'POST /urls' do
    let(:valid_attributes) { { url: 'www.google.com', created_by: '1' } }

    context 'when the request is valid' do
      before { post '/urls', params: valid_attributes }

      it 'creates a url' do
        expect(json['url']).to eq('www.google.com')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/urls', params: { url: 'www.yahoo.com' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Created by can't be blank/)
      end
    end
  end

  describe 'DELETE /urls/:id' do
    before { delete "/urls/#{url_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
