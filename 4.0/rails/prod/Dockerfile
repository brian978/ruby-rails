FROM ruby:4.0-slim

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

WORKDIR /var/www/app

# Add Oracle MySQL 8.4 APT repository and install dependencies.
# [trusted=yes] bypasses sqv signature verification on Debian Trixie;
# Oracle's signing key (BCA4...) expired 2025-10-22 and the replacement
# key is not yet distributed in any well-known key file. The repo is
# served over HTTPS so transport security is preserved.
# libmysqlclient-dev (Oracle) and libmariadb3 (MariaDB runtime) coexist:
#   - libmysqlclient-dev conflicts with libmariadb-dev (same headers)
#   - libmariadb3 is the runtime-only lib with no header conflict
RUN echo 'deb [trusted=yes] https://repo.mysql.com/apt/debian/ bookworm mysql-8.4-lts' \
         > /etc/apt/sources.list.d/mysql.list \
    && apt-get update && apt-get install -y --no-install-recommends \
        bash \
        build-essential \
        ruby-dev \
        libmysqlclient-dev \
        libmariadb3 \
        libssl-dev \
        tzdata \
        git \
        pkg-config \
        libyaml-dev \
    && rm -rf /var/lib/apt/lists/*

# Run and own only the runtime files as a non-root user for security
RUN useradd -m -s /bin/bash rails && chown -R rails:rails /var/www/app
USER rails:rails

# Entrypoint prepares the database.
ENTRYPOINT ["bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
