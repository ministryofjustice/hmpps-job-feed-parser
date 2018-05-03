require 'net/http'
require 'rss'

module WcnScraper
  class RssFeed
    ENDPOINT = 'https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-2/candidate/jobboard/vacancy/3/feed'.freeze

    def vacancies_data
      url = URI.parse(ENDPOINT)
      response = Net::HTTP.get_response(URI(url))

      case response
      when Net::HTTPSuccess then
        rss = Net::HTTP.get(url)
        rss = rss_content rss
        filter_feed_items(rss, /prison.officer/i)
      else
        NotifySlack.new ENV['SLACK_URL'], "Failed to get WCN data \n Responded with #{response.code}" ':ppjfeednotok:'
      end
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
