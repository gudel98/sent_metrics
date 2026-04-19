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

    # for typos and not strict searches we can use .where("content % ?", term) instead of ILIKE
    matching_reviews = reviews.where("content ILIKE ?", "%#{term}%")

    rating_counts  = matching_reviews.group(:rating).count
    negative_count = rating_counts.fetch(1, 0) + rating_counts.fetch(2, 0)
    neutral_count  = rating_counts.fetch(3, 0)
    positive_count = rating_counts.fetch(4, 0) + rating_counts.fetch(5, 0)

    total_reviews      = reviews.count
    matching_count     = matching_reviews.count
    density_percentage = (matching_count.to_f / total_reviews.to_f * 100).round(2)

    {
      total_reviews:      total_reviews,
      matching_reviews:   matching_count,
      density_percentage: density_percentage,
      negative_reviews:   negative_count,
      neutral_reviews:    neutral_count,
      positive_reviews:   positive_count,
      error:              nil
    }
  rescue StandardError => e
    Rails.logger.error "Error calculating keyword density: #{e.message}"
    { error: e.message }
  end
end
