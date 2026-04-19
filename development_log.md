# Development Log

## Initial Assumptions & Scope
- **Data Ingestion**: The provided `reviews.json` file is a single large JSON object containing a `reviews` array. Given the potential size of such files in production, I opted for a batch ingestion strategy.
- **Database Schema**: The `RawData` model stores the raw JSON payload to ensure no data is lost during the initial ingestion phase. The `Review` model extracts the specific fields required for the API (`app_id`, `date`, `country`, `content`, `rating`, `title`).

## Open Questions & Future Considerations
- **Performance**: As the `reviews` table grows, querying by `app_id`, `date`, and performing searches on `content` will become slow. Adding a trigram index (`pg_trgm`) on the `content` column would significantly improve search performance. + GIN index

## Evolution of Thought Process
1.  **Infrastructure Setup**: I started by containerizing the application with Docker Compose to ensure a consistent development environment, including PostgreSQL and Redis for Sidekiq.
2.  **Data Pipeline**: I designed a two-step ingestion process: a Rake task to quickly load raw JSON into the database, and Sidekiq workers to asynchronously parse and format the data. This decoupling ensures the ingestion process is fast and resilient to parsing errors.
3.  **Testing & CI**: I configured GitHub Actions to run RSpec, Rubocop, and Bundler Audit to maintain code quality and security.
