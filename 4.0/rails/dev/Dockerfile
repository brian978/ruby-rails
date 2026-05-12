FROM brian978/ruby-rails:4.0

# Ensure sudo is available and grant rails user passwordless sudo
# Switch to root in case the base image sets a non-root user
USER root
RUN apt-get update && apt-get install -y --no-install-recommends sudo \
    && echo 'rails ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/rails \
    && chmod 440 /etc/sudoers.d/rails \
    && rm -rf /var/lib/apt/lists/*

# Set development environment
ENV RAILS_ENV="development" \
    BUNDLE_DEPLOYMENT="0" \
    BUNDLE_PATH="vendor/bundle"

# Switch back to rails user for app operations
USER rails:rails
RUN bundle config path "${BUNDLE_PATH}" --local

# Configure bundler to build mysql2 against Oracle's libmysqlclient.
# mysql_config from libmysqlclient-dev points to libmysqlclient.so (not
# libmariadb.so.3), so ssl_mode: DISABLED is honoured correctly by Rails.
RUN MYSQL_LIB=$(mysql_config --variable=pkglibdir) && \
    MYSQL_INC=$(mysql_config --variable=pkgincludedir) && \
    bundle config build.mysql2 "--with-mysql-lib=${MYSQL_LIB} --with-mysql-include=${MYSQL_INC}"

# Dev shortcuts
RUN echo 'alias rspec="bundle exec rspec"' >> ~/.bashrc
RUN echo 'alias rails="bin/rails"' >> ~/.bashrc
