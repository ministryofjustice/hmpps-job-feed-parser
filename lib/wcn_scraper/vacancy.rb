require 'date'

module WcnScraper
  class Vacancy
    attr_reader :closing_date,
      :id,
      :prisons,
      :role,
      :salary,
      :title,
      :url

    def initialize(url, html)
      @html = html
      @closing_date = the_closing_date
      @id = the_id
      @prisons = the_prisons
      @role = 'prison-officer' # hardcoded until other roles are introduced
      @salary = the_salary
      @title = the_title
      @url = url
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
  end
end
