require "./modules/validator.rb"
require "./modules/data_loader.rb"
require "./models/company.rb"

# The User class represents user entities and provides methods for managing user data.
class User
  extend DataLoader
  include Validator

  # Attributes with read-only access.
  attr_reader :id, :email, :first_name, :last_name,
              :email_status, :company_id, :tokens, :active_status,
              :errors

  # Alias method for checking the active status.
  alias :active? :active_status

  # Initializes a new User instance with the provided data.
  #
  # @param [Hash] args - A hash of user attributes.
  # @option args [Integer] :id - The user's unique identifier.
  # @option args [String] :email - The user's email address.
  # @option args [String] :first_name - The user's first name.
  # @option args [String] :last_name - The user's last name.
  # @option args [Boolean] :email_status - The user's email status (true or false).
  # @option args [Integer] :company_id - The ID of the associated company.
  # @option args [Integer] :tokens - User tokens, possibly related to company top-up.
  # @option args [Boolean] :active_status - The user's active status (true or false).
  def initialize(id:, email:, first_name:, last_name:, email_status:, company_id:, tokens:, active_status:)
    @errors = {
      id: is_valid_id?(id, self.class.all.map(&:id)),
      first_name: is_string?(first_name, 20),
      last_name: is_string?(last_name, 20),
      email: is_email?(email, self.class.all.map(&:email)),
      email_status: is_bool?(email_status),
      company_id: belongs_to_valid_company?(company_id, Company.all.map(&:id)),
      tokens: is_integer?(tokens),
      active_status: is_bool?(active_status)
    }

    @id = id
    @first_name = first_name
    @last_name = last_name
    @email = email
    @email_status = email_status
    @company_id = company_id
    @tokens = tokens
    @active_status = active_status
    @errors = @errors.compact
  end

  # Retrieves users associated with a given company.
  #
  # @param [Integer] company_id - The ID of the company to retrieve users for.
  # @return [Array<User>] - An array of User instances associated with the specified company.
  def self.company_users(company_id)
    all.select{ |user| user.company_id == company_id }
  end

  # Retrieves the company associated with the user.
  #
  # @return [Company, nil] - The Company instance associated with the user or nil if the company doesn't exist.
  def company
    Company.find(company_id)
  end

  # Calculates the total top-up value for the user based on the user's tokens and the associated company's top-up value.
  #
  # @return [Integer] - The total top-up value for the user.
  def top_up
    company.top_up + tokens
  end
end