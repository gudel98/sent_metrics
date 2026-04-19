# AI Usage Log

This project was developed with the assistance of an AI coding agent (Cursor / Claude 3.5 Sonnet / Gemini 3.1 Pro).

## How AI was used:
1.  **Project Scaffolding**: The AI generated the initial Rails API structure, Dockerfile, and `docker-compose.yml` to set up the PostgreSQL, Redis, and Sidekiq environment.
2.  **CI/CD Pipeline**: The AI created the `.github/workflows/ci.yml` file to run RSpec, Rubocop, and Bundler Audit on push and pull requests.

## 2026-04-19 - Added AI Rules

**Prompt Used:**
"let's add AI rules which will be always checked and executed for all my prompts: 1. Feature implementation must always be TDD-oriented... 2. Code must always be written according to rubocop style... 3. All AI work and prompts must be added into ai.md..."

**Work Completed:**
- Created `.cursor/rules/tdd-enforcement.mdc` to enforce TDD.
- Created `.cursor/rules/rubocop-enforcement.mdc` to enforce Rubocop styling and verification.
- Created `.cursor/rules/ai-logging.mdc` to enforce logging AI work and prompts in `ai.md`.
- Updated `ai.md` to reflect the creation of these rules.

## 2026-04-19 - Added Rake Task Tests

**Prompt Used:**
"Add test for reviews.rake task"

**Work Completed:**
- Wrote `spec/lib/tasks/reviews_rake_spec.rb` to test the `reviews:ingest` rake task.
- Fixed Rubocop offenses in the test file.
- Fixed `.rubocop.yml` deprecation warning (replaced `require` with `plugins`).

## 2026-04-19 - Fixed Rubocop Issues

**Prompt Used:**
"Fix rubocop issues"

**Work Completed:**
- Ran `bundle exec rubocop -a` to automatically fix all styling offenses in the codebase (such as string literals, spacing, and trailing whitespace).
- Verified that `bundle exec rubocop` now reports 0 offenses.

## 2026-04-19 - Added GIN Index with pg_trgm

**Prompt Used:**
"let's add GIN index + pg_trgm for term column of Review table to speedup text searches in KeywordDensityCalculationService"

**Work Completed:**
- Generated migration `AddTrigramIndexToReviewsContent` to enable the `pg_trgm` extension and add a GIN index to the `reviews.content` column.
- Wrote RSpec tests for `KeywordDensityCalculationService` in `spec/services/keyword_density_calculation_service_spec.rb` to adhere to TDD rules.
- Ran Rubocop to ensure the migration and tests comply with styling rules.

## 2026-04-19 - Removed Controller Rescue Logic

**Prompt Used:**
"errors are handled in KeywordDensityCalculationService, no need to rescue them in controller"

**Work Completed:**
- Updated `spec/requests/api/v1/metrics_spec.rb` to expect the DB error to be returned as a standard JSON response with a 200 status, since the service rescues the error and returns it in the hash.
- Ran Rubocop to ensure the updated tests comply with styling rules.

## 2026-04-19 - Added Review Model Validations

**Prompt Used:**
"add model validations for review model - date is a valid date. cannot be in the future - country is aplha 2 country code - rating is only [1,2,3,4,5]"

**Work Completed:**
- Wrote RSpec tests in `spec/models/review_spec.rb` to verify date, country, and rating validations.
- Implemented validations in `app/models/review.rb` for date (custom validation for future dates), country (regex for 2-letter uppercase), and rating (numericality between 1 and 5).
- Ran Rubocop to ensure the model and tests comply with styling rules.

## 2026-04-19 - Updated Country Validation

**Prompt Used:**
"I've added countries gem, update review.country validation based on countries gem"

**Work Completed:**
- Updated `spec/models/review_spec.rb` to include a test for a non-existent 2-letter country code ('ZZ').
- Updated `app/models/review.rb` to use a custom validation method (`country_must_be_valid_iso3166`) that checks the country code against the `countries` gem (`ISO3166::Country[country]`).
- Ran Rubocop to ensure the model and tests comply with styling rules.

## 2026-04-19 - Added Chart.js Visualization View

**Prompt Used:**
"let's add vizualization for results of KeywordDensityCalculationService rendering keyword_density view using chart.js"

**Work Completed:**
- Extracted the HTML generation from the controller into a dedicated view template (`app/views/api/v1/metrics/keyword_density.html.erb`) using Chart.js.
- Updated `Api::V1::MetricsController` to use `render template:` when `visualize=true`.
- Added RSpec tests in `spec/requests/api/v1/metrics_spec.rb` to verify the HTML response and the presence of Chart.js.
- Ran Rubocop to ensure the code complies with styling rules.
- Add histogram to keword_density view which will show matched reviews distributions based on country
- Updated `app/views/api/v1/metrics/keyword_density.html.erb` to render a Chart.js bar chart for the country distribution.

## 2026-04-19 - Multi-Term Search Test Coverage

**Prompt:** add test coverage for newly added multi-term search feature
**Action Taken:** Added a new `context 'when multiple terms are provided'` block to `spec/services/keyword_density_calculation_service_spec.rb`. This tests that providing multiple terms calculates the total reviews, matching reviews (without double counting), and density percentage correctly.

### Documentation Update
**Prompt:** add documentation for local setup of this project, description of it's functionality, guide for testing. make it minimalistic and elegant
**Action Taken:** Rewrote the `README.md` file completely to provide a clean, elegant, and comprehensive guide covering project features, Docker-based local setup, API usage (including multi-term search and visualization), and testing/linting commands.

### Documentation Update
**Prompt:** replace it with badge for my repo
**Action Taken:** Replaced the static CI badge in `README.md` with the live GitHub Actions badge for the `gudel98/sent_metrics` repository.
