require_relative '../spec_helper'
require 'webmock/rspec'

describe WcnScraper::RssFeed do
  it 'has an ENDPOINT constant' do
    expect(described_class::ENDPOINT).not_to be_empty
  end

  it 'should load an rss file' do
    stub_request(:any, described_class::ENDPOINT).
      to_return(body: File.open('./spec/fixtures/feed.xml'), status: 200)

    rss_feed = WcnScraper::RssFeed.new()
    vacancies = rss_feed.get_vacancies_data
    expect(vacancies.count).to eq(54)
  end
end
