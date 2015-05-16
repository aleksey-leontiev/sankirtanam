class Statistics::ReportsController < ApplicationController
  def new
  end

  def overall
    # chart data
    @data = ActiveRecord::Base.connection.execute(
      "select strftime('%Y', date) as year, strftime('%m', date) as month, sum(huge+big+medium+small) as quantity " +
      "from statistic_records rcd inner join statistic_reports rpt on rpt.id = rcd.statistic_report_id " +
      "group by strftime('%Y', date), strftime('%m', date)"
    ).map { |obj|
      { quantity: obj["quantity"], year: obj["year"], month: obj["month"] }
    }

    # active locations
    @locations = ActiveRecord::Base.connection.execute(
      "select strftime('%Y', date) as year, sum(huge+big+medium+small) as quantity, l.name as location " +
       "from statistic_records rcd inner join statistic_reports rpt on rpt.id = rcd.statistic_report_id " +
       "inner join locations l on l.id == rpt.location_id " +
       "group by l.id order by quantity desc"
    ).map { |obj|
      { year: obj["year"], location: obj["location"], quantity: obj["quantity"] }
    }

    # active persons
    @persons = ActiveRecord::Base.connection.execute(
      "select sum(huge+big+medium+small) quantity, p.name, l.name as location from statistic_records r " +
      "inner join people    p on r.person_id   = p.id " +
      "inner join locations l on p.location_id = l.id " +
      "group by p.id order by quantity desc"
    ).map { |obj|
      { name: obj["name"], quantity: obj["quantity"], location: obj["location"] }
    }

    # overall quantity
    # @persons.map{|o| o[:quantity].to_i}.inject(:+)
    @overall_quantity = ActiveRecord::Base.connection.execute(
      "select sum(huge+big+medium+small) as quantity from statistic_records"
    )[0]["quantity"]
  end
end
