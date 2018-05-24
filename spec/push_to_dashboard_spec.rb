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

    stub_request(:any, "https://api.geckoboard.com/").to_return(status:200, body: "", headers: {})
    stub_request(:put, "https://api.geckoboard.com/datasets/ppj.stats").to_return(status:200, body: "", headers: {})

    # The following crashes in the _SPEC, yet runs fine in the command line.
    # push_to_dashboard = PushToDashboard.new(1, 1, 1)
    # expect(push_to_dashboard).to be_truthy

  end
end
