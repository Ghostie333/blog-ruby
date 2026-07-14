# syntax=docker/dockerfile:1
# check=error=true

ARG RUBY_VERSION=3.4.8
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Instalacja pakietów i chromium dla grovera
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libjemalloc2 \
    libvips \
    postgresql-client \
    chromium \
    chromium-driver && \
    ln -s /usr/lib/$(uname -m)-linux-gnu/libjemalloc.so.2 /usr/local/lib/libjemalloc.so && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Zmienne środowiskowe dla Puppeteera/Grovera w kontenerze
ENV GROVER_NO_SANDBOX=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

ENV RAILS_ENV="development" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    LD_PRELOAD="/usr/local/lib/libjemalloc.so"

FROM base AS build

# Pakiety potrzebne do skompilowania gemów
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libvips libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Instalacja gemów aplikacji
COPY vendor/* ./vendor/
COPY Gemfile Gemfile.lock ./

RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile -j 1 --gemfile

# Kopiowanie kodu aplikacji
COPY . .

RUN bundle exec bootsnap precompile -j 1 app/ lib/
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

FROM base

COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Skrypt wejściowy
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Uruchomienie serwera na porcie 3000
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
