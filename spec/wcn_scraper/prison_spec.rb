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
end
