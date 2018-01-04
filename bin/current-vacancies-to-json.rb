#!/usr/bin/env ruby

require 'yaml'
require 'rss'
require 'pp'
require_relative '../lib/wcn_scraper'

RSS_URL = 'https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-2/candidate/jobboard/vacancy/3/feed'

PRISONS = YAML.load_file('data/prisons.yaml')

def main
  feed = get_rss_content
  vacancies = filter_feed_items(feed, /prison.officer/i)
  collection = WcnScraper::VacancyCollection.new(vacancies)
  # collection.vacancies is an array of Vacancy objects (for valid vacancies)
  # collection.invalid is an array of vacancies without a matching prison
end

def get_rss_content
  rss = Net::HTTP.get(URI.parse(RSS_URL))
  # rss = File.open('feed.xml')
  RSS::Parser.parse(rss)
end

def filter_feed_items(rss_feed, regexp)
  rss_feed.items.find_all do |item|
    !regexp.match(item.title.content).nil?
  end
end

main
