require "csv"
require_relative "row.rb"

table = CSV.parse(File.read("timbredio.csv"), headers: true)

CSV.open("working_table.csv", "wb") do |csv|
  csv << Row::ATTRS
  
  table.each do |input_row|
    row = Row.new(input_row["artist"], input_row["instagram"], input_row["facebook"], input_row["twitter"]) 

    csv << row.attrs
  end
end
