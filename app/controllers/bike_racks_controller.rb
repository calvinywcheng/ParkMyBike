require 'rubygems'
require 'open-uri'
require 'csv'

class BikeRacksController < ApplicationController
	def index
		@bike_racks = BikeRack.all
	end

	def full_update
		update_bike_racks
		redirect_to bike_racks_path
	end

	private

	def update_bike_racks
		CSV.foreach(fatch_bike_rack_csv, :headers => true) do |rack_data|
			store_one_bike_rack (rack_data)
		end
	end

	def fatch_bike_rack_csv
		url = "ftp://webftp.vancouver.ca/opendata/bike_rack/BikeRackData.csv"
		return open(url)
	end

	def store_one_bike_rack (data)
		bike_rack = BikeRack.new(
			street_number: data[0],
			street_name: data[1],
			street_side: data[2],
			sky_train_station_name: data[3],
			bia: data[4],
			number_of_racks: data[5],
			install_year: data[6])
		bike_rack.save
	end 
end
