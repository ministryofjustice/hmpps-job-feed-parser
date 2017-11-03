require_relative '../spec_helper'

describe WcnScraper::PrisonLocator do
  describe '.find' do
    context 'happy path' do
      subject(:prison) { described_class.find('HMP Brixton') }

      specify { expect(prison).to be_a(WcnScraper::Prison) }
      specify { expect(prison.name).to eq('HMP Brixton') }
      specify { expect(prison.lat).to eq(51.4516617) }
      specify { expect(prison.lng).to eq(-0.1250917) }
    end

    context 'non-existent prison' do
      subject(:prison) { described_class.find('HMP Azkaban') }

      specify { expect { prison }.to raise_error(WcnScraper::PrisonLocator::PrisonNotFoundError) }
    end
  end
end
