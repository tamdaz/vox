@[ADI::Register]
class APITokenAuthenticator < ASEC::Authenticator::AbstractAuthenticator
  def initialize(@em : AORM::EntityManagerInterface); end

  def supports?(request : AHTTP::Request) : Bool?
    request.headers.has_key? "x-api-token"
  end

  def authenticate(request : AHTTP::Request) : ASEC::Authenticator::Passport
    api_token = request.headers["x-api-token"]

    user = @em.repository(Vox::Entities::User).find_one_by(api_token: api_token)

    raise "User not found" if user.nil?

    ASEC::Authenticator::Passport::SelfValidating.new(
      ASEC::Authenticator::Passport::Badge::User.new(api_token) do |token|
        @em.repository(Vox::Entities::User).find_one_by(api_token: token)
      end
    )
  end

  def on_authentication_success(request : AHTTP::Request, token : ASEC::Authentication::Token::Interface, firewall_name : String) : AHTTP::Response?
    nil
  end

  def on_authentication_failure(request : AHTTP::Request, exception : ASEC::Exception::Authentication) : AHTTP::Response?
    AHTTP::Response.new exception.message_key, :unauthorized
  end
end
