module DCLite
  # Basic class for API model objects
  class Model

    # API object data
    attr_reader :raw

    # Initialize new model instance
    #
    # @param connection [DCLite::Connection] Active connection
    # @param doc [Hash] API object data
    def initialize(connection, doc)
      @connection = connection
      @raw = doc
    end

    protected

    def connection
      @connection
    end

  end
end
