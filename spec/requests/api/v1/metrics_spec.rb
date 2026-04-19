require 'rails_helper'

RSpec.describe 'Api::V1::Metrics', type: :request do
  describe 'GET /keyword_density' do
    let(:app_id) { 'com.test.app' }
    let(:start_date) { '2025-01-01' }
    let(:end_date) { '2025-01-31' }
    let(:term) { 'bug' }

    let(:valid_params) do
      {
        app_id: app_id,
        start_date: start_date,
        end_date: end_date,
        term: term
      }
    end

    context 'with valid parameters' do
      before do
        allow(KeywordDensityCalculationService).to receive(:call)
          .and_return({ total_reviews: 100, matching_reviews: 5, density_percentage: 5.0 })
      end

      it 'returns http success' do
        get '/api/v1/metrics/keyword_density', params: valid_params
        expect(response).to have_http_status(:success)
      end

      it 'returns the calculated values correctly' do
        get '/api/v1/metrics/keyword_density', params: valid_params
        json_response = JSON.parse(response.body)
        expect(json_response['density_percentage']).to eq(5.0)
      end
    end

    context 'when density is 0%' do
      before do
        allow(KeywordDensityCalculationService).to receive(:call)
          .and_return({ total_reviews: 100, matching_reviews: 0, density_percentage: 0.0 })
      end

      it 'returns 0 for matching density' do
        get '/api/v1/metrics/keyword_density', params: valid_params
        json_response = JSON.parse(response.body)
        expect(json_response['density_percentage']).to eq(0.0)
      end
    end

    context 'when a database error occurs' do
      before do
        allow(KeywordDensityCalculationService).to receive(:call)
          .and_return({ error: 'DB Error' })
      end

      it 'returns a success status but contains an error message' do
        get '/api/v1/metrics/keyword_density', params: valid_params
        expect(response).to have_http_status(:success)
      end

      it 'returns the error message from the service' do
        get '/api/v1/metrics/keyword_density', params: valid_params
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('DB Error')
      end
    end
  end
end
