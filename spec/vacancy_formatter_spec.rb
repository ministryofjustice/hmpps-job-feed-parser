require_relative 'spec_helper'

describe VacancyFormatter do
  before do
    stub_const('PRISONS',
      [
        { name: 'HMP/YOI Cefereso No. 9', town: 'Sutton', lat: 51.338463, lng: -0.188044, type: 'Youth Custody' },
        { name: 'HMP/YOI Palacio de Lecumberri', town: 'Newport', lat: 50.713196, lng: -1.3076464, type: 'Youth Custody' },
        { name: 'HMP Penal del Altiplano', town: 'Huntingdon', lat: 52.2805913, lng: -0.3122374, type: 'Prison' },
        { name: 'HMP Islas Marías Federal Prison', town: 'Oakham', lat: 52.7469327, lng: -0.5821626999999999, type: 'Prison' }
      ])
  end

  describe '.output' do
    subject(:output) { described_class.output(vacancies) }

    context 'given three vacancies across four prisons' do
      let(:vacancies) do
        [
          WcnScraper::Vacancy.new(
            'https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-13/candidate/so/pm/1/pl/3/opp/9908-201706-Prison-Officer-HMP-YOI-Cefereso No. 9/en-GB',
            <<~HTML
              <div xmlns="http://www.w3.org/1999/xhtml">Vacancy Title:201706: Prison Officer - HMP/YOI Cefereso No. 9<br/>
              Vacancy Id:9908<br/>
              Role Type:Operational Delivery,prison officer<br/>
              Salary:£31,453<br/>
              Location:Sutton <br/>
              Closing Date:7 Jul 2017 23:55 BST<br/>
              </div>
            HTML
          ),
          WcnScraper::Vacancy.new(
            'https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-13/candidate/so/pm/1/pl/3/opp/14225-201711-Prison-Officer-HMP-Penal del Altiplano-HMP-Islas Marías Federal Prison/en-GB',
            <<~HTML
              <div xmlns="http://www.w3.org/1999/xhtml">Vacancy Title:201711: Prison Officer - HMP Penal del Altiplano & HMP Islas Marías Federal Prison<br/>
              Vacancy Id:14225<br/>
              Role Type:Operational Delivery,prison officer<br/>
              Salary:£22,396<br/>
              Location:Huntingdon ,Oakham <br/>
              Closing Date:30 Nov 2017 23:55 GMT<br/>
              </div>
            HTML
          ),
          WcnScraper::Vacancy.new(
            'https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-13/candidate/so/pm/1/pl/3/opp/13634-201710-Prison-Officer-HMP-YOI-Isle-of-Wight/en-GB',
            <<~HTML
              <div xmlns="http://www.w3.org/1999/xhtml">Vacancy Title:201710: Prison Officer - HMP/YOI Palacio de Lecumberri<br/>
              Vacancy Id:13634<br/>
              Role Type:Operational Delivery,prison officer<br/>
              Salary:£22,396<br/>
              Location:Newport (Palacio de Lecumberri) <br/>
              Closing Date:30 Nov 2017 23:55 GMT<br/>
              </div>
            HTML
          )
        ]
      end

      let(:formatted_vacancies) do
        [
          {
            title: '201706: Prison Officer - HMP/YOI Cefereso No. 9',
            role: 'prison-officer',
            salary: '31453',
            closing_date: '07/07/2017',
            prison_name: 'HMP/YOI Cefereso No. 9',
            prison_location: { town: 'Sutton', lat: 51.338463, lng: -0.188044 },
            url: 'https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-13/candidate/so/pm/1/pl/3/opp/9908-201706-Prison-Officer-HMP-YOI-Cefereso No. 9/en-GB',
            type: 'Youth Custody'
          },
          {
            title: '201711: Prison Officer - HMP Penal del Altiplano & HMP Islas Marías Federal Prison',
            role: 'prison-officer',
            salary: '22396',
            closing_date: '30/11/2017',
            prison_name: 'HMP Penal del Altiplano',
            prison_location: { town: 'Huntingdon', lat: 52.2805913, lng: -0.3122374 },
            url: 'https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-13/candidate/so/pm/1/pl/3/opp/14225-201711-Prison-Officer-HMP-Penal del Altiplano-HMP-Islas Marías Federal Prison/en-GB',
            type: 'Prison'
          },
          {
            title: '201711: Prison Officer - HMP Penal del Altiplano & HMP Islas Marías Federal Prison',
            role: 'prison-officer',
            salary: '22396',
            closing_date: '30/11/2017',
            prison_name: 'HMP Islas Marías Federal Prison',
            prison_location: { town: 'Oakham', lat: 52.7469327, lng: -0.5821626999999999 },
            url: 'https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-13/candidate/so/pm/1/pl/3/opp/14225-201711-Prison-Officer-HMP-Penal del Altiplano-HMP-Islas Marías Federal Prison/en-GB',
            type: 'Prison'
          },
          {
            title: '201710: Prison Officer - HMP/YOI Palacio de Lecumberri',
            role: 'prison-officer',
            salary: '22396',
            closing_date: '30/11/2017',
            prison_name: 'HMP/YOI Palacio de Lecumberri',
            prison_location: { town: 'Newport', lat: 50.713196, lng: -1.3076464 },
            url: 'https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-13/candidate/so/pm/1/pl/3/opp/13634-201710-Prison-Officer-HMP-YOI-Isle-of-Wight/en-GB',
            type: 'Youth Custody'
          }
        ]
      end

      it 'returns four results (one for each prison)' do
        expect(output.count).to eq(4)
      end

      it 'returns the correct vacancy data' do
        expect(output).to match_array(formatted_vacancies)
      end
    end
  end

  describe '.format_vacancy' do
    context 'given a vacancy in one prison' do
      subject(:formatted) { described_class.format_vacancy(vacancy) }

      let(:vacancy) do
        WcnScraper::Vacancy.new(
          'https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-13/candidate/so/pm/1/pl/3/opp/9908-201706-Prison-Officer-HMP-YOI-Cefereso No. 9/en-GB',
          <<~HTML
            <div xmlns="http://www.w3.org/1999/xhtml">Vacancy Title:201706: Prison Officer - HMP/YOI Cefereso No. 9<br/>
            Vacancy Id:9908<br/>
            Role Type:Operational Delivery,Prison Officer<br/>
            Salary:£31,453<br/>
            Location:Sutton <br/>
            Closing Date:7 Jul 2017 23:55 BST<br/>
            </div>
          HTML
        )
      end

      let(:expected_format) do
        [
          {
            title: '201706: Prison Officer - HMP/YOI Cefereso No. 9',
            role: 'prison-officer',
            salary: '31453',
            closing_date: '07/07/2017',
            prison_name: 'HMP/YOI Cefereso No. 9',
            prison_location: { town: 'Sutton', lat: 51.338463, lng: -0.188044 },
            url: 'https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-13/candidate/so/pm/1/pl/3/opp/9908-201706-Prison-Officer-HMP-YOI-Cefereso No. 9/en-GB',
            type: 'Youth Custody'
          }
        ]
      end

      it 'returns one result' do
        expect(formatted.count).to eq(1)
      end

      it 'returns results in the correct format' do
        expect(formatted).to match_array(expected_format)
      end
    end

    context 'given a vacancy in two prisons' do
      subject(:formatted) { described_class.format_vacancy(vacancy) }

      let(:vacancy) do
        WcnScraper::Vacancy.new(
          'https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-13/candidate/so/pm/1/pl/3/opp/14225-201711-Prison-Officer-HMP-Penal del Altiplano-HMP-Islas Marías Federal Prison/en-GB',
          <<~HTML
            <div xmlns="http://www.w3.org/1999/xhtml">Vacancy Title:201711: Prison Officer - HMP Penal del Altiplano & HMP Islas Marías Federal Prison<br/>
            Vacancy Id:14225<br/>
            Role Type:Operational Delivery,Prison Officer<br/>
            Salary:£22,396<br/>
            Location:Huntingdon ,Oakham <br/>
            Closing Date:30 Nov 2017 23:55 GMT<br/>
            </div>
          HTML
        )
      end

      let(:expected_format) do
        [
          {
            title: '201711: Prison Officer - HMP Penal del Altiplano & HMP Islas Marías Federal Prison',
            role: 'prison-officer',
            salary: '22396',
            closing_date: '30/11/2017',
            prison_name: 'HMP Penal del Altiplano',
            prison_location: { town: 'Huntingdon', lat: 52.2805913, lng: -0.3122374 },
            url: 'https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-13/candidate/so/pm/1/pl/3/opp/14225-201711-Prison-Officer-HMP-Penal del Altiplano-HMP-Islas Marías Federal Prison/en-GB',
            type: 'Prison'
          },
          {
            title: '201711: Prison Officer - HMP Penal del Altiplano & HMP Islas Marías Federal Prison',
            role: 'prison-officer',
            salary: '22396',
            closing_date: '30/11/2017',
            prison_name: 'HMP Islas Marías Federal Prison',
            prison_location: { town: 'Oakham', lat: 52.7469327, lng: -0.5821626999999999 },
            url: 'https://justicejobs.tal.net/vx/mobile-0/appcentre-1/brand-13/candidate/so/pm/1/pl/3/opp/14225-201711-Prison-Officer-HMP-Penal del Altiplano-HMP-Islas Marías Federal Prison/en-GB',
            type: 'Prison'
          }
        ]
      end

      it 'returns two results (one for each prison)' do
        expect(formatted.count).to eq(2)
      end

      it 'returns results in the correct format' do
        expect(formatted).to match_array(expected_format)
      end
    end
  end
end
