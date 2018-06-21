module DCLite
  class Member < Model
    attr_reader :raw

    FIELDS = [
      :id,
      :list_id,
      :email,
      :state,
      :merge_1,
      :merge_2,
      :merge_3,
      :merge_4,
      :merge_5,
      :optin_time,
      :unsub_time,
      :lastedit_time
    ]

    FIELDS.each do |f|
      attr_reader f
    end

    # Initialize new member instance
    #
    # @param connection [DCLite::Connection] Active connection
    # @param doc [Hash] API object data
    def initialize(connection, doc)
      super(connection, doc)
      FIELDS.each do |field|
        instance_variable_set :"@#{field}", doc[field.to_s]
      end
    end

    # Invokes 'lists.delete_member' API method
    #
    def delete_member
      connection.call_method('lists.delete_member', id_params)
    end

    # Invokes 'lists.update_member' API method
    #
    # @param params [Hash] Params to be passed
    def update_member(params)
      connection.call_method('lists.update_member', params.merge(id_params))
    end

    # Invokes 'lists.get_lists' API method to retrieve member list
    #
    # @param params [DCLite::List] List instance, accosiated with member
    def list
      connection.get_list(list_id)
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
      {member_id: id}
    end

  end
end
