FROM ruby:4.0.6-alpine

WORKDIR /app

ENV LANG=C.UTF-8

# Build tools needed to compile native gem extensions (e.g. json) on Alpine
RUN apk add --no-cache build-base

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

CMD ["ruby", "bin/guess"]