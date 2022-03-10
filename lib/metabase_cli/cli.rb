require 'thor'
require "metabase_cli/database_service"
require "metabase_cli/user_service"
require "metabase_cli/group_service"

module MetabaseCli
  class CLI < Thor
    desc 'version', 'Prints the version'

    def version
      puts "MetabaseApi version #{MetabaseCli::VERSION}"
    end

    desc 'create_database', 'Create a database'

    def create_database
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

    desc 'create_user', 'Create a user'

    def create_user
      first_name = ask("First name: ")
      last_name = ask("Last name: ")
      email = ask("Email: ")
      group_wanted = ask("Group wanted: ", default: "1")

      MetabaseCli::UserService.new(
        first_name: first_name,
        last_name: last_name,
        email: email,
        group_wanted: group_wanted
      ).create_user
                              .invite_again
    end

    desc 'create_group', 'Create a group'

    def create_group
      name = ask("Group name: ")

      MetabaseCli::GroupService.new(
        name: name
      ).create_group
    end
  end
end
