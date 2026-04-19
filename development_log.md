# Development Log

## Initial Assumptions & Scope
- **Data Ingestion**: The provided `reviews.json` file is a single large JSON object containing a `reviews` array. Given the potential size of such files in production, I opted for a batch ingestion strategy.
- **Database Schema**: The `RawData` model stores the raw JSON payload to ensure no data is lost during the initial ingestion phase. The `Review` model extracts the specific fields required for the API (`app_id`, `date`, `country`, `content`, `rating`, `title`).

## Open Questions & Future Considerations
- **Handling New Data**: Right now, the app is built to read the `reviews.json` file once. If we need to constantly add new reviews as they come in, we would need to build a system that automatically fetches or receives new data in the background.
- **Understanding User Feelings**: It would be really useful to see if certain keywords are linked to good or bad reviews. For example, if the word "bug" shows up a lot, we could check if those specific reviews also have 1-star ratings to prove it's a negative trend. For example: "There are no bugs in application" against "There are too many bugs".
- **Country-based chart**: I'm gonna add country-based chart.

## Evolution of Thought Process
1.  **Infrastructure Setup**: I started by containerizing the application with Docker Compose to ensure a consistent development environment, including PostgreSQL and Redis for Sidekiq.
2.  **Data Pipeline**: I designed a two-step ingestion process: a Rake task to quickly load raw JSON into the database, and Sidekiq workers to asynchronously parse and format the data. This decoupling ensures the ingestion process is fast and resilient to parsing errors.
3.  **Testing & CI**: I configured GitHub Actions to run RSpec, Rubocop, and Bundler Audit to maintain code quality and security.
4.  **API & Business Logic**: Implemented the `Api::V1::MetricsController#keyword_density` endpoint. To keep the controller thin and testable, the core calculation logic was extracted into a dedicated `KeywordDensityCalculationService`. This service handles the `ILIKE` queries, density math, and gracefully rescues database errors.
5.  **Performance Optimization**: To ensure the `ILIKE '%term%'` queries remain fast as the `reviews` table grows, I added the `pg_trgm` extension and a GIN index to the `content` column. This allows PostgreSQL to perform lightning-fast trigram-based index scans instead of full table scans.
