require 'csv'
require "net/http"
require "uri"
require "CGI"
require "JSON"

candidates_file_path = File.join(File.dirname(__FILE__), "data", "candidates.csv")
File.delete(candidates_file_path) if File.exists?(candidates_file_path)
all_candidates = []

Dir.glob("./data/*.csv") do |file| 
  rows = CSV.read(file)
  ward = file.split(".")[1].split("/").last
  rows = rows.drop(1)

  candidates_rows = []

  while rows.any?
    candidate_rows = rows.take(1)
    rows = rows.drop(1)
    candidate_rows = candidate_rows.concat(rows.take_while {|r| r[0] == ""})
    rows = rows.drop_while {|r| r[0] == ""}
    candidates_rows << candidate_rows
  end

  candidates = candidates_rows.map do |rows| 
    rows = rows.select {|c| c != ""}
    party = rows.map {|r| r[3].strip}.select {|c| c != ""}.join(" ").strip
    address = rows.map {|r| r[2].strip}.select {|c| c != ""}
    {
      ward: ward, 
      surname: rows.first[0].capitalize.strip, 
      firstnames: rows.first[1].strip, 
      party: party,
      postcode: address.last
    }   
  end
  all_candidates = all_candidates.concat(candidates)
end


all_candidates = all_candidates.map do |candidate|
  p candidate
  url_path = "http://nominatim.openstreetmap.org/search?q=#{CGI::escape(candidate[:postcode])}&format=json"
  puts url_path
  uri = URI.parse(url_path)

  # Shortcut
  response = Net::HTTP.get_response(uri)
  location = JSON.parse(response.body)[0] || {"lat" => "", "lon" => ""}

  puts location["lat"] 
  puts location["lon"] 
  candidate.merge({lat: location["lat"], lon: location["lon"]})
end


CSV.open(candidates_file_path, 'w') do |csv|
  csv << all_candidates.first.keys
  all_candidates.each do |c| 
    csv << c.values
  end
end
