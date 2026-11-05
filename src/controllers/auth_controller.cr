require "random/secure"

@[ADI::Register]
class Vox::AuthController < ATH::Controller
  def initialize(@em : AORM::EntityManagerInterface); end

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
