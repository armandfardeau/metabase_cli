require "metabase"
require "hash_deep_merge"

module MetabaseCli
  module Client
    def self.call
      raise "Missing url" unless ENV["METABASE_URL"]
      raise "Missing username" unless ENV["METABASE_USERNAME"]
      raise "Missing password" unless ENV["METABASE_PASSWORD"]

      @metabase_client ||= Metabase::Client.new(
        url: ENV.fetch("METABASE_URL", nil),
        username: ENV.fetch("METABASE_USERNAME", nil),
        password: ENV.fetch("METABASE_PASSWORD", nil)
      ).tap { |client| client.login }
    end
  end
end