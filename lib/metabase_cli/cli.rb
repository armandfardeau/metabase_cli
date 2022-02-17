require 'thor'
require "metabase_cli/database_service"

module MetabaseCli
  class CLI < Thor
    desc 'version', 'Prints the version'

    def version
      puts "MetabaseApi version #{MetabaseCli::VERSION}"
    end

    desc 'create', 'Create a database'

    def create
      client_name = ask("Client name: ")
      dbname = ask("Database name: ")
      engine = ask("Database engine: ", default: "postgres")
      host = ask("Database host: ", default: "localhost")
      port = ask("Database port: ", default: "5432")
      dbusername = ask("Database username: ", default: ENV.fetch("DB_USERNAME", nil))
      password = ask("Database password: ", default: ENV.fetch("DB_PASSWORD", nil))

      MetabaseCli::DatabaseService.new(
        client_name: client_name,
        dbname: dbname,
        engine: engine,
        host: host,
        port: port,
        dbusername: dbusername,
        password: password
      ).create_database.set_default_permissions
    end
  end
end
