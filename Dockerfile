FROM ruby:2.7

# RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile ./
RUN bundle install

CMD ["/bin/sh"]