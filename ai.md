# AI Usage Log

This project was developed with the assistance of an AI coding agent (Cursor / Claude 3.5 Sonnet / Gemini 3.1 Pro).

## How AI was used:
1.  **Project Scaffolding**: The AI generated the initial Rails API structure, Dockerfile, and `docker-compose.yml` to set up the PostgreSQL, Redis, and Sidekiq environment.
2.  **CI/CD Pipeline**: The AI created the `.github/workflows/ci.yml` file to run RSpec, Rubocop, and Bundler Audit on push and pull requests.

## Prompts Used (Summary):
- "I want to build ruby on rails API using postgresql as DB, rspec as test framework..."
- "reviews.json file added, analyze it for schema"
- "let's add AI rules which will be always checked and executed for all my prompts: 1. Feature implementation must always be TDD-oriented... 2. Code must always be written according to rubocop style... 3. All AI work and prompts must be added into ai.md..."

## 2026-04-19 - Added AI Rules

**Prompt Used:**
"let's add AI rules which will be always checked and executed for all my prompts: 1. Feature implementation must always be TDD-oriented... 2. Code must always be written according to rubocop style... 3. All AI work and prompts must be added into ai.md..."

**Work Completed:**
- Created `.cursor/rules/tdd-enforcement.mdc` to enforce TDD.
- Created `.cursor/rules/rubocop-enforcement.mdc` to enforce Rubocop styling and verification.
- Created `.cursor/rules/ai-logging.mdc` to enforce logging AI work and prompts in `ai.md`.
- Updated `ai.md` to reflect the creation of these rules.
