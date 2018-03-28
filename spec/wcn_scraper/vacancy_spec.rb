require_relative '../spec_helper'

describe WcnScraper::Vacancy do
  before do
    stub_const('PRISONS',
      [
        { name: 'HMP/YOI Downview', lat: 51.338463, lng: -0.188044 },
        { name: 'HMP Littlehey', lat: 52.2805913, lng: -0.3122374 },
        { name: 'HMP Stocken', lat: 52.7469327, lng: -0.5821626999999999 }
      ])
  end

  describe '#new' do
    context 'vacancy with one prison' do
      subject(:vacancy) { described_class.new(url, html) }

      let(:html) {
        <<~HTML
          <div xmlns="http://www.w3.org/1999/xhtml">Vacancy Title:201706: Prison Officer - HMP/YOI Downview<br/>
          Vacancy Id:9908<br/>
          Role Type:Operational Delivery,prison-officer<br/>
          Salary:£31,453<br/>
          Location:Sutton <br/>
          Closing Date:7 Jul 2017 23:55 BST<br/>
          </div>
        HTML
      }

      let(:url) { 'https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-13/candidate/so/pm/1/pl/3/opp/9908-201706-Prison-Officer-HMP-YOI-Downview/en-GB' }

      specify { expect(vacancy.id).to eq('9908') }
      specify { expect(vacancy.url).to eq(url) }
      specify { expect(vacancy.title).to eq('201706: Prison Officer - HMP/YOI Downview') }
      specify { expect(vacancy.role).to eq('prison-officer') }
      specify { expect(vacancy.salary).to eq('£31,453') }
      specify { expect(vacancy.prisons.count).to eq(1) }
      specify { expect(vacancy.prisons).to all(be_a(WcnScraper::Prison)) }
      specify { expect(vacancy.closing_date).to be_a(Date) }
      specify { expect(vacancy.closing_date).to eq(Date.new(2017, 7, 7)) }
      specify { expect(vacancy.bad_data).to be_falsey }
    end

    context 'vacancy with two prisons' do
      subject(:vacancy) { described_class.new(url, html) }

      let(:html) {
        <<~HTML
          <div xmlns="http://www.w3.org/1999/xhtml">Vacancy Title:201711: Prison Officer - HMP Littlehey & HMP Stocken<br/>
          Vacancy Id:14225<br/>
          Role Type:Operational Delivery,prison-officer<br/>
          Salary:£22,396<br/>
          Location:Huntingdon ,Oakham <br/>
          Closing Date:30 Nov 2017 23:55 GMT<br/>
          </div>
        HTML
      }

      let(:url) { 'https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-13/candidate/so/pm/1/pl/3/opp/14225-201711-Prison-Officer-HMP-Littlehey-HMP-Stocken/en-GB' }

      specify { expect(vacancy.id).to eq('14225') }
      specify { expect(vacancy.url).to eq(url) }
      specify { expect(vacancy.title).to eq('201711: Prison Officer - HMP Littlehey & HMP Stocken') }
      specify { expect(vacancy.role).to eq('prison-officer') }
      specify { expect(vacancy.salary).to eq('£22,396') }
      specify { expect(vacancy.prisons.count).to eq(2) }
      specify { expect(vacancy.prisons).to all(be_a(WcnScraper::Prison)) }
      specify { expect(vacancy.closing_date).to be_a(Date) }
      specify { expect(vacancy.closing_date).to eq(Date.new(2017, 11, 30)) }
    end
  end
  describe 'bad_data' do
    subject(:vacancy) { described_class.new(url, html) }

    let(:html) {
      <<~HTML
        <div xmlns="http://www.w3.org/1999/xhtml">Vacancy Title:201711: Prison Officer - HMP Littlehey & HMP Alcatraz<br/>
        Vacancy Id:14225<br/>
        Role Type:Operational Delivery,prison-officer<br/>
        Salary:£22,396<br/>
        Location:Huntingdon ,Oakham <br/>
        Closing Date:30 Nov 2017 23:55 GMT<br/>
        </div>
      HTML
    }

    let(:url) { 'https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-13/candidate/so/pm/1/pl/3/opp/14225-201711-Prison-Officer-HMP-Littlehey-HMP-Stocken/en-GB' }

    specify { expect(vacancy.bad_data).to be_truthy }
  end
end
