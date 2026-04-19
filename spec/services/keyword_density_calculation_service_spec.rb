require 'rails_helper'

RSpec.describe KeywordDensityCalculationService do
  describe '.call' do
    let(:app_id) { 'com.test.app' }
    let(:start_date) { '2025-01-01' }
    let(:end_date) { '2025-01-31' }
    let(:term) { 'bug' }

    let(:params) do
      {
        app_id: app_id,
        start_date: start_date,
        end_date: end_date,
        term: term
      }
    end

    before do
      # Matching review
      Review.create!(app_id: app_id, date: '2025-01-15', content: 'This app has a big BUG in it.', rating: 1)
      # Non-matching review
      Review.create!(app_id: app_id, date: '2025-01-16', content: 'Great app, no issues.', rating: 5)
      # Outside date range
      Review.create!(app_id: app_id, date: '2025-02-01', content: 'Another bug here.', rating: 2)
      # Different app
      Review.create!(app_id: 'com.other.app', date: '2025-01-15', content: 'A bug in the other app.', rating: 1)
    end

    it 'calculates the total reviews correctly' do
      result = described_class.call(params)
      expect(result[:total_reviews]).to eq(2)
    end

    it 'calculates the matching reviews correctly' do
      result = described_class.call(params)
      expect(result[:matching_reviews]).to eq(1)
    end

    it 'calculates the density percentage correctly' do
      result = described_class.call(params)
      expect(result[:density_percentage]).to eq(50.0)
    end
  end
end
