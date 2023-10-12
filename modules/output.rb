# The Output module provides methods for writing data to an output file in a specific format.
module Output
  # Writes user data to the output file.
  #
  # @param [File] f - The output file to write to.
  # @param [Array<User>] users - An array of User instances to be written to the output file.
  def write_users(f, users)
    users.each do |user|
      f.write "\t\t#{user.last_name}, #{user.first_name}, #{user.email}\n"
      f.write "\t\t  Previous Token Balance, #{user.tokens}\n"
      f.write "\t\t  New Token Balance #{user.top_up}\n"
    end
  end

  # Writes company data and associated user data to the output file.
  #
  # @param [File] f - The output file to write to.
  # @param [Company] company - The Company instance whose data is to be written to the output file.
  def write_company(f, company)
    f.write "\n"
    f.write "\tCompany Id: #{company.id}\n"
    f.write "\tCompany Name: #{company.name}\n"
    f.write "\tUsers Emailed:\n"
    write_users(f, company.user_emailed)
    f.write "\tUsers Not Emailed:\n"
    write_users(f, company.user_not_emailed)
    f.write "\t\tTotal amount of top-ups for #{company.name}: #{company.total_top_ups}\n"
  end
end