require_relative '../spec_helper'
require 'webmock/rspec'

ENDPOINT = 'https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-2/candidate/jobboard/vacancy/3/feed'.freeze
PRISONS = YAML.load_file('data/prisons.yaml')

describe WcnScraper::VacancyCollection do
  describe '#new' do
    let(:collection) do
      stub_request(:any, ENDPOINT).
        to_return(body: File.open('./spec/fixtures/simplefeed.xml'), status: 200)

      rss_feed = WcnScraper::RssFeed.new
      vacancies = rss_feed.vacancies_data
      puts vacancies
      described_class.new(vacancies)
    end

    it 'adds valid items to the `vacancies` attribute' do
      expect(collection.vacancies.count).to eq(2)
    end

    it 'initializes Vacancy objects for valid items' do
      expect(collection.vacancies.first.title).to include('Cookham')
    end

    it 'adds invalid items to the `invalid` attribute' do
      expect(collection.invalid.count).to eq(2)
    end

    it 'formats invalid vacancy data correctly' do
      expect(collection.invalid.first.to_s).to include('Alcatraz')
    end
  end
end
