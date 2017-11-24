require_relative '../spec_helper'

describe WcnScraper::Vacancy do
  let(:html) {
    <<~HTML
      <div xmlns="http://www.w3.org/1999/xhtml">Vacancy Title:201706: Prison Officer - HMP/YOI Downview<br/>
      Vacancy Id:9908<br/>
      Role Type:Operational Delivery,Prison Officer<br/>
      Salary:£31,453<br/>
      Location:Sutton <br/>
      Closing Date:7 Jul 2017 23:55 BST<br/>
      </div>
    HTML
  }

  let(:url) { 'https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-13/candidate/so/pm/1/pl/3/opp/9908-201706-Prison-Officer-HMP-YOI-Downview/en-GB' }

  before do
    PRISONS = [
      { name: 'HMP/YOI Downview', lat: 51.338463, lng: -0.188044 }
    ].freeze
  end

  describe '#new' do
    subject(:vacancy) { described_class.new(url, html) }

    specify { expect(vacancy.id).to eq('9908') }
    specify { expect(vacancy.url).to eq(url) }
    specify { expect(vacancy.title).to eq('201706: Prison Officer - HMP/YOI Downview') }
    specify { expect(vacancy.role).to eq('prison-officer') }
    specify { expect(vacancy.salary).to eq('£31,453') }
    specify { expect(vacancy.prisons).to all(be_a(WcnScraper::Prison)) }
    specify { expect(vacancy.closing_date).to eq(Date.new(2017, 7, 7)) }
  end
end
