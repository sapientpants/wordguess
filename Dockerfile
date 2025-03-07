FROM elixir:1.15-alpine

# Install build dependencies
RUN apk add --no-cache build-base npm git postgresql-client inotify-tools

# Set working directory
WORKDIR /app

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Copy configuration files first to cache dependencies
COPY mix.exs mix.lock ./
COPY config config

# Install and compile dependencies 
RUN mix deps.get --only prod && \
    mix deps.compile

# Copy assets and install npm dependencies
COPY assets assets
WORKDIR /app/assets
RUN npm install
WORKDIR /app

# Copy all other files
COPY priv priv
COPY lib lib
COPY test test

# Configure for dev environment by default
ENV MIX_ENV=dev

# Don't pre-compile during build - we'll do this at runtime
# for better dev experience

# Expose the Phoenix port
EXPOSE 4000

# Set the entrypoint
CMD ["mix", "phx.server"]