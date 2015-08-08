FROM ubuntu:latest
MAINTAINER cnosuke

ENV HOME /root
RUN apt-get update
RUN apt-get -y install \
            build-essential \
            wget \
            zip \
            htop \
            git \
            emacs

# ruby & gem dependencies
RUN apt-get -y install \
    libcurl4-openssl-dev \
    libreadline-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    libyaml-dev \
    libncurses5-dev \
    libffi-dev \
    libgdbm3 \
    libgdbm-dev \
    zlib1g-dev \
    phantomjs \
    libmysqlclient-dev \
    libmysqlclient18 \
    mysql-server \
    autoconf \
    bison

RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN /root/.rbenv/bin/rbenv install 2.2.2
COPY server_config/bashrc_rbenv /tmp/
RUN cat /tmp/bashrc_rbenv > ~/.bashrc
RUN echo '2.2.2' > ~/.ruby-version

RUN mkdir -p /app /data
ADD app /app
COPY server_config/.env /app/.env
RUN cd /app && RBENV_ROOT=~/.rbenv RBENV_VERSION=2.2.2 ~/.rbenv/bin/rbenv exec gem install bundler
RUN cd /app && RBENV_ROOT=~/.rbenv RBENV_VERSION=2.2.2 ~/.rbenv/bin/rbenv exec bundle install --path /app/bundle --without development test --deployment --quiet

EXPOSE 8080
CMD ["/app/run_on_docker.sh"]
