#!/usr/bin/env ruby

require_relative '../lib/../lib/notify_slack'
require 'logger'

def main
  response = NotifySlack.new()
  logger = Logger.new(STDOUT)
  logger.info("Response: %p" % response)
end

main
