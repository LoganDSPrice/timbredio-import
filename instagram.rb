require "csv"
require "nokogiri"
require "open-uri"

# string = "www.instagram.com/magnumbOpus/"

# def smart_add_url_protocol(string)
#   unless string[/\Ahttp:\/\//] || string[/\Ahttps:\/\//]
#     return "http://#{string}"
#   else
#     return string
#   end
# end

def format_instagram(string)
  if string[/\ /]
    return nil
  end

  # if string[0] == "@"
  #   handle = string[1..-1]
  #   "http://www.instagram.com/#{handle}"
  # end
end

table = CSV.parse(File.read("timbredio.csv"), headers: true)

table.first(20).each do |row|
  if row["instagram"]
    p smart_add_url_protocol(row["instagram"])
  end
end



# CSV.open("formatted.csv", "wb") do |csv|
#   csv << ["artist_name", "facebook", "instagram", "twitter"]
    
    
#   end
# end