module WcnScraper
  class VacancyCollection
    attr_reader :vacancies, :invalid

    def initialize(rss_items)
      @vacancies = []
      @invalid = []

      rss_items.each do |i|
        begin
          vacancy = add_vacancy(WcnScraper::Vacancy.new(i.id.content, i.content.content))
          add_invalid(i) unless vacancy.good_title
        rescue WcnScraper::Prison::NoPrisonsFoundError
          add_invalid(i)
        end
      end
    end

    private

    def add_invalid(rss_item)
      @invalid << {
        title: rss_item.title.content,
        url: rss_item.id.content
      }
    end

    def add_vacancy(vacancy)
      @vacancies << vacancy
    end
  end
end
