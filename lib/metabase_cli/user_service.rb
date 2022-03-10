require "metabase"
require "hash_deep_merge"
require_relative "client"

module MetabaseCli
  class UserService
    def initialize(last_name:, first_name:, email:, group_wanted:)
      @last_name = last_name
      @first_name = first_name
      @email = email
      @group_wanted = group_wanted
    end

    def create_user
      puts "Successfully created user"

      self
    end
  end
end