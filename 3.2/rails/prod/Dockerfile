FROM ruby:3.2-alpine

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

WORKDIR /var/www/app

RUN apk add bash gcompat ruby-dev make gcc musl-dev mariadb-dev tzdata git

# Run and own only the runtime files as a non-root user for security
RUN adduser -s /bin/bash -h /home/rails -D rails && chown -R rails:rails /var/www/app
USER rails:rails

# Entrypoint prepares the database.
ENTRYPOINT ["bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
