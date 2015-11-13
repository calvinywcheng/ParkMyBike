require 'rubygems'
require 'open-uri'
require 'csv'

class BikeRacksController < ApplicationController

  DEFAULT_URI = 'ftp://webftp.vancouver.ca/opendata/bike_rack/BikeRackData.csv'

  def index
    @bike_racks = BikeRack.search(params[:search])
  end

  def show
    @bike_rack = BikeRack.find(params[:id])
    show_update_rating
  end

  def internal
    @bike_racks = BikeRack.all
  end

  def update_all
    Thread.new do
      begin
        @remote_url = params[:remote_url].blank? ? DEFAULT_URI : params[:remote_url]
        update_bike_racks @remote_url
      rescue StandardError => e
        handle_full_update_error e
      end
    end
    flash[:info] = 'Updating data. This will take some time; the data will ' +
        'be loaded into the table as it is parsed.'
    redirect_to internal_path
  end

  private

  def update_bike_racks (racks_data)
    counter = {valid: 0, invalid: 0}
    CSV.foreach(open(racks_data), headers: true) do |rack_data|
      result = store_one_bike_rack(rack_data) ? :valid : :invalid
      counter[result] += 1
    end
    handle_finished_parsing counter
  end

  def store_one_bike_rack (data)
    begin
      @bike_rack = BikeRack.new(
          street_number: data['St Number'].strip,
          street_name: data['St Name'].strip,
          street_side: data['Street Side'].strip,
          number_of_racks: data['# of racks'])
    rescue StandardError => e
      handle_format_error(e, data)
      return false
    end

    @bike_rack.save || handle_validation_error(@bike_rack)
  end

  def handle_full_update_error (e)
    flash[:alert] = "Problem opening bike rack URL: #{@remote_url}. " +
        'Are things going okay over there?'
    logger.error "Error fetching data: #{e}"
  end

  def handle_format_error (err, data)
    logger.error err
    logger.error 'CSV data format invalid:'
    logger.error "Read #{data.to_s}"
    logger.error 'Expected keys [\'St Number\', \'St Name\', \'Street Side\', \'# of racks\']'
  end

  def handle_validation_error (bike_rack)
    logger.warn 'Model validation error: ' +
                    "#{bike_rack.street_number} #{bike_rack.street_name}: " +
                    bike_rack.errors.full_messages.first
    false
  end

  def handle_finished_parsing (counter)
    logger.info "#{counter[:valid]} bike rack(s) parsed successfully."
    logger.info "#{counter[:invalid]} model validation error(s) found."
    counter
  end

  def show_update_rating

    if logged_in?
      @current_user = User.find(session[:user_id])
      @safetyrating = @bike_rack.safety_ratings.where(user_id: @current_user.id).first
      unless @safetyrating
        @safetyrating = @bike_rack.safety_ratings.create(user_id: @current_user.id, score: 0)
      end

      @cleanlinessrating = @bike_rack.cleanliness_ratings.where(user_id: @current_user.id).first
      unless @cleanlinessrating
        @cleanlinessrating = @bike_rack.cleanliness_ratings.create(user_id: @current_user.id, score: 0)
        logger.warn "cleanlinessrating #{@cleanlinessrating.id} #{@cleanlinessrating.bike_rack_id} #{@cleanlinessrating.user_id} #{@cleanlinessrating.score}"
      end

    end

  end
end
