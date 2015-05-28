class CreateUserLocationAccesses < ActiveRecord::Migration
  def change
    create_table :user_location_accesses do |t|
      t.references :user, index: true
      t.references :location, index: true
    end
  end
end
