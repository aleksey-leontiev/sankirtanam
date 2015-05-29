class Statistics::MonthlyReportQueries < Statistics::StatisticsQueries

  def monthly_report_all_quantity(data)
    data.sum{ |x| x[:quantity][:overall] }
  end
end