module Statistics::OverallReportHelper
  # returns string contains list of most active persons
  def most_active_persons(persons, count = 3)
    persons.sort_by{ |x| x[:quantity][:overall] }.reverse
           .take(count)
           .map{ |o| o[:person][:name] }
           .join(', ')
  end

  # returns string contains list of most active locations
  def most_active_locations(locations, count = 3)
    locations.sort_by{ |x| x[:quantity][:overall] }.reverse
             .take(count)
             .map{ |obj| obj[:location][:name] }
             .join(', ')
  end

  # converts overall data for chart
  def overall_chart_data(data, years)
    start  = data.first[:date].beginning_of_month
    finish = data.last[:date].end_of_month
    range  = (start..finish).select { |d| d.day == 1 }

    [range.map{ |x|
      (data.detect{ |y| y[:date].year == x.year && y[:date].month == x.month } or { quantity:0 })[:quantity]
    }].to_json
  end

  # returns list of lables for chart based on overall data
  def overall_chart_labels(data)
    months = ["янв", "фев", "мар", "апр", "май", "июн", "июл", "авг", "сен", "окт", "ноя", "дек"]
    start  = data.first[:date].beginning_of_month
    finish = data.last[:date].end_of_month
    (start..finish).select { |d| d.day == 1 }
                   .map{ |x| x.month == 1 ? x.year : months[x.month-1] }
  end
end