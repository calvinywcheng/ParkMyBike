class BikeRack < ActiveRecord::Base

  geocoded_by :address
  before_save :geocode

  def self.search(search)
    if search
      where('street_name LIKE ?', "%#{search}%")
    else
      none
    end
  end

  def address
    [@street_number, @street_name, "Vancouver BC, Canada"].compact.join(', ')
  end

  DIRECTIONS = %w(North West East South)

  validates :street_name,
            presence: true

  validates :street_number,
            presence: true,
            uniqueness: { scope: :street_name },
            numericality: { only_integer: true }

  validates :street_side,
            presence: true,
            inclusion: { in: DIRECTIONS }

  validates :number_of_racks,
            presence: true,
            numericality: { greater_than_or_equal_to: 1 }


end
