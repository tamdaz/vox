@[ADI::Register]
class Vox::UserProvider
  include ASEC::User::Provider::Interface

  def initialize(@em : AORM::EntityManagerInterface); end

  def load_user_by_identifier(identifier : String) : ASEC::User::Interface
    user = @em.repository(Vox::Entities::User).find_one_by(username: identifier)

    unless user
      raise ASEC::Exception::UserNotFound.new "User '#{identifier}' not found.", user_identifier: identifier
    end

    user
  end

  def refresh_user(user : ASEC::User::Interface) : ASEC::User::Interface
    unless user.is_a? User
      raise ASEC::Exception::UnsupportedUser.new "Instances of '#{user.class}' are not supported."
    end

    self.load_user_by_identifier user.user_identifier
  end

  def supports_class?(klass : ASEC::User::Interface.class) : Bool
    klass <= User
  end
end
