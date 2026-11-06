require "./controllers/**"
require "./commands/**"
require "./entities/**"
require "./dtos/**"
require "./security/**"
require "./repositories/**"
require "./listeners/**"

module Vox
  VERSION = "0.1.0"

  Log.setup do |config|
    file_backend = Log::IOBackend.new(File.open("var/log/dev.log", "a"))
    stdout_backend = Log::IOBackend.new(STDOUT)

    config.bind "*", :info, file_backend
    config.bind "*", :info, stdout_backend
  end
end
