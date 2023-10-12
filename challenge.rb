require './models/user.rb'
require './models/company.rb'
require './modules/output.rb'
# This script loads data for companies and users from JSON files, processes the data, and writes the results to an output file.

# Include the Output module to use its methods for writing data to the output file.
include Output


begin
  # Load company data from "companies.json" 
  Company.load("companies.json")
  # Load user data from "valid_users.json"
  User.load("valid_users.json")
  # Open the output file "output.txt" for writing.
  File.open("output.txt", "w") do |f|
    # Iterate through all companies, sorted by ID.
    Company.all.sort_by(&:id).each do |company|
      # Skip companies with no active users.
      next if company.active_users.empty?
      
      # Write the company data to the output file using the Output module's method.
      Output.write_company(f, company)
    end
  end
rescue DataLoader::InvalidData => error
  puts error.errors
rescue JSON::ParserError
  puts "Not a valid JSON file."
rescue Errno::ENOENT
  puts "File not found."
end
