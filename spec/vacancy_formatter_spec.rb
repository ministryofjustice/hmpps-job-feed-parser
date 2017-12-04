require_relative 'spec_helper'

describe VacancyFormatter do
  before do
    stub_const('PRISONS', [
        { name: 'HMP/YOI Downview', lat: 51.338463, lng: -0.188044 },
        { name: 'HMP/YOI Isle of Wight', lat: 50.713196, lng: -1.3076464 },
        { name: 'HMP Littlehey', lat: 52.2805913, lng: -0.3122374 },
        { name: 'HMP Stocken', lat: 52.7469327, lng: -0.5821626999999999 }
    ])
  end

  let(:vacancies) {
    [
      WcnScraper::Vacancy.new(
        'https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-13/candidate/so/pm/1/pl/3/opp/9908-201706-Prison-Officer-HMP-YOI-Downview/en-GB',
        <<~HTML
          <div xmlns="http://www.w3.org/1999/xhtml">Vacancy Title:201706: Prison Officer - HMP/YOI Downview<br/>
          Vacancy Id:9908<br/>
          Role Type:Operational Delivery,Prison Officer<br/>
          Salary:£31,453<br/>
          Location:Sutton <br/>
          Closing Date:7 Jul 2017 23:55 BST<br/>
          </div>
        HTML
      ),
      WcnScraper::Vacancy.new(
        'https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-13/candidate/so/pm/1/pl/3/opp/14225-201711-Prison-Officer-HMP-Littlehey-HMP-Stocken/en-GB',
        <<~HTML
          <div xmlns="http://www.w3.org/1999/xhtml">Vacancy Title:201711: Prison Officer - HMP Littlehey & HMP Stocken<br/>
          Vacancy Id:14225<br/>
          Role Type:Operational Delivery,Prison Officer<br/>
          Salary:£22,396<br/>
          Location:Huntingdon ,Oakham <br/>
          Closing Date:30 Nov 2017 23:55 GMT<br/>
          </div>
        HTML
      ),
      WcnScraper::Vacancy.new(
        'https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-13/candidate/so/pm/1/pl/3/opp/13634-201710-Prison-Officer-HMP-YOI-Isle-of-Wight/en-GB',
        <<~HTML
          <div xmlns="http://www.w3.org/1999/xhtml">Vacancy Title:201710: Prison Officer - HMP/YOI Isle of Wight<br/>
          Vacancy Id:13634<br/>
          Role Type:Operational Delivery,Prison Officer<br/>
          Salary:£22,396<br/>
          Location:Newport (Isle of Wight) <br/>
          Closing Date:30 Nov 2017 23:55 GMT<br/>
          </div>
        HTML
      )
    ]
  }

  let(:formatted_vacancies) {
    [
      {
        title: '201706: Prison Officer - HMP/YOI Downview',
        salary: '£31,453',
        closing_date: '07/07/2017',
        prison_name: 'HMP/YOI Downview',
        prison_location: { lat: 51.338463, lng: -0.188044 },
        url: 'https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-13/candidate/so/pm/1/pl/3/opp/9908-201706-Prison-Officer-HMP-YOI-Downview/en-GB'
      },
      {
        title: '201711: Prison Officer - HMP Littlehey & HMP Stocken',
        salary: '£22,396',
        closing_date: '30/11/2017',
        prison_name: 'HMP Littlehey',
        prison_location: { lat: 52.2805913, lng: -0.3122374 },
        url: 'https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-13/candidate/so/pm/1/pl/3/opp/14225-201711-Prison-Officer-HMP-Littlehey-HMP-Stocken/en-GB'
      },
      {
        title: '201711: Prison Officer - HMP Littlehey & HMP Stocken',
        salary: '£22,396',
        closing_date: '30/11/2017',
        prison_name: 'HMP Stocken',
        prison_location: { lat: 52.7469327, lng: -0.5821626999999999 },
        url: 'https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-13/candidate/so/pm/1/pl/3/opp/14225-201711-Prison-Officer-HMP-Littlehey-HMP-Stocken/en-GB'
      },
      {
        title: '201710: Prison Officer - HMP/YOI Isle of Wight',
        salary: '£22,396',
        closing_date: '30/11/2017',
        prison_name: 'HMP/YOI Isle of Wight',
        prison_location: { lat: 50.713196, lng: -1.3076464 },
        url: 'https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-13/candidate/so/pm/1/pl/3/opp/13634-201710-Prison-Officer-HMP-YOI-Isle-of-Wight/en-GB'
      }
    ]
  }

  describe '.output' do
    subject(:output) { described_class.output(vacancies) }

    specify { expect(output.count).to eq(4) }
    specify { expect(output).to match_array(formatted_vacancies) }
  end

  describe '.format_vacancy' do
    context 'vacancy in one prison' do
      subject(:formatted) { described_class.format_vacancy(vacancies.first) }

      specify { expect(formatted.count).to eq(1) }
      specify { expect(formatted).to match_array([formatted_vacancies.first]) }
    end

    context 'vacancy in two prisons' do
      subject(:formatted) { described_class.format_vacancy(vacancies.at(1)) }

      specify { expect(formatted.count).to eq(2) }
      specify { expect(formatted).to match_array([formatted_vacancies.at(1), formatted_vacancies.at(2)]) }
    end
  end
end
