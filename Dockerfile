FROM ruby:2.4
WORKDIR /app
COPY . /app
RUN bundle install
CMD ["/usr/local/bin/ruby", "bin/current-vacancies-to-json.rb"]


