require 'rubygems'
require 'open-uri'
require 'csv'

class BikeRacksController < ApplicationController

  BIKE_RACK_URI = 'ftp://webftp.vancouver.ca/opendata/bike_rack/BikeRackData.csv'

  def index
    @bike_racks = BikeRack.all
  end

  def full_update
    update_bike_racks
    redirect_to bike_racks_path
  end

  def full_clear
    BikeRack.delete_all
    redirect_to bike_racks_path
  end

  private

  def update_bike_racks
    CSV.foreach(open(BIKE_RACK_URI), headers: true) do |rack_data|
      store_one_bike_rack rack_data
    end
  end

  def store_one_bike_rack (data)
    @bike_rack = BikeRack.new(
      street_number: data['St Number'],
      street_name: data['St Name'].strip,
      street_side: data['Street Side'].strip,
      number_of_racks: data['# of racks'])

    handle_validation_error (@bike_rack) unless @bike_rack.save
  end

  def handle_validation_error (bike_rack)
    # TODO flash?
    logger.warn 'Model validation error: ' +
                "#{@bike_rack.street_number} #{@bike_rack.street_name}: " +
                @bike_rack.errors.full_messages.first
  end
end
