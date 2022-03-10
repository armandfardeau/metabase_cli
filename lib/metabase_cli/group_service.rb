require "metabase"
require "hash_deep_merge"
require_relative "api"

module MetabaseCli
  class GroupService
    include MetabaseCli::Api

    def initialize(name:)
      @name = name
      @group_id = nil
    end

    def create_group
      response = MetabaseCli::Api.client.post("/api/permissions/group", {
        name: @name
      })

      puts "Group created with id: #{response['id']}"

      self
    end
  end
end