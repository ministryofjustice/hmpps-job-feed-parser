require 'date'

module WcnScraper
  class Vacancy
    attr_reader :url, :role

    def initialize(url, html)
      @url = url
      @html = html
      @role = 'prison-officer' # hardcoded until other roles are introduced
    end

    def id
      @id ||= get_string('Vacancy Id')
    end

    def title
      @title ||= get_string('Vacancy Title')
    end

    def salary
      @salary ||= get_string('Salary')
    end

    def prisons
      @prisons ||= Prison.find_in_string(title)
    end

    def closing_date
      @closing_date ||= begin
        date = get_string('Closing Date').sub(/ \d\d:\d\d \w\w\w/, '')
        Date.parse(date)
      end
    end

    private

    def get_string(label)
      regexp = /#{label}:([^\<]+)/i
      regexp.match(@html)[1].strip
    end
  end
end
