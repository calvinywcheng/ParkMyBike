class RatingsController < ApplicationController

  def update
    @rating = Rating.find(params[:id])
    unless @rating.update_score(params[:score])
      logger.error "Rating #{@rating.id} Failed to update to #{params[:score]}"
    end
    redirect_to :back #TODO does refresh page
  end

end
