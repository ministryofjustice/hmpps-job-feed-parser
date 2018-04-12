require_relative '../spec_helper'

describe WcnScraper::Prison do
  before do
    stub_const('PRISONS',
      [
        { name: 'HMP Berwyn', town: 'Wrexham', lat: 53.036418, lng: -2.9292142, type: 'Youth Custody' },
        { name: 'HMP Brixton', town: 'London', lat: 51.4516617, lng: -0.1250917, type: 'Youth Custody' },
        { name: 'HMP Chelmsford', town: 'Chelmsford', lat: 51.7361324, lng: 0.4860732999999999, type: 'Youth Custody' },
        { name: 'HMP Coldingley', town: 'Woking', lat: 51.3217467, lng: -0.6432669, type: 'Youth Custody' },
        { name: 'HMP Dartmoor', town: 'Yelverton', lat: 50.5495271, lng: -3.9963275, type: 'Youth Custody' },
        { name: 'HMP Bournemouth', town: 'Bournemouth', lat: 50.5495271, lng: -3.9963275, type: 'Youth Custody' },
        { name: 'HMP Bourne', town: 'Bourne End', lat: 50.5495271, lng: -3.9963275, type: 'Youth Custody' }
      ])
  end

  describe '#new' do
    subject(:prison) do
      described_class.new(
        name: 'HMP Brixton',
        lat: 51.4516617,
        lng: -0.1250917,
        town: 'London'
      )
    end

    it 'sets the prison name' do
      expect(prison.name).to eq('HMP Brixton')
    end

    it 'sets the latitude' do
      expect(prison.lat).to eq(51.4516617)
    end

    it 'sets the longitude' do
      expect(prison.lng).to eq(-0.1250917)
    end

    it 'sets the town' do
      expect(prison.town).to eq('London')
    end
  end

  describe '#attrs' do
    subject(:prison) do
      described_class.new(name: 'HMP Brixton', lat: 51.4516617, lng: -0.1250917, town: 'London', type: 'Youth Custody')
    end

    it 'returns all attributes of the Prison' do
      expect(prison.attrs).to eq(name: 'HMP Brixton', lat: 51.4516617, lng: -0.1250917, town: 'London', type: 'Youth Custody')
    end
  end

  describe '.find' do
    context 'given a valid prison name' do
      subject(:prison) { described_class.find('HMP Brixton') }

      it 'returns a Prison instance' do
        expect(prison).to be_a(described_class)
      end

      it 'does not reuse an existing Prison instance' do
        expect(prison).not_to eq(described_class.find('HMP Brixton'))
      end

      it 'returns the correct prison' do
        expect(prison.attrs).to eq(name: 'HMP Brixton', lat: 51.4516617, lng: -0.1250917, town: 'London', type: 'Youth Custody')
      end
    end

    context 'given a non-existent prison name' do
      subject(:prison) { described_class.find('HMP Azkaban') }

      specify do
        expect { prison }.to raise_error(WcnScraper::Prison::PrisonNotFoundError, 'HMP Azkaban not found')
      end
    end
  end

  describe '.find_in_string' do
    context 'given a string containing one prison' do
      subject(:prisons) { described_class.find_in_string('201706: Prison Officer - HMP Brixton') }

      it 'returns an array of Prison instances' do
        expect(prisons).to all(be_a(described_class))
      end

      it 'returns one result' do
        expect(prisons.count).to eq(1)
      end

      it 'returns the correct prison' do
        expected_prison = { name: 'HMP Brixton', town: 'London', lat: 51.4516617, lng: -0.1250917, type: 'Youth Custody' }
        expect(prisons.first.attrs).to eq(expected_prison)
      end
    end

    context 'given a string containing two prisons' do
      subject(:prisons) { described_class.find_in_string('201706: Prison Officer - HMP Chelmsford & HMP Dartmoor') }

      it 'returns an array of Prison instances' do
        expect(prisons).to all(be_a(described_class))
      end

      it 'returns two results' do
        expect(prisons.count).to eq(2)
      end

      it 'returns the correct prisons' do
        expected_prisons = [
          { name: 'HMP Chelmsford', town: 'Chelmsford', lat: 51.7361324, lng: 0.4860732999999999, type: 'Youth Custody' },
          { name: 'HMP Dartmoor', town: 'Yelverton', lat: 50.5495271, lng: -3.9963275, type: 'Youth Custody' }
        ]
        expect(prisons.map(&:attrs)).to match_array(expected_prisons)
      end
    end

    context 'given a string containing no prisons' do
      subject(:prisons) { described_class.find_in_string('201706: Prison Officer - Something Badly Formatted') }

      specify do
        expect { prisons }.to raise_error(WcnScraper::Prison::NoPrisonsFoundError)
      end
    end
    context 'One prison name contained inside another' do
      subject(:prisons) { described_class.find_in_string('HMP Bourne') }

      specify do
        expect(prisons.count).to eq(1)
      end
    end
    context 'given a string containing two prisons, one of which has text contained in the other' do
      subject(:prisons) { described_class.find_in_string('201706: Prison Officer - HMP Bournemouth & HMP Bourne') }

      it 'returns an array of Prison instances' do
        expect(prisons).to all(be_a(described_class))
      end

      it 'returns two results' do
        expect(prisons.count).to eq(2)
      end

      it 'returns the correct prisons' do
        expected_prisons = [
          { name: 'HMP Bourne', town: 'Bourne End', lat: 50.5495271, lng: -3.9963275, type: 'Youth Custody' },
          { name: 'HMP Bournemouth', town: 'Bournemouth', lat: 50.5495271, lng: -3.9963275, type: 'Youth Custody' }
        ]
        expect(prisons.map(&:attrs)).to match_array(expected_prisons)
      end
    end
  end
end
