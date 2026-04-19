require 'rails_helper'
require 'rake'

RSpec.describe 'reviews:ingest', type: :task do # rubocop:disable RSpec/DescribeClass
  before do
    Rails.application.load_tasks if Rake::Task.tasks.empty?
    Rake::Task['reviews:ingest'].reenable
  end

  context 'when the file does not exist' do
    it 'outputs an error message and exits' do
      expect {
        Rake::Task['reviews:ingest'].invoke('non_existent_file.json')
      }.to raise_error(SystemExit)
       .and output(/File not found: non_existent_file\.json/).to_stdout
    end
  end

  context 'when the file exists' do
    let(:test_file_path) { 'spec/fixtures/test_reviews.json' }
    let(:reviews_data) do
      {
        'reviews' => [
          { 'app_id' => 'com.example.app', 'content' => 'Great app!' },
          { 'app_id' => 'com.example.app', 'content' => 'Needs work.' }
        ]
      }
    end

    before do
      FileUtils.mkdir_p('spec/fixtures')
      File.write(test_file_path, reviews_data.to_json)
      allow(ReviewParserWorker).to receive(:perform_async)
    end

    after do
      FileUtils.rm_rf('spec/fixtures')
    end

    it 'inserts RawData records' do
      expect {
        Rake::Task['reviews:ingest'].invoke(test_file_path)
      }.to change(RawData, :count).by(2)
       .and output(/Ingestion finished\./).to_stdout
    end

    it 'enqueues ReviewParserWorker jobs' do
      # Suppress output for this test to avoid clutter
      allow($stdout).to receive(:puts)
      Rake::Task['reviews:ingest'].invoke(test_file_path)
      expect(ReviewParserWorker).to have_received(:perform_async).twice
    end
  end
end
