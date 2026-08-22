FROM ruby:4.0.6-alpine

WORKDIR /app

ENV LANG=C.UTF-8

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

CMD ["ruby", "bin/guess"]