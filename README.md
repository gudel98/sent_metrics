# SenT Metrics
[![CI](https://github.com/gudel98/sent_metrics/actions/workflows/ci.yml/badge.svg)](https://github.com/gudel98/sent_metrics/actions/workflows/ci.yml)

A minimalistic Ruby on Rails API for analyzing app review performance metrics. It provides insights into keyword density, sentiment distribution, and geographic trends across user reviews.

## Features

- **Keyword Density Analysis**: Calculate the percentage of reviews containing specific terms.
- **Multi-Term Search**: Search for multiple keywords simultaneously (e.g., `term=bug,crash`).
- **Sentiment Breakdown**: Categorizes matching reviews into positive, neutral, and negative sentiments.
- **Geographic Distribution**: Groups matching reviews by country.
- **Data Visualization**: Built-in HTML rendering with Chart.js for instant visual insights (`visualize=true`).
- **Asynchronous Processing**: Fast data ingestion via Rake tasks and Sidekiq background workers.

## Requirements

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Local Setup

The project is fully containerized using Docker Compose for a seamless local development experience.

1. **Build and start the containers:**
   ```bash
   docker compose up --build -d
   ```

2. **Setup the database:**
   ```bash
   docker compose exec web bundle exec rails db:prepare
   ```

3. **Ingest sample data:**
   ```bash
   docker compose exec web bundle exec rake reviews:ingest
   ```

## Usage

**Endpoint:** `GET /api/v1/metrics/keyword_density`

**Parameters:**
- `app_id` (string, required): The application identifier.
- `start_date` (date, required): Start of the date range (e.g., `2025-01-01`).
- `end_date` (date, required): End of the date range (e.g., `2025-01-31`).
- `term` (string, required): Keyword(s) to search for. Comma-separated for multiple terms.
- `visualize` (boolean, optional): Set to `true` to render an HTML dashboard with charts instead of JSON.

**Example Request:**
```bash
curl "http://localhost:3000/api/v1/metrics/keyword_density?app_id=com.instagram.android&start_date=2025-01-01&end_date=2025-01-31&term=bug,crash"
```

**Visualized version:**
http://localhost:3000/api/v1/metrics/keyword_density?app_id=com.instagram.android&start_date=2025-01-01&end_date=2025-01-31&term=bug,crash&visualize=true

## CI Pipeline & Quality

This project uses **GitHub Actions** for continuous integration. Every push triggers a pipeline that automatically runs:
- **RSpec** for automated testing
- **Rubocop** for code linting and style enforcement
- **Bundler Audit & Brakeman** for security vulnerability scanning

To run these checks locally:

1. **Run the test suite:**
   ```bash
   docker compose exec web bundle exec rspec
   ```

2. **Run the linter:**
   ```bash
   docker compose exec web bundle exec rubocop
   ```

3. **Run security audits:**
   ```bash
   docker compose exec web bundle exec bundler-audit check --update
   docker compose exec web bundle exec brakeman -q -w2
   ```
