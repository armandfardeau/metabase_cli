require "metabase"
require "hash_deep_merge"
require_relative "api"

module MetabaseCli
  class UserService
    def initialize(last_name:, first_name:, email:, group_wanted:)
      @last_name = last_name
      @first_name = first_name
      @email = email
      @group_wanted = group_wanted
      @user_id = nil
    end

    def create_user
      response = MetabaseCli::Api.client.post("/api/user", user_params)
      @user_id = response.fetch("id")

      puts "Successfully created user with id: #{@user_id}"

      self
    end

    private

    def user_params
      {
        first_name: @first_name,
        last_name: @last_name,
        email: @email,
        password: SecureRandom.alphanumeric(32),
        group_ids: nil,
        login_attributes: nil,
        locale: "fr"
      }
    end
  end
end