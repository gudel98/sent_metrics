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

    total_reviews      = reviews.count
    matching_reviews   = reviews.where("content ILIKE ?", "%#{term}%").count
    density_percentage = (matching_reviews.to_f / total_reviews.to_f * 100).round(2)
    # for typos and not strict searches we can use .where("content % ?", term) instead of ILIKE

    {
      total_reviews: total_reviews,
      matching_reviews: matching_reviews,
      density_percentage: density_percentage,
      error: nil
    }
  rescue StandardError => e
    Rails.logger.error "Error calculating keyword density: #{e.message}"
    { error: e.message }
  end
end
