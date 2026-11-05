require "athena"
require "athena-orm/bundle"
require "athena-console/bundle"
require "athena-orm/migrations"
require "athena-password_hasher"
require "athena-security/bundle"
require "athena-serializer/bundle"
require "athena-dotenv"
require "sqlite3"
require "./config"
require "./vox"
require "./migrations/*"

ACON::Application.new("Vox", Vox::VERSION, ADI.container).run
