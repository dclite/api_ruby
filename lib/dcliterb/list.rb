module DCLite
  # Mailing list representation class
  class List < Model
    attr_reader :raw

    FIELDS = [
      :id,
      :state,
      :count_active,
      :count_all,
      :name,
      :description,
      :company,
      :abuse_name,
      :phone,
      :address,
      :city,
      :url
    ]

    FIELDS.each do |f|
      attr_reader f
    end

    # Initialize new list instance
    #
    # @param connection [DCLite::Connection] Active connection
    # @param doc [Hash] API object data
    def initialize(connection, doc)
      super(connection, doc)
      FIELDS.each do |field|
        instance_variable_set :"@#{field}", doc[field.to_s]
      end
    end

    # Invokes 'lists.get_members' API method to retreive list members
    #
    # @param params [Hash] Params to be passed
    # @return [Array] Array of DCLite::Members instances
    def get_members(params = {})
      connection.call_method('lists.get_members', params.merge(id_params)).map {|member| DCLite::Member.new(connection, member)}
    end

    # Alias to get_members
    #
    alias_method :members, :get_members

    # Invokes 'lists.add_memner' method
    #
    # @param params [Hash] Params to be passed
    # @return [DCLite::Member] New member instance
    def add_member(params)
      added = connection.call_method('lists.add_member', params.merge(id_params))
      get_members(added).first
    end

    # Invokes 'lists.unsubscribe_member' API method
    #
    # @param params [Hash] Params to be passed
    # @return [Fixnum] Count of unsubscribed members
    def unsubscribe_member(params)
      connection.call_method('lists.unsubscribe_member', params.merge(id_params))['unsubscribed']
    end

    private

    def id_params
      {list_id: id}
    end
  end
end
