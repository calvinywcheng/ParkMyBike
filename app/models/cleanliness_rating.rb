class CleanlinessRating < Rating
    belongs_to :bike_rack, inverse_of: :cleanliness_ratings

    def update_score(new_score)
        saved = super new_score
        return saved && self.bike_rack.update_cleanliness
    end

end