#!/usr/bin/env ruby

require 'yaml'
require 'rss'
require 'pp'
require_relative '../lib/wcn_scraper'
require 'json'
require_relative '../lib/vacancy_formatter'
require 'logger'
require 'aws-sdk-s3'

RSS_URL = 'https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-2/candidate/jobboard/vacancy/3/feed'

PRISONS = YAML.load_file('data/prisons.yaml')

def main
  # feed = get_rss_content
  # vacancies = filter_feed_items(feed, /prison.officer/i)
  rssfeed = WcnScraper::RssFeed.new
  vacancies = rssfeed.vacancies_data
  exit unless vacancies != 'Feed is not available'
  collection = WcnScraper::VacancyCollection.new(vacancies)
  bad_data_to_file(collection.invalid)
  good_data_to_file(collection.vacancies, 'good-data.json', 'Prison')
  good_data_to_file(collection.vacancies, 'good-youth-custody-data.json', 'Youth Custody')
  write_data_to_s3
  logger = Logger.new(STDOUT)
  logger.info("good data size: %p" % collection.vacancies.size)
  logger.info("bad data size: %p" % collection.invalid.size)
  # collection.vacancies is an array of Vacancy objects (for valid vacancies)
  # collection.invalid is an array of vacancies without a matching prison
  report_success(formatted_vacancies, collection.invalid.size)
end

def get_rss_content
  rss = Net::HTTP.get(URI.parse(RSS_URL))
  # xrss = File.open('feed.xml')
  RSS::Parser.parse(rss)
end

def filter_feed_items(rss_feed, regexp)
  rss_feed.items.find_all do |item|
    !regexp.match(item.title.content).nil?
  end
end
def good_data_to_file(list, file_name, filter)
  formatted_vacancies = VacancyFormatter.output(list)
  File.open(file_name, 'w') do |file|
    file.write(filtered_vacancies(formatted_vacancies, filter).to_json)
  end
end
def bad_data_to_file(list)
  File.open('bad-data.json', 'w') do |file|
    file.write(list.to_json)
  end
end
def write_data_to_s3
  s3 = Aws::S3::Resource.new(region:'eu-west-2')
  obj = s3.bucket('hmpps-feed-parser').object('vacancies.json')
  obj.upload_file('good-data.json')
  obj = s3.bucket('hmpps-feed-parser').object('youth-custody-vacancies.json')
  obj.upload_file('good-youth-custody-data.json')
  obj = s3.bucket('hmpps-feed-parser').object('vacancies-bad-data.json')
  obj.upload_file('bad-data.json')
end
def filtered_vacancies(formatted_vacancies, filter)
  if filter == 'Youth Custody'
    formatted_vacancies.select {|v| v[:type] == filter}
  else
    formatted_vacancies
  end
end
def count_vacancies(formatted_vacancies, filter)
  if filter == 'Youth Custody'
    formatted_vacancies.count {|v| v[:type] == filter}
  else
    formatted_vacancies.count
  end
end
def report_success(formatted_vacancies, bad_record_count)
  message = 'Job Feed succeeded\n'
  message += "Prison Officer: #{count_vacancies(formatted_vacancies, 'Prison')}\n"
  message += "Youth Custody: #{count_vacancies(formatted_vacancies, 'Youth Custody')}\n"
  message += "Bad data: #{bad_record_count}\n" unless bad_record_count == 0
  message += "Link to unrecognised data:\nhttps://s3.eu-west-2.amazonaws.com/hmpps-feed-parser/unidentified-prison-names.html" unless bad_record_count == 0
  notify_slack = NotifySlack.new  ENV['SLACK_URL'], message, ENV['SLACK_AVATAR']
end
main
