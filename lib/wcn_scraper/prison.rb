module WcnScraper
  class Prison
    class PrisonNotFoundError < StandardError
    end

    class NoPrisonsFoundError < StandardError
    end

    def self.find(prison_name)
      prison = PRISONS.find { |p| p[:name] == prison_name }
      raise self::PrisonNotFoundError, "#{prison_name} not found" if prison.nil?
      Prison.new(prison)
    end

    def self.find_in_string(string)
      matches = PRISONS.select { |p| string.include? p[:name] }
      raise self::NoPrisonsFoundError if matches.empty?
      matches.map { |p| Prison.new(p) }
    end

    attr_reader :name, :lat, :lng, :town

    def initialize(params)
      @name = params[:name]
      @lat = params[:lat]
      @lng = params[:lng]
      @town = params[:town]
    end

    def attrs
      {
        name: @name,
        lat: @lat,
        lng: @lng,
        town: @town
      }
    end
  end
end
