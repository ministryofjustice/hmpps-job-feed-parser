require_relative '../spec_helper'

describe WcnScraper::Prison do
  describe '#new' do
    subject(:prison) do
      described_class.new name: 'HMP Brixton',
                          lat: 51.4516617,
                          lng: -0.1250917
    end

    specify { expect(prison.name).to eq('HMP Brixton') }
    specify { expect(prison.lat).to eq(51.4516617) }
    specify { expect(prison.lng).to eq(-0.1250917) }
  end

  describe '.find' do
    before do
      PRISONS = [
        { name: 'HMP Berwyn', lat: 53.036418, lng: -2.9292142 },
        { name: 'HMP Brixton', lat: 51.4516617, lng: -0.1250917 },
        { name: 'HMP Chelmsford', lat: 51.7361324, lng: 0.4860732999999999 },
        { name: 'HMP Coldingley', lat: 51.3217467, lng: -0.6432669 },
        { name: 'HMP Dartmoor', lat: 50.5495271, lng: -3.9963275 }
      ].freeze
    end

    context 'happy path' do
      subject(:prison) { described_class.find('HMP Brixton') }

      specify { expect(prison).to be_a(described_class) }
      specify { expect(prison.name).to eq('HMP Brixton') }
      specify { expect(prison.lat).to eq(51.4516617) }
      specify { expect(prison.lng).to eq(-0.1250917) }
    end

    context 'non-existent prison' do
      subject(:prison) { described_class.find('HMP Azkaban') }

      specify { expect { prison }.to raise_error(WcnScraper::Prison::PrisonNotFoundError, 'HMP Azkaban not found') }
    end
  end
end
