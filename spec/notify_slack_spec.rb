require 'rspec'
require_relative 'spec_helper'
require 'webmock/rspec'

describe NotifySlack do
  it 'Returns a 200' do
    slack_url = ENV['SLACK_URL']
    puts slack_url
    stub_request(:post, slack_url).
      to_return(status: 200, body: "", headers: {})
    notify_slack = described_class.new  slack_url, 'Job Complete', ':+1:'
    expect(notify_slack.response).to eq('200')
  end
end
