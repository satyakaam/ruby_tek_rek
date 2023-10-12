# The Validator module provides methods for validating different data types and constraints.
module Validator
  # Checks if the provided parameter is a boolean.
  #
  # @param [Object] param - The parameter to be checked.
  # @return [String, nil] - A validation error message or nil if the parameter is a boolean.
  def is_bool?(param)
    return "#{param} must be a boolean" unless [TrueClass, FalseClass].include?(param.class)
  end

  # Validates if the provided parameter is a valid ID within a list of IDs.
  #
  # @param [Integer] param - The parameter to be checked.
  # @param [Array<Integer>] ids - A list of valid IDs to compare against.
  # @return [String, nil] - A validation error message or nil if the parameter is a valid ID.
  def is_valid_id?(param, ids)
    return "ID #{param} is invalid" if param.class != Integer || ids.include?(param)
  end

  # Validates if the provided parameter is a valid email address and checks for uniqueness.
  #
  # @param [String] param - The email parameter to be checked.
  # @param [Array<String>] emails - A list of existing email addresses to check for uniqueness.
  # @return [String, nil] - A validation error message or nil if the parameter is a valid and unique email address.
  def is_email?(param, emails)
    error = ""
    email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    error << "Email: #{param} must be valid" if !param.match(email_regex).nil?
    error << " + unique." if emails.include?(param)
  end

  # Validates if the provided parameter is a valid string of a specific size.
  #
  # @param [String] param - The string parameter to be checked.
  # @param [Integer] size - The required size of the string.
  # @return [String, nil] - A validation error message or nil if the parameter is a valid string of the specified size.
  def is_string?(param, size)
    return "#{param} must be a valid string of size #{size}" if param.class != String || param.size > size
  end

  # Validates if the provided parameter is a valid integer.
  #
  # @param [Integer] param - The parameter to be checked.
  # @return [String, nil] - A validation error message or nil if the parameter is a valid integer.
  def is_integer?(param)
    return "#{param} must be a valid integer" if param.class != Integer
  end

  # Validates if the provided parameter refers to a valid company ID within a list of valid IDs.
  #
  # @param [Integer] param - The company ID parameter to be checked.
  # @param [Array<Integer>] ids - A list of valid company IDs to compare against.
  # @return [String, nil] - A validation error message or nil if the parameter refers to a valid company ID.
  def belongs_to_valid_company?(param, ids)
    return "Company with ID #{param} does not exist" unless ids.include?(param)
  end
end
