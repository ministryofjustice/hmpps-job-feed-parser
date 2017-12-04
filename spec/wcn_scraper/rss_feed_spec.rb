require_relative '../spec_helper'

describe WcnScraper::RssFeed do
  it 'has an ENDPOINT constant' do
    expect(described_class::ENDPOINT).not_to be_empty
  end

  before do
    stub_const('WcnScraper::RssFeed::ENDPOINT', 'http://example.com')
    allow(Net::HTTP).to receive(:get)
  end

  describe '#new' do
    it 'should parse the ENDPOINT URI' do
      expect(URI).to receive(:parse).with('http://example.com').and_return(double.as_null_object)
      described_class.new
    end

    it 'should fetch the parsed ENDPOINT URI' do
      expect(URI).to receive(:parse).and_return(instance_double(URI::HTTP))
      expect(Net::HTTP).to receive(:get).and_return(double)
      described_class.new
    end
  end
end
