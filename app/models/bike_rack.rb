class BikeRack < ActiveRecord::Base

  has_many :cleanliness_ratings, inverse_of: :bike_rack
  has_many :safety_ratings, inverse_of: :bike_rack

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
    [street_number, street_name, "Vancouver BC, Canada"].compact.join(', ')
  end

  def update_safety
    self.avg_safety = safety_ratings.sum(:score) / safety_ratings.size
    saved = self.save
    logger.warn "Safety_rating saved: #{saved} rating: #{self.avg_safety}"
  end

  def update_cleanliness
    self.avg_cleanliness = cleanliness_ratings.sum(:score) / cleanliness_ratings.size
    saved = self.save
    logger.warn  "Cleanliness_rating saved: #{saved} rating: #{self.avg_cleanliness}"
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
