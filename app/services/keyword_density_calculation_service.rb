class KeywordDensityCalculationService
  def self.call(params)
    new(params).call
  end

  attr_reader :app_id, :start_date, :end_date, :term

  def initialize(params)
    @app_id     = params[:app_id]
    @start_date = params[:start_date]
    @end_date   = params[:end_date]
    @term       = params[:term]
  end

  def call
    reviews = Review.where(app_id: app_id, date: start_date..end_date)

    matching_reviews = find_matching_reviews(reviews:)

    total_reviews      = reviews.count
    matching_count     = matching_reviews.count
    density_percentage = (matching_count.to_f / total_reviews.to_f * 100).round(2)

    {
      total_reviews:        total_reviews,
      matching_reviews:     matching_count,
      density_percentage:   density_percentage,
      rating_distribution:  rating_distribution(matching_reviews:),
      country_distribution: country_distribution(matching_reviews:),
      error:                nil
    }
  rescue StandardError => e
    Rails.logger.error "Error calculating keyword density: #{e.message}"
    { error: e.message }
  end

  private

  def find_matching_reviews(reviews:)
    terms = term.split(",").map(&:strip).map { |t| "%#{t}%" }

    if terms.count > 1
      reviews.where("content ILIKE ANY (ARRAY[?])", terms)
    else
      reviews.where("content ILIKE ?", "%#{term}%")
    end
  end

  def rating_distribution(matching_reviews:)
    distribution = matching_reviews.group(:rating).count
    {
      negative: distribution.fetch(1, 0) + distribution.fetch(2, 0),
      neutral:  distribution.fetch(3, 0),
      positive: distribution.fetch(4, 0) + distribution.fetch(5, 0)
    }
  end

  def country_distribution(matching_reviews:)
    matching_reviews.group(:country).count
  end
end
