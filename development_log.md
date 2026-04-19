# Development Log

## Initial Assumptions & Scope
- **Data Ingestion**: The provided `reviews.json` file is a single large JSON object containing a `reviews` array. Given the potential size of such files in production, I opted for a batch ingestion strategy.
- **Database Schema**: The `RawData` model stores the raw JSON payload to ensure no data is lost during the initial ingestion phase. The `Review` model extracts the specific fields required for the API (`app_id`, `date`, `country`, `content`, `rating`, `title`).

## Thought Process
1.  **Infrastructure Setup**: I started by containerizing the application with Docker Compose to ensure a consistent development environment, including PostgreSQL and Redis for Sidekiq.
2.  **Data Pipeline**: I designed a two-step ingestion process: a Rake task to quickly load raw JSON into the database, and Sidekiq workers to asynchronously parse and format the data. This decoupling ensures the ingestion process is fast and resilient to parsing errors.
3.  **Testing & CI**: I configured GitHub Actions to run RSpec, Rubocop, and Bundler Audit to maintain code quality and security.
4.  **API & Business Logic**: Implemented the `Api::V1::MetricsController#keyword_density` endpoint. To keep the controller thin and testable, the core calculation logic was extracted into a dedicated `KeywordDensityCalculationService`. This service handles the `ILIKE` queries, density math, and gracefully rescues database errors.
5.  **Performance Optimization**: To ensure the `ILIKE '%term%'` queries remain fast as the `reviews` table grows, I added the `pg_trgm` extension and a GIN index to the `content` column. This allows PostgreSQL to perform lightning-fast trigram-based index scans instead of full table scans.
6.  **Data Visualization**: Added a visual representation of the keyword density metrics. The endpoint can now render an HTML page with Chart.js when `visualize=true` is passed. This includes a pie chart for sentiment distribution (positive/neutral/negative) and a bar chart (histogram) for the distribution of matched reviews across different countries, displayed side-by-side using CSS Flexbox.
7.  **Multi-Term Search**: Enhanced the keyword density calculation to support multiple terms simultaneously (e.g., `term=good,fun`). This was implemented using PostgreSQL's `ILIKE ANY (ARRAY[...])` syntax, which efficiently leverages the existing `pg_trgm` GIN index to find reviews containing any of the provided keywords while correctly handling overlapping matches.
8.  **Documentation**: I've added a minimalistic documentation into README.md with a quick setup guide.
9.  **Memory Optimization**: Replaced the standard `JSON.parse` in the `reviews:ingest` Rake task with `Oj::Saj` (a streaming JSON parser). This prevents Out of Memory (OOM) errors by parsing the `reviews.json` file chunk-by-chunk instead of loading the entire file into RAM at once, making the ingestion process highly scalable.
10. **Worker Idempotency**: I've added a unique composite index to the `reviews` table (`app_id`, `date`, `rating`, `country`, `title`) and updated the Sidekiq `ReviewParserWorker` to use `on_duplicate_key_ignore: true` during bulk imports. This ensures that if a worker fails halfway and is retried, it will not insert duplicate reviews into the database.
11. **Unused index**: The app_id index is redundant because I already created a composite unique index `index_reviews_on_unique_attributes` that starts with app_id. PostgreSQL can use the first column of a composite index efficiently.

## Open Questions & Future Considerations
- **Handling new data**: Right now, the app is built to read the `reviews.json` file once. If we need to constantly add new reviews as they come in, we would need to build a system that automatically fetches or receives new data in the background.
- **Source file correctness**: I'm aware of the fact that source `reviews.json` can contain some incorrect data so in the future I cn implement an extended flexible parsing mechanism to aggregate reviews in different formats.
- **Extend search aread**: We can also either extend search to title column or add a separate title-search feature.
- **Add rate limiting and restrict wide date ranges**: Wide ranges of dates can load the DB. As a future improvement they can be reduces. I would also implement `rack-attack` in the future.
- **visualize=true**: I use visualize parameter for testing simplicity but I would improve my controller by delegating content type separation to `Accept` HTTP header.
