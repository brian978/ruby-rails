FROM brian978/ruby-rails:3.4

# Set production environment
ENV RAILS_ENV="development" \
    BUNDLE_DEPLOYMENT="0" \
    BUNDLE_PATH="vendor/bundle"

RUN bundle config path "${BUNDLE_PATH}" --local

# Dev shortcuts
RUN echo 'alias rspec="bundle exec rspec"' >> ~/.bashrc
RUN echo 'alias rails="bin/rails"' >> ~/.bashrc