require 'rspec'
require_relative 'spec_helper'
require 'webmock/rspec'

describe PushToDashboard do
  it 'Returns truthy' do
    Timecop.freeze(Time.now)
    this = {
        timestamp: DateTime.now,
        prison_jobs_today: 1,
        youth_custody_jobs_today: 1
    }
    allow(dataset.post).to receive(this) {true}
    push_to_dashboard = described_class.new ENV('DASHBOARD_KEY') 1 1
    expect(push_to_dashboard).to be_truthy
  end
end
