FROM ruby:2.6.0
MAINTAINER cnosuke

RUN mkdir -p /app /data
COPY app/Gemfile /app/Gemfile
COPY app/Gemfile.lock /app/Gemfile.lock
RUN cd /app && bundle install --without development test --deployment --quiet

ADD app /app

WORKDIR /app
EXPOSE 8080
ENV APP_PATH /app
ENV AWS_REGION ap-northeast-1
ENV SINATRA_LISTEN 0.0.0.0:8080
CMD ["bundle", "exec", "unicorn", "-E", "production", "-c", "config/unicorn.rb"]
