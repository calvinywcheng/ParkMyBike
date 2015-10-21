class BikeRack < ActiveRecord::Base
  validates :street_number, uniqueness: { scope: :street_name}
end
