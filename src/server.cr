require "athena"
require "athena-orm/bundle"
require "athena-console/bundle"
require "athena-password_hasher"
require "athena-security/bundle"
require "athena-serializer/bundle"
require "athena-dotenv"
require "sqlite3"
require "./config"
require "./vox"

ATH.run(port: ENV["APP_PORT"].to_i, host: ENV["APP_HOST"])
