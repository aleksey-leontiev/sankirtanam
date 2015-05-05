class CreateStatisticReports < ActiveRecord::Migration
  def change
    create_table :statistic_reports do |t|
      t.references :location, index: true
      t.date :date
    end
  end
end
