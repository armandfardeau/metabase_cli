require "metabase"
require "hash_deep_merge"
require_relative "client"

module MetabaseCli
  class DatabaseService
    include MetabaseCli::Api

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
      response = MetabaseCli::Api.client.post("/api/database", database_params)
      @database_id = response.fetch("id")
      puts "Successfully created database with id: #{@database_id}"

      self
    end

    def set_default_permissions
      response = MetabaseCli::Api.client.put("/api/permissions/graph", default_permissions)

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
      MetabaseCli::Api.permissions_graph.dup.deep_merge(
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
  end
end