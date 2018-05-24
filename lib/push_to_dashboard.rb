require 'geckoboard'
class PushToDashboard
  def initialize(prison_vacs = 0, youth_custody_vacs = 0, bad_records = 0)
    dashboard_key = ENV['DASHBOARD_KEY']
    raise 'Missing DASHBOARD_KEY' unless dashboard_key.length.positive?

    dataset.post([
                   {
                     timestamp: DateTime.now.strftime('%d/%m/%Y %H:%M'),
                     prison_jobs_today: prison_vacs,
                     youth_custody_jobs_today: youth_custody_vacs,
                     bad_records: bad_records
                   }
                 ])
  end

  def dataset
    client = Geckoboard.client(ENV['DASHBOARD_KEY'])
    raise 'Unable to authenticate with Dashboard' unless client.ping
    client.datasets.find_or_create(
      'ppj.stats', fields:
      [
        Geckoboard::StringField.new(:timestamp, name: 'Last Run'),
        Geckoboard::NumberField.new(:prison_jobs_today, name: 'Prison Jobs', optional: true),
        Geckoboard::NumberField.new(:youth_custody_jobs_today, name: 'Youth Custody Jobs', optional: true),
        Geckoboard::NumberField.new(:bad_records, name: 'Bad Records', optional: true)
    ], unique_by: [:timestamp]
    )
  end
end
