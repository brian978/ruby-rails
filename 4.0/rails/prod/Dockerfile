FROM ruby:4.0-slim

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

WORKDIR /var/www/app

# Add Oracle MySQL 8.4 APT repository and install dependencies.
# Oracle's signing key (BCA4...) expired 2025-10-22; Debian Trixie's sqv
# verifier rejects it even with [trusted=yes] in the source entry on some
# architectures. Writing AllowInsecureRepositories to apt.conf before
# apt-get update fully disables signature checking for this repo.
# The repo is served over HTTPS so transport security is preserved.
# libmysqlclient-dev (Oracle) and libmariadb3 (MariaDB runtime) coexist:
#   - libmysqlclient-dev conflicts with libmariadb-dev (same headers)
#   - libmariadb3 is the runtime-only lib with no header conflict
RUN echo 'deb [trusted=yes] https://repo.mysql.com/apt/debian/ bookworm mysql-8.4-lts' \
         > /etc/apt/sources.list.d/mysql.list \
    && echo 'APT::Get::AllowUnauthenticated "true";' \
         > /etc/apt/apt.conf.d/99allow-unauth \
    && echo 'Acquire::AllowInsecureRepositories "true";' \
         >> /etc/apt/apt.conf.d/99allow-unauth \
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
    && rm -rf /var/lib/apt/lists/* /etc/apt/apt.conf.d/99allow-unauth

# Run and own only the runtime files as a non-root user for security
RUN useradd -m -s /bin/bash rails && chown -R rails:rails /var/www/app
USER rails:rails

# Entrypoint prepares the database.
ENTRYPOINT ["bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
