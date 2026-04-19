class Review < ApplicationRecord
  validates :app_id, :content, :date, :rating, presence: true
  validate  :date_cannot_be_in_the_future
  validate  :country_must_be_valid_iso3166
  validates :rating, numericality: { only_integer: true,
                                     greater_than_or_equal_to: 1,
                                     less_than_or_equal_to: 5 }

  private

  def date_cannot_be_in_the_future
    if date.present? && date > Date.current
      errors.add(:date, "cannot be in the future")
    end
  end

  def country_must_be_valid_iso3166
    if country.present? && ISO3166::Country[country.upcase].nil?
      errors.add(:country, "must be a valid 2-letter country code")
    end
  end
end
