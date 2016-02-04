FROM cnosuke/ruby23-base
MAINTAINER cnosuke

RUN mkdir -p /app /data
COPY app/Gemfile /app/Gemfile
COPY app/Gemfile.lock /app/Gemfile.lock
RUN cd /app && bundle install --without development test --deployment --quiet

ADD app /app

WORKDIR /app
EXPOSE 8080
CMD ["bundle", "exec", "unicorn", "-E", "production", "-c", "config/unicorn.rb"]
