module Statistics::ReportsHelper
  def three_most_active_persons(persons)
    persons.take(3).map{ |o| o[:name] }.join(', ')
  end

  def three_most_active_locations(locations)
    locations.take(3).map{ |obj| obj[:location] }.join(', ')
  end

  def overall_chart_labels(data)
    data.map { |obj| if obj[:month] == "01" then obj[:year] else " " end }
  end

  def overall_chart_data(data)
    data.map { |obj| obj[:quantity] }
  end
end
