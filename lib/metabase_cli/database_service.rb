require "metabase"
require "hash_deep_merge"
require_relative "client"

module MetabaseCli
  class DatabaseService
    include MetabaseCli::Client

    def initialize(client_name:, dbname:, engine:, host:, port:, dbusername:, password:)
      @client_name = client_name
      @dbname = dbname
      @engine = engine
      @host = host
      @port = port
      @dbusername = dbusername
      @password = password
      @database_id = nil
    end

    def create_database
      response = MetabaseCli::Client.call.post("/api/database", database_params)
      @database_id = response.fetch("id")
      puts "Successfully created database with id: #{@database_id}"

      self
    end

    def set_default_permissions
      response = MetabaseCli::Client.call.put("/api/permissions/graph", default_permissions)

      puts "Successfully set default permissions" if permissions_graph[:"revision"] != response["revision"]
    end

    private

    def database_params
      {
        "name": @client_name,
        "engine": @engine,
        "details": {
          "host": @host,
          "port": @port,
          "dbname": @dbname,
          "user": @dbusername,
          "password": @password
        }
      }
    end

    def default_permissions
      permissions_graph.dup.deep_merge(
        {
          "groups":
            {
              "1": {
                "#{@database_id.to_s}": {
                  "native": "none",
                  "schemas": "none"
                }
              }
            }
        }
      )
    end

    def permissions_graph
      # Due to Faraday we need to use a trick to get the string key as symbol
      @permissions_graph ||= JSON.parse(JSON.dump(MetabaseCli::Client.call.get("/api/permissions/graph")), symbolize_names: true)
    end
  end
end