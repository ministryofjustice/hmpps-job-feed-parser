require_relative '../spec_helper'
require 'webmock/rspec'

describe WcnScraper::RssFeed do
  it 'has an ENDPOINT constant' do
    expect(described_class::ENDPOINT).not_to be_empty
  end

  it 'Loads an rss file' do
    stub_request(:any, described_class::ENDPOINT).
      to_return(body: File.open('./spec/fixtures/feed.xml'), status: 200)

    rss_feed = described_class.new
    vacancies = rss_feed.vacancies_data
    expect(vacancies.count).to eq(54)
  end
  it 'Errors for lack of connection file' do
    stub_request(:any, described_class::ENDPOINT).
      to_return(body: File.open('./spec/fixtures/feed.xml'), status: 503)
    slack_url = ENV['SLACK_URL']
    stub_request(:post, slack_url).
      to_return(status: 200, body: "", headers: {})

    rss_feed = described_class.new
    expect(rss_feed.vacancies_data).to eq('Feed is not available')
  end
end
