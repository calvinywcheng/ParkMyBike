class Rating < ActiveRecord::Base
    belongs_to :user, inverse_of: :ratings

    validates :score,
              presence: true,
              inclusion: { in: 0..5 }


    def update_score(new_score)
        self.score = new_score
        return self.save
    end

end
