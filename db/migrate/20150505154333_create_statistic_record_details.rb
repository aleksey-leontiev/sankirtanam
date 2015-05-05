class CreateStatisticRecordDetails < ActiveRecord::Migration
  def change
    create_table :statistic_record_details do |t|
      t.references :statistic_record, index: true
      t.integer :d01
      t.integer :d02
      t.integer :d03
      t.integer :d04
      t.integer :d05
      t.integer :d06
      t.integer :d07
      t.integer :d08
      t.integer :d09
      t.integer :d10
      t.integer :d11
      t.integer :d12
      t.integer :d13
      t.integer :d14
      t.integer :d15
      t.integer :d16
      t.integer :d17
      t.integer :d18
      t.integer :d19
      t.integer :d20
      t.integer :d21
      t.integer :d22
      t.integer :d23
      t.integer :d24
      t.integer :d25
      t.integer :d26
      t.integer :d27
      t.integer :d28
      t.integer :d29
      t.integer :d30
      t.integer :d31
      t.integer :quantity
      t.decimal :scores
    end
  end
end
