# frozen_string_literal: true

require "metabase"
require "hash_deep_merge"

module MetabaseCli
  module Api
    def self.client
      raise "Missing url" unless ENV["METABASE_URL"]
      raise "Missing username" unless ENV["METABASE_USERNAME"]
      raise "Missing password" unless ENV["METABASE_PASSWORD"]

      @client ||= Metabase::Client.new(
        url: ENV.fetch("METABASE_URL", nil),
        username: ENV.fetch("METABASE_USERNAME", nil),
        password: ENV.fetch("METABASE_PASSWORD", nil)
      ).tap(&:login)
    end

    def self.permissions_graph
      # Due to Faraday we need to use a trick to get the string key as symbol
      @permissions_graph ||= JSON.parse(JSON.dump(client.get("/api/permissions/graph")), symbolize_names: true)
    end
  end
end
