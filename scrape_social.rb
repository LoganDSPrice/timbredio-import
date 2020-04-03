require "csv"
require_relative "row.rb"

table = CSV.parse(File.read("working_table.csv"), headers: true)

rows = []

table.each do |csv_row|
  new_row = Row.new(
    csv_row["artist_name"],
    csv_row["instagram_input"],
    csv_row["facebook_input"],
    csv_row["twitter_input"]
  )

  new_row.instagram_handle = csv_row["instagram_handle"]
  new_row.instagram_url = csv_row["instagram_url"]
  new_row.instagram_followers = csv_row["instagram_followers"]
  new_row.facebook_handle = csv_row["facebook_handle"]
  new_row.facebook_url = csv_row["facebook_url"]
  new_row.facebook_followers = csv_row["facebook_followers"]
  new_row.twitter_handle = csv_row["twitter_handle"]
  new_row.twitter_url = csv_row["twitter_url"]
  new_row.twitter_followers = csv_row["twitter_followers"]

  rows << new_row
end

i = 1

rows.each do |row|
  puts "Processing #{row.artist_name}"
  puts "Row ##{i}"
  puts ""

  updated = false

  if row.scrape_instagram?
    row.instagram_followers = row.get_instagram_followers
    updated = true
    puts "Instagram followers updated to: #{row.instagram_followers}"
  else
    puts "Instagram followers UNCHANGED"
  end
  
  if row.scrape_twitter?
    row.twitter_followers = row.get_twitter_followers
    updated = true
    puts "Twitter followers updated to: #{row.twitter_followers}"
  else
    puts "Twitter followers UNCHANGED"
  end
  
  if row.scrape_facebook?
    row.facebook_followers = row.get_facebook_followers
    updated = true
    puts "Facebook followers updated to: #{row.facebook_followers}"
  else
    puts "Facebook followers UNCHANGED"
  end

  if updated
    CSV.open("working_table.csv", "wb") do |csv|
      csv << Row::ATTRS
      rows.each do |row|
        csv << row.attrs
      end
      puts "CSV updated"
    end
  end
  i += 1
  puts "="*80
end