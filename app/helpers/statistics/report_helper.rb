module Statistics::ReportHelper
  # returns data for chart
  def chart_data(records, start: nil, finish: nil)
    #
    start_date = start  || records.min_by{|x| x[:date]}[:date].beginning_of_month
    end_date   = finish || records.max_by{|x| x[:date]}[:date].end_of_month
    range      = (start_date..end_date).select { |d| d.day == 1 }

    #
    data = records.group_by { |obj| # group by date
      obj[:date]
    }.map { |obj|  # map to { date:"", quantity:[0, 0, 0] }
      { date:     obj[0],
        quantity: obj[1].sum{ |x| x[:quantity][:overall] } }
    }.sort_by{ |x| # sort by date
      x[:date]
    }

    #
    [range.map{ |x|
      (data.detect{ |y| y[:date].year == x.year && y[:date].month == x.month } or { quantity:0 })[:quantity]
    }].to_json
  end

  # converts overall data for chart
  def monthly_chart_data(records)
    range = [1,2,3,4,5,6,7,8,9,10,11,12]

    data  = records.group_by { |obj| # group by date
      obj[:date]
    }.map { |obj|  # map to { date:"", quantity:[0, 0, 0] }
      { date:     obj[0],
        quantity: obj[1].sum{ |x| x[:quantity][:overall] } }
    }.sort_by{ |x| # sort by date
      x[:date]
    }

    [range.map{ |x|
      (data.detect{ |y| y[:date].month == x } or { quantity:0 })[:quantity]
    }].to_json
  end

  # returns list of lables for chart based on overall data
  def chart_labels(data)
    months = ["янв", "фев", "мар", "апр", "май", "июн", "июл", "авг", "сен", "окт", "ноя", "дек"]

    start_date = data.min_by{|x| x[:date]}[:date].beginning_of_month
    end_date   = data.max_by{|x| x[:date]}[:date].end_of_month
    range      = (start_date..end_date).select { |d| d.day == 1 }

    range.map{ |x| x.month == 1 ? x.year : months[x.month-1] }
  end

  # returns link to personal report
  def person_link(person_id, person_name, year: nil, month: nil)
    name = ActiveSupport::Inflector::transliterate(person_name.downcase)
      .gsub(/ /, "-").gsub(/\./, "").downcase
    if year == nil && month == nil then
      statistics_reports_personal_path(person_id, name || "???")
    else
      statistics_reports_personal_month_path(person_id, name || "???", year, month)
    end
  end
end