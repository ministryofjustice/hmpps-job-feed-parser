require 'net/http'
require 'rss'

module WcnScraper
  class RssFeed
    ENDPOINT = 'https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-2/candidate/jobboard/vacancy/3/feed'

    def get_vacancies_data
      url= URI.parse(ENDPOINT)
      rss = Net::HTTP.get(url)
      rss = get_rss_content rss
      list = filter_feed_items(rss,/prison.officer/i)
    end

    def get_rss_content(url)
      RSS::Parser.parse(url)
    end

    def filter_feed_items(rss_feed, regexp)
      rss_feed.items.find_all do |item|
        !regexp.match(item.title.content).nil?
      end
    end
  end
end
