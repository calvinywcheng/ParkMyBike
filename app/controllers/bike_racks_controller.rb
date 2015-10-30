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
      store_one_bike_rack (rack_data)
    end
  end

  def store_one_bike_rack (data)
    @bike_rack = BikeRack.new(
      street_number: data['St Number'],
      street_name: data['St Name'],
      street_side: data['Street Side'],
      sky_train_station_name: data['Skytrain Station Name'],
      bia: data['BIA'],
      number_of_racks: data['# of racks'],
      install_year: data['Years Installed'])
    unless  @bike_rack.save
      puts "#{@bike_rack.street_number} #{@bike_rack.street_name}"
    end
  end 
end
