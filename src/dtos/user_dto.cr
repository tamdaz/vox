struct UserDTO
  include JSON::Serializable

  getter username : String

  getter password : String

  def initialize(@username : String, @password : String); end
end
