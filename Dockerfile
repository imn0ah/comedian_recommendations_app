FROM ruby:3.4

WORKDIR /app

ENV RAILS_ENV=production

RUN apt-get update && \
    apt-get install -y libpq-dev

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

RUN SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile

CMD ["sh", "-c", "bin/rails db:prepare && exec bin/rails server -b 0.0.0.0"]