class CreateBikeRacks < ActiveRecord::Migration
  def change
    create_table :bike_racks do |t|
      t.string :street_number
      t.string :street_name
      t.string :street_side
      t.integer :number_of_racks
      t.float :latitude
      t.float :longitude
      t.timestamps null: false
    end
  end
end
