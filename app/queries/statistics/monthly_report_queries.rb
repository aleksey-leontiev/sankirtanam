module Statistics::MonthlyReportQueries
  #
  def monthly_report_persons_data(year, month, location_id)
     ActiveRecord::Base.connection.execute(
      "select huge+big+medium+small as quantity, p.name, p.id as person_id, r.huge, r.big, r.medium, r.small from statistic_records r " +
      "inner join statistic_reports rpt on rpt.id = r.statistic_report_id " +
      "inner join people    p on r.person_id   = p.id " +
      "where strftime('%Y', date) = '#{year}' and rpt.location_id = '#{location_id}' and strftime('%m', date)='#{month}' " +
      "order by quantity desc"
    ).map { |obj|
      { name: obj["name"], quantity: obj["quantity"], huge: obj["huge"], big: obj["big"], medium: obj["medium"], small: obj["small"], person_id: obj["person_id"] }
    }
  end

  def monthly_report_all_quantity
    ActiveRecord::Base.connection.execute(
      "select sum(huge+big+medium+small) as quantity from statistic_records"
    )[0]["quantity"]
  end
end