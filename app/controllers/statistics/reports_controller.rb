class Statistics::ReportsController < ApplicationController
  def new
  end

  def overall
    data = ActiveRecord::Base.connection.execute("select strftime('%Y', date) as year, strftime('%m', date) as month, sum(huge+big+medium+small) as quantity from statistic_records rcd inner join statistic_reports rpt on rpt.id = rcd.statistic_report_id group by strftime('%Y', date), strftime('%m', date)")
    @data  =data.map { |obj| { date: "#{obj['month']}/#{obj['year']}", quantity: obj['quantity'] } }
  end
end
