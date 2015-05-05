class CreateStatisticRecords < ActiveRecord::Migration
  def change
    create_table :statistic_records do |t|
      t.references :statistic_report, index: true
      t.references :person, index: true
      t.integer :huge
      t.integer :big
      t.integer :medium
      t.integer :small
    end
  end
end
