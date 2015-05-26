module Statistics::PersonalReportHelper
  # converts overall data for chart
  def personal_chart_data(data)
    start  = data.first[:date].beginning_of_month
    finish = data.last[:date].end_of_month
    range  = (start..finish).select { |d| d.day == 1 }

    [range.map{ |x|
      (data.detect{ |y| y[:date].year == x.year && y[:date].month == x.month } or { quantity:0 })[:quantity]
    }].to_json
  end

  # returns list of lables for chart based on overall data
  def personal_chart_labels(data)
    months = ["янв", "фев", "мар", "апр", "май", "июн", "июл", "авг", "сен", "окт", "ноя", "дек"]
    start  = data.first[:date].beginning_of_month
    finish = data.last[:date].end_of_month
    (start..finish).select { |d| d.day == 1 }
                   .map{ |x| x.month == 1 ? x.year : months[x.month-1] }
  end
end