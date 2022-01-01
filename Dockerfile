FROM ruby:alpine as gembuilder

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1
RUN apk add --no-cache gcc musl-dev ruby-dev make

WORKDIR /usr/src/app
COPY Gemfile Gemfile.lock ./
RUN bundle install --path vendor/bundle

FROM ruby:alpine

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app
VOLUME /usr/src/build
VOLUME /usr/src/app/docs

COPY --from=gembuilder /usr/src/app/vendor .
COPY ./ ./
