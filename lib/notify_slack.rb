require 'net/http'
require 'uri'

class NotifySlack
  attr_reader :target, :message, :icon_emoji, :response
  def initialize (target = 'Slack URL hook', message = 'Test Message', icon_emoji = ':ghost:')
    @target = target
    @message = message
    @icon_emoji = icon_emoji
    @response = post_it.code
  end

  private

  def post_it
    raise 'Missing SLACK_URL' unless @target.length.positive?
    uri = URI.parse(@target)
    request = Net::HTTP::Post.new(uri)
    request.body = "payload={\"text\": \"#{@message}\", \"icon_emoji\": \"#{@icon_emoji}\"}"
    req_options = {
      use_ssl: uri.scheme == 'https'
    }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) { |http|
      http.request(request)
    }
  end
end