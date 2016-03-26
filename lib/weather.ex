defmodule Weather do
	def main(args) do
		# https://api.forecast.io/forecast/APIKEY/LATITUDE,LONGITUDE
		api_key = "80f71455dfe8a1e882ba6adf75b6ccf1"
		base_url = "https://api.forecast.io/forecast"
		location = "39.926619,-82.85235899999999"
		full_url = "#{base_url}/#{api_key}/#{location}"
		response = HTTPotion.get "#{full_url}"
		{status, list} = JSON.decode response.body
		currently = list["currently"]
		IO.puts "It is currently #{trunc currently["apparentTemperature"]} degrees"
	end
end
