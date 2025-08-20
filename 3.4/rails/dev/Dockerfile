FROM brian978/ruby-rails:3.4

# Ensure sudo is available and grant rails user passwordless sudo
# Switch to root in case the base image sets a non-root user
USER root
RUN apk update && apk add --no-cache sudo \
    && echo 'rails ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/rails \
    && chmod 440 /etc/sudoers.d/rails

# Set development environment
ENV RAILS_ENV="development" \
    BUNDLE_DEPLOYMENT="0" \
    BUNDLE_PATH="vendor/bundle"

# Switch back to rails user for app operations
USER rails:rails
RUN bundle config path "${BUNDLE_PATH}" --local

# Dev shortcuts
RUN echo 'alias rspec="bundle exec rspec"' >> ~/.bashrc
RUN echo 'alias rails="bin/rails"' >> ~/.bashrc