#!/usr/bin/env ruby

# This script takes a list of prison names and uses the Google geocoding API
# to find a town name, latitude and longitude for them.
#
# Usage:
#   1. Populate `data/prisons.txt` with a list of prison names.
#   2. Set environment variable GOOGLE_MAPS_API_KEY
#        export GOOGLE_MAPS_API_KEY=""
#   3. Run this script from the main project directory:
#        ruby bin/geocode-prisons.rb
#   4. Assuming the script completes without errors, the geocoded data
#      will be written to `data/prisons.yaml`
#
# Be aware that data from Google may not be completely accurate. Use this data
# as a kick-starter, but expect errors.
#
# NB: You will need a valid GOOGLE_MAPS_API_KEY in the environment.

require 'net/http'
require 'cgi'
require 'uri'
require 'json'
require 'yaml'

# https://developers.google.com/maps/documentation/geocoding/intro#BYB
API_KEY = ENV.fetch("GOOGLE_MAPS_API_KEY")
URL_TEMPLATE = 'https://maps.googleapis.com/maps/api/geocode/json?address=%s&key=' + API_KEY

prisons = File.readlines('data/prisons.txt').map!(&:strip)

def geocode(name)
  sleep 0.1  # don't exceed the usage quota for the google api
  url = URL_TEMPLATE % CGI.escape(name + ', UK')
  json = Net::HTTP.get(URI.parse(url))
  response = JSON.parse(json)
  raise StandardError unless response['status'] == 'OK'
  response['results'].first
end

prisons.map! do |prison|
  puts prison
  results = geocode(prison.gsub(' & YOI', ''))

  town = results['address_components'].find { |c| c['types'].include? 'postal_town' }['long_name']
  lat = results['geometry']['location']['lat']
  lng = results['geometry']['location']['lng']

  {
    name: prison,
    town: town,
    lat: lat,
    lng: lng
  }
end

File.open('data/prisons.yaml', 'w') { |f| f.write prisons.to_yaml }
