FROM ruby:3.1.2

RUN  apt-get update \
     && apt-get install -y curl \
     && apt-get install -y nginx \
     && apt-get install -y default-libmysqlclient-dev \
     && apt-get install -y nodejs \
     && apt-get install -y lsof \
     && apt-get install -y yarn \
     && apt-get install -y vim

WORKDIR /home/app
ADD Gemfile* /home/app/
RUN bundle install
ADD . /home/app/

EXPOSE 3000
