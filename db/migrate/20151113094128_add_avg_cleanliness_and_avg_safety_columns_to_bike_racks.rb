class AddAvgCleanlinessAndAvgSafetyColumnsToBikeRacks < ActiveRecord::Migration
  def change
    add_column :bike_racks, :avg_cleanliness, :float, default: 0
    add_column :bike_racks, :avg_safety, :float, default: 0
  end
end
