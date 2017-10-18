#!/usr/bin/env ruby

require 'rss'
require 'csv'

def main
  feed = get_rss_content

  ['prison officer', 'probation officer', 'probation service officer'].each do |type|
    vacancies = get_vacancies(feed, /#{type}/i)
    to_csv(type, vacancies)
  end
end

def get_rss_content
  rss = File.read('feed.xml')
  RSS::Parser.parse(rss)
end

def get_vacancies(rss_feed, regexp)
  rss_feed.items.find_all do |item|
    !regexp.match(item.title.content).nil?
  end
end

def to_csv(type, vacancies)
  CSV.open("#{type}.csv", 'w') do |csv|
    vacancies.each do |vacancy|
      row = [
          vacancy.title.content,
          vacancy.id.base
      ]

      row += vacancy.content.content.gsub(/<[^>]*>/ui,'').split("\n")

      csv << row
    end
  end
end

main
