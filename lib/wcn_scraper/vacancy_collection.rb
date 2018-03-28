module WcnScraper
  class VacancyCollection
    attr_reader :vacancies, :invalid

    def initialize(rss_items)
      @vacancies = []
      @invalid = []

      rss_items.each do |i|
        begin
          vacancy = WcnScraper::Vacancy.new(i.id.content, i.content.content)
          # TODO: output something of the bad data
          if vacancy.bad_data
            add_invalid('Unrecognised text: ' + vacancy.bad_data, i)
          end
          add_vacancy(vacancy)
        rescue WcnScraper::Prison::NoPrisonsFoundError
          add_invalid('No Prison recognised', i)
        end
      end
    end

    private

    def add_invalid(description, rss_item)
      @invalid << {
        description: description,
        title: rss_item.title.content,
        url: rss_item.id.content
      }
    end

    def add_vacancy(vacancy)
      @vacancies << vacancy
    end
  end
end
