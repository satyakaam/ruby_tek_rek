require 'minitest/autorun'
require_relative '../models/company.rb'
require_relative '../models/user.rb'

class CompanyTest < Minitest::Test
  def setup
    # Create a sample company for testing
    @company = Company.create(
      id: 1,
      name: 'Test Company',
      email_status: true,
      top_up: 100
    )
  end

  def teardown
    # Reset the Company's data after each test
    Company.all.clear
  end

  def test_create_company
    # Test that a company can be created successfully
    assert_instance_of Company, @company
  end

  def test_invalid_company_attributes
    # Test creating a company with invalid attributes
    invalid_company = Company.create(
      id: 1, # Duplicate ID
      name: 'Invalid Company Name That Is Too Long',
      email_status: 'invalid',
      top_up: 'not_an_integer'
    )
    refute invalid_company.errors.empty?
    assert_equal "ID 1 is invalid", invalid_company.errors[:id]
    assert_equal "Invalid Company Name That Is Too Long must be a valid string of size 30", invalid_company.errors[:name]
    assert_equal "not_an_integer must be a valid integer", invalid_company.errors[:top_up]
    assert_equal "invalid must be a boolean", invalid_company.errors[:email_status]
    assert_equal 1, Company.all.length # The invalid company should not be added
  end

  def test_load_valid_json
    # Test for a valid company json file
    result = Company.load('./tests/data/companies.json')

    assert_instance_of Array, result
    assert_equal 5, result.length
    assert_equal 5, Company.all.count
  end

  def test_load_invalid_json
    # Test for a invalid json file
    assert_raises JSON::ParserError do
      Company.load('./tests/data/invalid.json')
    end
  end

  def test_load_file_not_found
    # Test for a file that does not exist
    assert_raises Errno::ENOENT do
      Company.load('nonexistent.json')
    end
  end

  def test_load_file_not_found
    # Test for a file that does not exist
    assert_raises DataLoader::InvalidData do
      Company.load('./tests/data/invalid_companies.json')
    end
  end

  def test_users_associated_with_company
    # Create some sample users associated with the company
    user1 = User.create(
      id: 1,
      email: 'user1@example.com',
      first_name: 'John',
      last_name: 'Doe',
      email_status: true,
      company_id: @company.id,
      tokens: 50,
      active_status: true
    )

    user2 = User.create(
      id: 2,
      email: 'user2@example.com',
      first_name: 'Jane',
      last_name: 'Smith',
      email_status: false,
      company_id: @company.id,
      tokens: 75,
      active_status: true
    )

    # Check if users associated with the company are retrieved correctly
    assert_equal [user1, user2], @company.users
  end
end
