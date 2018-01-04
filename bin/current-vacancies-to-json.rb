#!/usr/bin/env ruby

require 'yaml'
require 'rss'
require 'pp'
require_relative '../lib/wcn_scraper'
require 'json'
require_relative '../lib/vacancy_formatter'

RSS_URL = 'https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-2/candidate/jobboard/vacancy/3/feed'

PRISONS = YAML.load_file('data/prisons.yaml')

def main
  feed = get_rss_content
  vacancies = filter_feed_items(feed, /prison.officer/i)
  collection = WcnScraper::VacancyCollection.new(vacancies)
  bad_data_to_file(collection.invalid)
  good_data_to_file(collection.vacancies)
  # collection.vacancies is an array of Vacancy objects (for valid vacancies)
  # collection.invalid is an array of vacancies without a matching prison
end

def get_rss_content
  # rss = Net::HTTP.get(URI.parse(RSS_URL))
  rss = File.open('feed.xml')
  RSS::Parser.parse(rss)
end

def filter_feed_items(rss_feed, regexp)
  rss_feed.items.find_all do |item|
    !regexp.match(item.title.content).nil?
  end
end
def good_data_to_file(list)
  formatted_vacancies = VacancyFormatter.output(list)
  File.open('good-data.json', 'w') do |file|
    file.write(formatted_vacancies.to_json)
  end
end
def bad_data_to_file(list)
  File.open('bad-data.json', 'w') do |file|
    file.write(list.to_json)
  end
end
def write_data_to_s3
  s3 = AWS::S3.new(
      :access_key_id => 'YOUR_ACCESS_KEY_ID',
      :secret_access_key => 'YOUR_SECRET_ACCESS_KEY')

  bucket = s3.buckets['my-s3-bucket-key']

  object = bucket.objects[file_name]

  object.write(Pathname.new(local_file_path))
end
main
