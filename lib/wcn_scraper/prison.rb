module WcnScraper
  class Prison
    class PrisonNotFoundError < StandardError
    end

    def self.find(prison_name)
      prison = PRISONS.find { |p| p[:name] == prison_name }
      raise self::PrisonNotFoundError, "#{prison_name} not found" if prison.nil?
      Prison.new(prison)
    end

    attr_reader :name, :lat, :lng

    def initialize(params)
      @name = params[:name]
      @lat = params[:lat]
      @lng = params[:lng]
    end
  end
end
