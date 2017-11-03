module WcnScraper
  class Prison
    attr_reader :name, :lat, :lng

    def initialize(params)
      @name = params[:name]
      @lat = params[:lat]
      @lng = params[:lng]
    end
  end
end
