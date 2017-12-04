require 'net/http'
require 'rss'

module WcnScraper
  class RssFeed
    ENDPOINT = 'hahah'

    def initialize
      uri = URI.parse(ENDPOINT)
      Net::HTTP.get(uri)
    end
  end
end
