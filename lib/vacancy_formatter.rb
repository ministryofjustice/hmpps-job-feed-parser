class VacancyFormatter
  def self.output(vacancies)
    output = []
    vacancies.each do |vacancy|
      output += format_vacancy(vacancy)
    end
    output
  end

  def self.format_vacancy(vacancy)
    vacancy.prisons.map do |prison|
      {
        title: vacancy.title,
        role: vacancy.role,
        salary: vacancy.salary,
        closing_date: vacancy.closing_date.strftime('%d/%m/%Y'),
        prison_name: prison.name,
        prison_location: { town: prison.town, lat: prison.lat, lng: prison.lng },
        url: vacancy.url
      }
    end
  end
end
