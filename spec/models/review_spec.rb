require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'validations' do
    subject(:review) { described_class.new(valid_attributes) }

    let(:valid_attributes) do
      {
        app_id: 'com.test.app',
        date: Date.current,
        country: 'US',
        content: 'Great app',
        rating: 5,
        title: 'Awesome'
      }
    end

    it 'is valid with valid attributes' do
      expect(review).to be_valid
    end

    describe 'date validation' do
      it 'is valid when date is today' do
        review.date = Date.current
        expect(review).to be_valid
      end

      it 'is valid when date is in the past' do
        review.date = 1.day.ago.to_date
        expect(review).to be_valid
      end

      it 'is invalid when date is in the future' do
        review.date = 1.day.from_now.to_date
        review.valid?
        expect(review.errors[:date]).to include('cannot be in the future')
      end

      it 'is invalid when date is not a real date' do
        review.date = 'invalid-date'
        expect(review).not_to be_valid
      end
    end

    describe 'country validation' do
      it 'is valid with a 2-letter uppercase country code' do
        review.country = 'GB'
        expect(review).to be_valid
      end

      it 'is invalid with a 3-letter code' do
        review.country = 'USA'
        review.valid?
        expect(review.errors[:country]).to include('must be a valid 2-letter country code')
      end

      it 'is invalid with numbers' do
        review.country = 'U1'
        expect(review).not_to be_valid
      end

      it 'is valid with lowercase letters' do
        review.country = 'us'
        expect(review).to be_valid
      end

      it 'is invalid with a non-existent 2-letter code' do
        review.country = 'ZZ'
        review.valid?
        expect(review.errors[:country]).to include('must be a valid 2-letter country code')
      end
    end

    describe 'rating validation' do
      it 'is valid with a rating between 1 and 5' do
        [ 1, 2, 3, 4, 5 ].each do |valid_rating|
          review.rating = valid_rating
          expect(review).to be_valid
        end
      end

      it 'is invalid with a rating of 0' do
        review.rating = 0
        review.valid?
        expect(review.errors[:rating]).to include('must be greater than or equal to 1')
      end

      it 'is invalid with a rating of 6' do
        review.rating = 6
        review.valid?
        expect(review.errors[:rating]).to include('must be less than or equal to 5')
      end

      it 'is invalid with a non-integer rating' do
        review.rating = 4.5
        expect(review).not_to be_valid
      end
    end
  end
end
