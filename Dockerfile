FROM cnosuke/ruby22-base
MAINTAINER cnosuke

RUN mkdir -p /app /data
COPY app/Gemfile /app/Gemfile
COPY app/Gemfile.lock /app/Gemfile.lock
RUN cd /app && bundle install --without development test --deployment --quiet

ADD app /app

EXPOSE 8080
CMD ["/app/run_on_docker.sh"]
