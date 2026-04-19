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
