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
        "name": @name
      })

      @group_id = response["id"]
      puts "Group created with id: #{@group_id}"

      @group_id
    end
  end
end