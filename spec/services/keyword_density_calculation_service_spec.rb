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
      # Matching reviews
      Review.create!(app_id: app_id, date: '2025-01-15', content: 'This app has a big BUG in it.', rating: 1, country: 'US')
      Review.create!(app_id: app_id, date: '2025-01-16', content: 'Another bug here.', rating: 2, country: 'US')
      Review.create!(app_id: app_id, date: '2025-01-17', content: 'Small bug but ok.', rating: 3, country: 'US')
      Review.create!(app_id: app_id, date: '2025-01-18', content: 'Found a bug but love it.', rating: 5, country: 'GB')

      # Non-matching review
      Review.create!(app_id: app_id, date: '2025-01-16', content: 'Great app, no issues.', rating: 5, country: 'US')

      # Outside date range
      Review.create!(app_id: app_id, date: '2025-02-01', content: 'Another bug here.', rating: 2, country: 'US')

      # Different app
      Review.create!(app_id: 'com.other.app', date: '2025-01-15', content: 'A bug in the other app.', rating: 1, country: 'US')
    end

    it 'calculates the total reviews correctly' do
      result = described_class.call(params)
      expect(result[:total_reviews]).to eq(5)
    end

    it 'calculates the matching reviews correctly' do
      result = described_class.call(params)
      expect(result[:matching_reviews]).to eq(4)
    end

    it 'calculates the density percentage correctly' do
      result = described_class.call(params)
      expect(result[:density_percentage]).to eq(80.0) # 4 out of 5
    end

    it 'calculates the negative reviews correctly (rating 1 and 2)' do
      result = described_class.call(params)
      expect(result[:rating_distribution][:negative]).to eq(2)
    end

    it 'calculates the neutral reviews correctly (rating 3)' do
      result = described_class.call(params)
      expect(result[:rating_distribution][:neutral]).to eq(1)
    end

    it 'calculates the positive reviews correctly (rating 4 and 5)' do
      result = described_class.call(params)
      expect(result[:rating_distribution][:positive]).to eq(1)
    end

    it 'calculates the country distribution correctly' do
      result = described_class.call(params)
      expect(result[:country_distribution]).to eq({ 'US' => 3, 'GB' => 1 })
    end

    context 'when multiple terms are provided' do
      let(:term) { 'bug, crash' }

      before do
        # Add a review with 'crash'
        Review.create!(app_id: app_id, date: '2025-01-19', content: 'It will crash occasionally.', rating: 1, country: 'US')
        # Add a review with both 'bug' and 'crash'
        Review.create!(app_id: app_id, date: '2025-01-20', content: 'A bug caused a crash.', rating: 1, country: 'US')
      end

      it 'calculates the total reviews correctly' do
        result = described_class.call(params)
        expect(result[:total_reviews]).to eq(7) # 5 from outer before + 2 new ones
      end

      it 'calculates the matching reviews correctly without double counting' do
        result = described_class.call(params)
        # Outer before has 4 matching 'bug'
        # New ones: 1 matching 'crash', 1 matching both 'bug' and 'crash'
        # Total matching should be 4 + 1 + 1 = 6
        expect(result[:matching_reviews]).to eq(6)
      end

      it 'calculates the density percentage correctly' do
        result = described_class.call(params)
        expect(result[:density_percentage]).to eq(85.71) # (6 / 7.0 * 100).round(2)
      end
    end
  end
end
