FROM ruby:4.0-slim

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

WORKDIR /var/www/app

# Common build dependencies (architecture-independent)
RUN apt-get update && apt-get install -y --no-install-recommends \
        bash \
        build-essential \
        ruby-dev \
        libmariadb3 \
        libssl-dev \
        tzdata \
        git \
        pkg-config \
        libyaml-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Oracle libmysqlclient-dev on amd64 (not available for arm64).
# On arm64 fall back to default-libmysqlclient-dev (MariaDB-compatible headers).
# Oracle's signing key expired 2025-10-22; AllowInsecureRepositories bypasses
# sqv validation. The repo is served over HTTPS.
ARG TARGETARCH
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        echo 'deb [trusted=yes] https://repo.mysql.com/apt/debian/ bookworm mysql-8.4-lts' \
             > /etc/apt/sources.list.d/mysql.list \
        && echo 'APT::Get::AllowUnauthenticated "true";' \
             > /etc/apt/apt.conf.d/99allow-unauth \
        && echo 'Acquire::AllowInsecureRepositories "true";' \
             >> /etc/apt/apt.conf.d/99allow-unauth \
        && apt-get update \
        && apt-get install -y --no-install-recommends libmysqlclient-dev \
        && rm -rf /var/lib/apt/lists/* /etc/apt/apt.conf.d/99allow-unauth \
             /etc/apt/sources.list.d/mysql.list ; \
    else \
        apt-get update \
        && apt-get install -y --no-install-recommends default-libmysqlclient-dev \
        && rm -rf /var/lib/apt/lists/* ; \
    fi

# Run and own only the runtime files as a non-root user for security
RUN useradd -m -s /bin/bash rails && chown -R rails:rails /var/www/app
USER rails:rails

# Entrypoint prepares the database.
ENTRYPOINT ["bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
