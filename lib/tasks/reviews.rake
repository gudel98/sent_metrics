namespace :reviews do
  desc "Ingest reviews from a JSON file and enqueue Sidekiq jobs"
  task :ingest, [ :file_path ] => :environment do |_, args|
    file_path = args[:file_path] || "reviews.json"

    unless File.exist?(file_path)
      puts "File not found: #{file_path}"
      exit 1
    end

    puts "Starting ingestion of #{file_path}..."

    batch_size = 1000
    count      = 0

    handler = ReviewSajHandler.new(batch_size) do |batch|
      insert_and_enqueue(batch)
      count += batch.size
      puts "Processed #{count} reviews..."
    end

    File.open(file_path, "r") do |file|
      Oj.saj_parse(handler, file)
    end

    puts "Ingestion finished."
  end

  def insert_and_enqueue(batch)
    raw_data_records = RawData.insert_all(batch, returning: %w[id])

    ReviewParserWorker.perform_async(raw_data_records.rows.flatten)
  end
end
