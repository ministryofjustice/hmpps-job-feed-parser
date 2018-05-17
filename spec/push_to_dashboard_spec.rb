require 'date'
require 'rspec'
require_relative 'spec_helper'
require 'webmock/rspec'
require 'timecop'
require 'geckoboard'

describe PushToDashboard do
  before do
    Timecop.freeze
  end

  it 'Returns truthy' do
    this = {
      timestamp: Time.now,
      prison_jobs_today: 1,
      youth_custody_jobs_today: 1
    }
#    allow(described_class.dataset.post).to receive(this).and_return(true)
    push_to_dashboard = described_class.new('a key', 1, 1)
    allow(described_class.dataset.post).to receive(this).and_return(true)
    expect(push_to_dashboard).to be_truthy
  end
end
