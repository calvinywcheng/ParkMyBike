class SafetyRatingsController < RatingsController

    def create
        @current_user = User.find(session[:user_id])
        @rating = SafetyRating.create(
                        bike_rack_id: params[:bike_rack_id],
                        score: 0,
                        user_id: @current_user.id)
        update_score params[:score]
    end
end
