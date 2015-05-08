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
  
StatisticReport.seed(:id,
  { :id => 1, :location_id => 1, :date => "01/01/2015" },
  { :id => 2, :location_id => 1, :date => "01/02/2015" },
  { :id => 3, :location_id => 1, :date => "01/03/2015" },
  { :id => 4, :location_id => 2, :date => "01/01/2015" },
  { :id => 5, :location_id => 2, :date => "01/02/2015" },
  { :id => 6, :location_id => 3, :date => "01/01/2015" })
  
StatisticRecord.seed(:id,
  # moskow
  { :id => 1, :statistic_report_id => 1, :person_id => 1, :huge => 10, :big => 21, :medium => 71, :small => 91}, 
  { :id => 2, :statistic_report_id => 1, :person_id => 2, :huge => 21, :big => 31, :medium => 51, :small => 81}, 
  { :id => 3, :statistic_report_id => 1, :person_id => 3, :huge => 11, :big => 21, :medium => 41, :small => 61}, 
  { :id => 4, :statistic_report_id => 2, :person_id => 1, :huge => 13, :big => 11, :medium => 31, :small => 50}, 
  { :id => 5, :statistic_report_id => 2, :person_id => 2, :huge => 13, :big => 71, :medium => 91, :small => 63}, 
  { :id => 6, :statistic_report_id => 3, :person_id => 1, :huge => 14, :big => 51, :medium => 71, :small => 82}, 
  { :id => 7, :statistic_report_id => 3, :person_id => 3, :huge => 12, :big => 11, :medium => 21, :small => 11}, 
  # spb
  { :id => 8, :statistic_report_id => 4, :person_id => 4, :huge => 11, :big => 11, :medium => 21, :small => 10}, 
  { :id => 9, :statistic_report_id => 4, :person_id => 5, :huge => 13, :big => 21, :medium => 11, :small => 11}, 
  { :id => 10, :statistic_report_id => 5, :person_id => 6, :huge => 11, :big => 31, :medium => 10, :small => 31},
  # krs
  { :id => 11, :statistic_report_id => 6, :person_id => 7, :huge => 12, :big => 31, :medium => 21, :small => 10})
  
  
StatisticRecordDetails.seed(:id,
  # moskow
  { :id => 1, :statistic_record_id => 1, :quantity => 10, :scores => 10, :d01 => 1 }
)