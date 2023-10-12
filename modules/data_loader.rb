require 'json'

# The DataLoader module provides methods for loading, finding, and handling data objects.
module DataLoader
  # Custom exception for invalid data.
  class InvalidData < StandardError
    attr_reader :errors

    def initialize(errors)
      super
      @errors = errors
    end
  end

  # Creates a new Object instance and adds it to the list of all if there are no validation errors.
  #
  # @param [Hash] args - A hash of user attributes (see #initialize for details).
  # @return [Object, nil] - The created Object instance or nil if there are validation errors.
  def create(params)
    obj = new(params)
    all << obj if obj.errors.empty?
    obj
  end


  # Retrieves all data objects of the including class.
  #
  # @return [Array] - An array of data objects.
  def all
    @all ||= []
  end

  # Finds a data object by its ID.
  #
  # @param [Integer] id - The unique identifier of the data object.
  # @return [Object, nil] - The found data object or nil if not found.
  def find(id)
    all.find { |obj| obj.id == id }
  end

  # Loads data from a JSON file and creates data objects based on the file contents.
  #
  # @param [String] file_name - The name of the JSON file to load.
  # @return [Array, String] - An array of loaded data objects or an error message.
  #
  # @raise [InvalidData] - Raised if any loaded data objects have validation errors.
  # @raise [JSON::ParserError] - Raised if the provided file is not valid JSON.
  # @raise [Errno::ENOENT] - Raised if the file is not found.
  def load(file_name)
    file = File.read(file_name)
    json_data = JSON.parse(file)
    errors = []

    json_data.each do |obj_data|
      obj = self.create(obj_data.transform_keys(&:to_sym))
      errors << {
        klass: obj.class,
        id: obj.id,
        errors: obj.errors
      } unless obj.errors.empty?
    end
    raise InvalidData.new(errors) unless errors.empty?
    all
  end
end
