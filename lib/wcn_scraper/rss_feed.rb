require 'net/http'
require 'rss'

module WcnScraper
  class RssFeed
    ENDPOINT = 'https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-2/candidate/jobboard/vacancy/3/feed'

    def vacancies_data
      url = URI.parse(ENDPOINT)
      rss = Net::HTTP.get(url)
      rss = rss_content rss
      filter_feed_items(rss, /prison.officer/i)
    end

    def rss_content(url)
      RSS::Parser.parse(url)
    end

    def filter_feed_items(rss_feed, regexp)
      rss_feed.items.find_all do |item|
        !regexp.match(item.title.content).nil?
      end
    end
  end
end
