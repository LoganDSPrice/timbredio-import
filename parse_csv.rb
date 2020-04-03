require "csv"
require_relative "row.rb"

table = CSV.parse(File.read("timbredio.csv"), headers: true)
ROWS = []

table.each do |row|
  ROWS << Row.new(row["artist"], row["facebook"], row["instagram"], row["youtube"], row["twitter"]) 
end

# rows.first(20).each do |row|
#   p [row.facebook_input, row.normalized_facebook_url]
# end

# CSV.open("urls.csv", "wb") do |csv|
#   csv << ["artist_name", "facebook_url", "instagram_url", "twitter_url"]
#   rows.each do |row|
#     csv << [row.artist_name, row.normalized_facebook_url, row.normalized_instagram_url, row.normalized_twitter_url]
#   end
# end
# p rows[3]
# rows[3].facebook_followers = rows[3].get_facebook_followers
# p rows[3]