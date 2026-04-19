require 'json'

namespace :reviews do
  desc 'Ingest reviews from a JSON file and enqueue Sidekiq jobs'
  task :ingest, [:file_path] => :environment do |_, args|
    file_path = args[:file_path] || 'reviews.json'

    unless File.exist?(file_path)
      puts "File not found: #{file_path}"
      exit 1
    end

    puts "Starting ingestion of #{file_path}..."

    batch_size   = 1000
    count        = 0
    file_content = File.read(file_path)
    data         = JSON.parse(file_content)
    reviews      = data['reviews'] || []

    reviews.each_slice(batch_size) do |review_batch|
      payload_batch = review_batch.map { |review| { payload: review } }
      
      insert_and_enqueue(payload_batch)
      count += payload_batch.size
      puts "Processed #{count} reviews..."
    end

    puts "Ingestion finished."
  end

  def insert_and_enqueue(batch)
    raw_data_records = RawData.insert_all(batch, returning: %w[id])

    ReviewParserWorker.perform_async(raw_data_records.rows.flatten)
  end
end
