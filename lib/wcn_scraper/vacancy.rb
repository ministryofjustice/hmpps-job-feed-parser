require 'date'

module WcnScraper
  class Vacancy
    attr_reader :closing_date, :id, :prisons, :role, :salary, :title, :url, :bad_data

    def initialize(url, html)
      @html = html
      @closing_date = the_closing_date
      @id = the_id
      @prisons = the_prisons
      @role = 'prison-officer' # hardcoded until other roles are introduced
      @salary = the_salary
      @title = the_title
      @url = url
      @bad_data = bad_data?
    end

    private

    def the_id
      get_string('Vacancy Id')
    end

    def the_title
      get_string('Vacancy Title')
    end

    def the_salary
      get_string('Salary')
    end

    def the_prisons
      Prison.find_in_string(the_title)
    end

    def the_closing_date
      date = get_string('Closing Date').sub(/ \d\d:\d\d \w\w\w/, '')
      Date.parse(date)
    end

    def get_string(label)
      regexp = /#{label}:([^\<]+)/i
      regexp.match(@html)[1].strip
    end

    def bad_data?
      # Prove that only valid prisons and standard text is included in the title
      # Remove boilerplate text
      boilerplate = 'Prison Officer - '
      purported_prisons = the_title.partition(boilerplate).last
      known_prisons = PRISONS.select { |p| purported_prisons.include? p[:name] }
      # Take out the prisons that we know of
      known_prisons.each do |site|
        prison_name = site[:name]
        purported_prisons[prison_name] = ''
      end
      # Remove known cruft or return unknown texts
      if purported_prisons.tr('and ,-/&+()', '') == '' || purported_prisons == ''
        false
      else
        purported_prisons
      end
    end
  end
end
