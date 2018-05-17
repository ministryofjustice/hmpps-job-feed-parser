require 'geckoboard'
class PushToDashboard
  def initialize(dashboard_key = '', prison_vacs = 0, youth_custody_vacs = 0)
    raise 'Missing DASHBOARD_KEY' unless dashboard_key.length.positive?
    client = Geckoboard.client(ENV['DASHBOARD_KEY'])
    raise 'Unable to authenticate with Dashboard' unless client.ping
    # dataset = client.datasets.find_or_create(
    #   'ppj.stats', fields:
    #   [
    #     Geckoboard::DateTimeField.new(:timestamp, name: 'CompletedAt'),
    #     Geckoboard::NumberField.new(:prison_jobs_today, name: 'PrisonJobs', optional: true),
    #     Geckoboard::NumberField.new(:youth_custody_jobs_today, name: 'YouthCustodyJobs', optional: true)
    #   ], unique_by: [:timestamp]
    # )
    dataset.post([
                   {
                     timestamp: Time.now,
                     prison_jobs_today: prison_vacs,
                     youth_custody_jobs_today: youth_custody_vacs
                   }
                 ])
  end

  def dataset
    client.datasets.find_or_create(
      'ppj.stats', fields:
      [
        Geckoboard::DateTimeField.new(:timestamp, name: 'CompletedAt'),
        Geckoboard::NumberField.new(:prison_jobs_today, name: 'PrisonJobs', optional: true),
        Geckoboard::NumberField.new(:youth_custody_jobs_today, name: 'YouthCustodyJobs', optional: true)
      ], unique_by: [:timestamp]
    )
  end
end
