require "./modules/data_loader.rb"
require "./modules/validator.rb"

# The Company class represents company entities and provides methods for managing company data.
class Company
  extend DataLoader
  include Validator

  # Attributes with read-only access.
  attr_reader :id, :name, :email_status, :top_up, :errors

  # Initializes a new Company instance with the provided data.
  #
  # @param [Hash] args - A hash of company attributes.
  # @option args [Integer] :id - The company's unique identifier.
  # @option args [String] :name - The company's name.
  # @option args [Boolean] :email_status - The company's email status (true or false).
  # @option args [Integer] :top_up - The company's top-up value.
  def initialize(id:, name:, email_status:, top_up:)
    @errors = {
      id: is_valid_id?(id, self.class.all.map(&:id)),
      name: is_string?(name, 30),
      top_up: is_integer?(top_up),
      email_status: is_bool?(email_status)
    }

    @id = id
    @name = name
    @top_up = top_up
    @email_status = email_status
    @errors = @errors.compact
  end

  # Retrieves users associated with the company.
  #
  # @return [Array<User>] - An array of User instances associated with the company.
  def users
    @users ||= User.company_users(self.id)
  end

  # Retrieves and caches active users associated with the company.
  #
  # @return [Array<User>] - An array of active User instances associated with the company.
  def active_users
    @active_users ||= users.select(&:active?)
  end

  # Calculates the total top-up value for the company based on the number of active users and the company's top-up value.
  #
  # @return [Integer] - The total top-up value for the company.
  def total_top_ups
    active_users.count * top_up
  end

  # Retrieves and categorizes users who have been emailed or not, based on the company's email status.
  #
  # @return [Array<User>] - An array of User instances who have been emailed.
  def user_emailed
    @user_emailed ||= if email_status
      active_users.select(&:email_status).sort_by { |u| [u.last_name, u.first_name] }
    else
      []
    end
  end

  # Retrieves and categorizes users who have not been emailed, based on the company's email status.
  #
  # @return [Array<User>] - An array of User instances who have not been emailed.
  def user_not_emailed
    @user_not_emailed ||= if email_status
      active_users.reject(&:email_status).sort_by { |u| [u.last_name, u.first_name] }
    else
      active_users.sort_by { |u| [u.last_name, u.first_name] }
    end
  end
end
