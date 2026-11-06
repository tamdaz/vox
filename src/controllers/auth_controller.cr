require "random/secure"

@[ADI::Register]
class Vox::AuthController < ATH::Controller
  def initialize(
    @em : AORM::EntityManagerInterface,
    @token_storage : ASEC::Authentication::Token::Storage::Interface,
  ); end

  @[ARTA::Post("/auth/login", name: "app_auth_login")]
  def login : ATH::View(Hash(Symbol, Int64 | String))
    current_user = @token_storage.token.try(&.user).as(Vox::Entities::User)

    self.view({
      :id       => current_user.id,
      :username => current_user.username,
      :token    => current_user.api_token,
    }, :created)
  end

  # Creates a user account.
  @[ARTA::Post("/auth/register", name: "app_auth_register")]
  def register(@[ATHA::MapRequestBody] user_dto : UserDTO) : ATH::View(Hash(Symbol, String | Int32))
    hasher = APH::UserPasswordHasher.new APH::Factory.new({
      Vox::Entities::User => APH::Native.new,
    })

    user = Vox::Entities::User.new
    user.username = user_dto.username
    user.password = hasher.hash_password(user, user_dto.password)
    user.api_token = Random::Secure.urlsafe_base64(32)

    @em.persist(user)
    @em.flush

    self.view({
      :code    => 201,
      :message => "User successfully added",
    }, :created)
  end
end
