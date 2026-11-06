@[ADI::Register]
class Vox::PasswordAuthenticator < ASEC::Authenticator::AbstractAuthenticator
  alias TokenInterface = ASEC::Authentication::Token::Interface

  def supports?(request : AHTTP::Request) : Bool
    request.method == "POST"
  end

  def authenticate(request : AHTTP::Request) : ASEC::Authenticator::Passport
    unless body = request.body
      raise AHK::Exception::BadRequest.new("Invalid credentials")
    end

    credentials = JSON.parse(body).as_h

    username = credentials["username"].as_s
    password = credentials["password"].as_s

    ASEC::Authenticator::Passport.new(
      ASEC::Authenticator::Passport::Badge::User.new(username),
      ASEC::Authenticator::Passport::Credentials::Password.new(password),
    )
  end

  def on_authentication_success(request : AHTTP::Request, token : TokenInterface, firewall_name : String) : AHTTP::Response?
    nil
  end

  def on_authentication_failure(request : AHTTP::Request, exception : ASEC::Exception::Authentication) : AHTTP::Response?
    AHTTP::Response.new({
      :code    => 401,
      :message => exception.message_key,
    }.to_json, :unauthorized)
  end
end
