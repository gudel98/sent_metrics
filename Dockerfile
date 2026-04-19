ARG RUBY_VERSION=4.0.1
FROM ruby:$RUBY_VERSION-slim

# Install dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev postgresql-client libyaml-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

WORKDIR /rails

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

# Entrypoint prepares the database
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
