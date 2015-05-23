Location.seed(:id,
  { :id => 1, :name => "Москва", :url => "moskow" },
  { :id => 2, :name => "Санк-Петербург", :url => "spb" },
  { :id => 3, :name => "Красноярск", :url => "krasnoyarsk" })

Person.seed(:id,
  { :id => 1, :name => "Варадеша дас", :location_id => 1},
  { :id => 2, :name => "Ананта Кришна Госвами", :location_id => 1},
  { :id => 3, :name => "Клим", :location_id => 1},
  { :id => 4, :name => "Гададхара Прана дас", :location_id => 2},
  { :id => 5, :name => "Арджуна Вишваса дас", :location_id => 2},
  { :id => 6, :name => "Ачьютаградж дас", :location_id => 2},
  { :id => 7, :name => "Найка Говинда дас", :location_id => 3},
  { :id => 8, :name => "Ачьюта Гаура дас", :location_id => 3},
  { :id => 9, :name => "Петр", :location_id => 3})

for year in 2013..2016 do
  for month in 1..12 do
    if month % 2 == 0 then next end

    report_id = "#{year}#{month}00".to_i
    record_id = "#{year}#{month}00".to_i
    detail_id = "#{year}#{month}00".to_i

    StatisticReport.seed(:id,
      { :id => report_id+1, :location_id => 1, :date => "01/#{month}/#{year}" },
      { :id => report_id+2, :location_id => 2, :date => "01/#{month}/#{year}" },
      { :id => report_id+3, :location_id => 3, :date => "01/#{month}/#{year}" })

    StatisticRecord.seed(:id,
      { :id => record_id+1, :statistic_report_id => report_id+1, :person_id => 1, :huge => rand(10), :big => rand(21), :medium => rand(71), :small => rand(91)}, # moskow
      { :id => record_id+2, :statistic_report_id => report_id+1, :person_id => 2, :huge => rand(21), :big => rand(31), :medium => rand(51), :small => rand(81)},
      { :id => record_id+3, :statistic_report_id => report_id+1, :person_id => 3, :huge => rand(11), :big => rand(21), :medium => rand(41), :small => rand(61)},
      { :id => record_id+4, :statistic_report_id => report_id+2, :person_id => 4, :huge => rand(11), :big => rand(11), :medium => rand(21), :small => rand(10)}, # spb
      { :id => record_id+5, :statistic_report_id => report_id+2, :person_id => 5, :huge => rand(13), :big => rand(21), :medium => rand(11), :small => rand(11)},
      { :id => record_id+6, :statistic_report_id => report_id+2, :person_id => 6, :huge => rand(11), :big => rand(31), :medium => rand(10), :small => rand(31)},
      { :id => record_id+7, :statistic_report_id => report_id+3, :person_id => 7, :huge => rand(12), :big => rand(31), :medium => rand(21), :small => rand(10)}) # krs

    StatisticRecordDetails.seed(:id,
      # moskow
      { :id => detail_id+1, :statistic_record_id => report_id+1, :quantity => 10, :scores => 10, :d01 => 1 }
    )
  end
end