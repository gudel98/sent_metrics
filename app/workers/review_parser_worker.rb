class ReviewParserWorker
  include Sidekiq::Worker

  sidekiq_options queue: "reviews_ingestion", retry: false

  def perform(raw_data_ids)
    raw_data_records = RawData.where(id: raw_data_ids)
    return if raw_data_records.empty?

    reviews = raw_data_records.map do |raw_data|
      payload = raw_data.payload
      Review.new(
        app_id:  payload['app_id'],
        date:    payload['date'],
        country: payload['country'],
        content: payload['content'],
        rating:  payload['rating'],
        title:   payload['title']
      )
    end

    Review.import(reviews, validate: true)
  end
end
