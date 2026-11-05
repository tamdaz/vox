struct ConversationDTO
  include JSON::Serializable

  getter users : Array(String)?

  def initialize(@users : Array(String)?); end
end
