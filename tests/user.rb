require 'minitest/autorun'
require_relative '../models/company.rb'
require_relative '../models/user.rb'

class UserTest < Minitest::Test
  def setup
    # Create a sample company for testing
    @company = Company.create(
      id: 1,
      name: 'Test Company',
      email_status: true,
      top_up: 100
    )

    # Create a sample user for testing
    @user = User.create(
      id: 1,
      email: 'test@example.com',
      first_name: 'John',
      last_name: 'Doe',
      email_status: true,
      company_id: @company.id,
      tokens: 50,
      active_status: true
    )
  end

  def teardown
    # Reset the User's and Company's data after each test
    User.all.clear
    Company.all.clear
  end

  def test_create_user
    # Test that a user can be created successfully
    assert_instance_of User, @user
  end

  def test_invalid_user_attributes
    # Test creating a user with invalid attributes
    invalid_user = User.create(
      id: 1, # Duplicate ID
      email: 'invalid_email', # Invalid email
      first_name: 'Invalid First Name That Is Too Long',
      last_name: 'Invalid Last Name That Is Too Long',
      email_status: 'invalid', # Invalid email status
      company_id: 999, # Non-existent company
      tokens: 'not_an_integer', # Invalid tokens
      active_status: 'invalid' # Invalid active status
    )
    refute invalid_user.errors.empty?
    assert_equal "ID 1 is invalid", invalid_user.errors[:id]
    assert_equal "Invalid First Name That Is Too Long must be a valid string of size 20", invalid_user.errors[:first_name]
    assert_equal "Invalid Last Name That Is Too Long must be a valid string of size 20", invalid_user.errors[:last_name]
    assert_equal "not_an_integer must be a valid integer", invalid_user.errors[:tokens]
    assert_equal "invalid must be a boolean", invalid_user.errors[:email_status]
    assert_equal "invalid must be a boolean", invalid_user.errors[:active_status]
    assert_equal "Company with ID 999 does not exist", invalid_user.errors[:company_id]
    assert_equal 1, User.all.length # The invalid user should not be added
  end

  def test_company_association
    # Check if the user's associated company is retrieved correctly
    assert_equal @company, @user.company
  end

  def test_top_up_calculation
    # Check if the top-up calculation is correct
    assert_equal 150, @user.top_up
  end

  # Add more test cases as needed
end