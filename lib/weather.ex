defmodule Weather do
	# https://maps.googleapis.com/maps/api/geocode/json?address=1600+5233+jameson+drive+columbus+oh&key=AIzaSyDiglohQeePIsYHgHSLNqWeFhLg_xqxnV0
	# https://api.forecast.io/forecast/APIKEY/LATITUDE,LONGITUDE
	def main(address) do
		address 
		|> to_string 
		|> parse_address 
		|> location 
		|> weather
	end

	# Replaces spaces with +'s for google maps api
	def parse_address(address) do
		String.replace(address, " ", "+")
	end	

	# Gets the Weather for the location provided
	def weather(location) do
		{status, list} = JSON.decode request_weather(location).body
		if status == :ok do
			currently(list)
		else
			IO.puts "Error: #{status} status returned"
		end
	end

	# RETURNS lat/long coordinates from address
	def location(address) do
		{status, list} = JSON.decode request_coordinates(address).body
		if status == :ok do
				results = list["results"] |> List.first
				latitude = results["geometry"]["location"]["lat"]
				longitude = results["geometry"]["location"]["lng"]
				"#{latitude},#{longitude}"
			else
				IO.puts "Error processing: #{status} code returned"
		end
	end

	# Puts the truncated current temperature for the location.
	def currently(list) do
		list = list["currently"]
		IO.puts "It is currently #{trunc list["apparentTemperature"]} degrees"
	end

	# Hits the forecast.io api
	def request_weather(location) do
		HTTPotion.get "#{forcast_io_full_url(location)}"
	end

	# Hits the Google Maps API 
	def request_coordinates(address) do
		HTTPotion.get google_full_url(address)
	end

	def google_full_url(address) do
		"https://maps.googleapis.com/maps/api/geocode/json?address=#{address}&key=#{google_api_key}"
	end

	def forcast_io_full_url(location) do
		"#{forcast_io_base_url}/#{forcast_io_api_key}/#{location}"
	end

	def forcast_io_base_url do
		"https://api.forecast.io/forecast"
	end
	
	defp forcast_io_api_key do
		"80f71455dfe8a1e882ba6adf75b6ccf1"
	end

	defp google_api_key do
		"AIzaSyDiglohQeePIsYHgHSLNqWeFhLg_xqxnV0"
	end
end