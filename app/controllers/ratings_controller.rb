class RatingsController < ApplicationController

    before_filter :authenticate_user

    def update
        @rating = Rating.find(params[:id])
        update_score params[:score]
    end


    private

        def update_score (score)
            unless @rating.update_score(score)
              logger.error "Rating #{@rating.id} Failed to update to #{params[:score]}"
            end
            redirect_to "bike_racks/index" # TODO: this does not work at all, maybe raty blocks it somehow
        end

end