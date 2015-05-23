module Statistics::ReportsHelper
  def most_active_persons(persons, count = 3)
    persons.sort_by{ |x| :quantity }
           .take(count)
           .map{ |o| o[:name] }
           .join(', ')
  end

  def most_active_locations(locations, count = 3)
    locations.sort_by{ |x| :quantity }
             .take(count)
             .map{ |obj| obj[:location_name] }
             .join(', ')
  end

  def chart_labels(data)
    data.map { |obj| if obj[:month] == "01" then obj[:year] else " " end }.to_json
  end

  def chart_data(data)
    data.map { |obj| obj[:quantity] }.to_json
  end

  def overall_chart_data(data)
    labels = [0] * 12 * 4
    [labels.each_with_index.map {
      |o,i| (data.detect{ |x| (x[:month].to_i == i%12) && (x[:year].to_i == i/12+2013)} or {quantity:0})[:quantity]
    }].to_json
  end

  def overall_chart_labels()
    m = ["я", "ф", "м", "а", "м", "и", "и", "а", "с", "о", "н", "д"]
    labels = [0] * 12 * 4
    labels.each_with_index.map {
      |o,i| i%12 == 0 ? i/12+2013 : m[i%12]
    }.to_json
  end

  def padright(a, n, x)
    a.dup.fill(x, a.length...n)
  end
end
