#!/usr/bin/env ruby

require 'yaml'
require 'rss'
require_relative '../lib/wcn_scraper'

RSS_URL = 'https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-2/candidate/jobboard/vacancy/3/feed'

PRISONS = YAML.load_file('data/prisons.yaml')

def main
  feed = get_rss_content
  vacancies = filter_feed_items(feed, /prison.officer/i)
  vacancies += filter_feed_items(feed, /probation.officer/i)
  vacancies += filter_feed_items(feed, /probation.service.officer/i)
  output_vacancies vacancies
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

def output_vacancies(vacancies)
  list = vacancies.collect do |vacancy|
    WcnScraper::Vacancy.new(vacancy.id.base, vacancy.content.content).attrs()
  end
  # puts list.to_json
  pp list
end

main
