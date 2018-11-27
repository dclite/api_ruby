require 'faraday'
require 'faraday_middleware'

module DCLite
  class Connection

    API_URL = 'https://api.dclite.ru'

    # Initializes new connection instance
    #
    # @param username [String] Service username
    # @param password [String] Password
    def initialize(username, password, endpoint = API_URL)
      @username, @password = username, password
      @endpoint = endpoint
    end

    attr_reader :endpoint

    # Memoized Faraday connection factory
    #
    # @return Faraday connection instance
    def connection
      @conn ||= Faraday.new(:url => endpoint) do |faraday|
        faraday.request  :url_encoded
        faraday.response :json
        faraday.adapter  Faraday.default_adapter
      end
    end

    # Invokes API method by name
    #
    # @param method [String] Method name, corresponding API reference https://api.dclite.ru//
    # @param params [Hash] Params to be passed
    def call_method(method, params = {})
      response = connection.post '/', {method: method}.merge(credentials).merge(params)
      err_code = response.body["response"]["msg"]["err_code"]

      case err_code
      when 0
        response.body["response"]["data"]
      when 4
        raise DCLite::NoDataException.new(response.body["response"]["msg"]["text"])
      else
        raise DCLite::ApiException.new(response.body["response"]["msg"]["text"])
      end
    end

    # Invokes 'lists.get' API method
    #
    # @param params [Hash] Params to be passed
    # @return [Array] Array of DCLite::List instances
    def lists(params = {})
      call_method('lists.get', params).map {|list_raw| DCLite::List.new(self, list_raw)}
    end


    # Invokes 'lists.get' API method to retrieve single List object
    #
    # @param id [Fixnum] List id
    # @return [DCLite::List] List instance
    def get_list(id)
      lists(list_id: id)[0]
    end

    # 'list.get' method alias
    #
    alias_method :get, :lists

    # Invokes 'lists.get_member' API method
    #
    # @param email [String] Email for search
    # @return [Array] Array of DCLite::Member instances
    def get_member(email)
      call_method('lists.get_member', {email: email}).map {|member| DCLite::Member.new(connection, member)}
    end

    # Invokes 'lists.unsubscribe_member' API method
    #
    # @param params [Hash] Params to be passed
    # @return [Fixnum] Count of unsubscribed members
    def unsubscribe_member(params)
      call_method('lists.unsubscribe_member', params)['unsubscribed']
    end

  private

    def credentials
      {username: @username, password: @password}
    end
  end
end
