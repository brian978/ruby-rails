FROM ruby:4.0-slim

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

WORKDIR /var/www/app

# Add Oracle MySQL 8.4 APT repository and install dependencies.
# Uses the 2023 MySQL signing key (valid until 2027) with gpgv for
# OpenPGP verification, since Debian Trixie's default sqv verifier
# rejects the key's self-signature under its stricter expiry rules.
# libmysqlclient-dev (Oracle) and libmariadb3 (MariaDB runtime) coexist:
#   - libmysqlclient-dev conflicts with libmariadb-dev (same headers)
#   - libmariadb3 is the runtime-only lib with no header conflict
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates curl gpg gpgv \
    && curl -fsSL 'https://keys.openpgp.org/vks/v1/by-fingerprint/BCA43417C3B485DD128EC6D4B7B3B788A8D3785C' \
         | gpg --dearmor -o /usr/share/keyrings/mysql.gpg \
    && echo 'deb [signed-by=/usr/share/keyrings/mysql.gpg] https://repo.mysql.com/apt/debian/ bookworm mysql-8.4-lts' \
         > /etc/apt/sources.list.d/mysql.list \
    && echo 'Acquire::OpenPGP::Verification "gpgv";' \
         > /etc/apt/apt.conf.d/99mysql-gpg \
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
    && apt-get purge -y --auto-remove curl gpg \
    && rm -rf /var/lib/apt/lists/*

# Run and own only the runtime files as a non-root user for security
RUN useradd -m -s /bin/bash rails && chown -R rails:rails /var/www/app
USER rails:rails

# Entrypoint prepares the database.
ENTRYPOINT ["bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
