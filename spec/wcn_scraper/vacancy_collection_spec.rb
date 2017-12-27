require_relative '../spec_helper'

describe WcnScraper::VacancyCollection do
  let(:valid_rss_item) do
    dbl = double
    allow(dbl).to receive_message_chain('id.content') { 'http://example.com/valid' }
    allow(dbl).to receive_message_chain('title.content') { 'valid job title' }
    allow(dbl).to receive_message_chain('content.content') { 'valid job data' }
    dbl
  end

  let(:invalid_rss_item) do
    dbl = double
    allow(dbl).to receive_message_chain('id.content') { 'http://example.com/invalid' }
    allow(dbl).to receive_message_chain('title.content') { 'invalid job title' }
    allow(dbl).to receive_message_chain('content.content') { 'invalid job data' }
    dbl
  end

  let(:valid_vacancy) do
    instance_double(WcnScraper::Vacancy)
  end

  before do
    allow(WcnScraper::Vacancy).to receive(:new).with('http://example.com/valid', 'valid job data') do
      valid_vacancy
    end

    allow(WcnScraper::Vacancy).to receive(:new).with('http://example.com/invalid', 'invalid job data') do
      raise WcnScraper::Prison::NoPrisonsFoundError
    end
  end

  describe '#new' do
    subject(:collection) do
      described_class.new([valid_rss_item, invalid_rss_item])
    end

    it 'adds valid items to the `vacancies` attribute' do
      expect(collection.vacancies.count).to eq(1)
    end

    it 'initializes Vacancy objects for valid items' do
      expect(collection.vacancies).to contain_exactly(valid_vacancy)
    end

    it 'adds invalid items to the `invalid` attribute' do
      expect(collection.invalid.count).to eq(1)
    end

    it 'formats invalid vacancy data correctly' do
      expect(collection.invalid).to contain_exactly(
        title: 'invalid job title',
        url: 'http://example.com/invalid'
      )
    end
  end
end
