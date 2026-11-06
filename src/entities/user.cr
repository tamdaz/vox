@[AORMA::Entity(repository_class: Vox::UserRepository)]
@[AORMA::Table(name: "users")]
@[ASRA::ExclusionPolicy(:all)]
@[ASRA::AccessorOrder(
  :custom, order: %w[id username]
)]
class Vox::Entities::User < AORM::Entity
  include APH::PasswordAuthenticatedUserInterface
  include ASEC::User::Interface
  include ASR::Serializable

  @[AORMA::Column]
  @[AORMA::ID]
  @[AORMA::GeneratedValue]
  @[ASRA::Expose]
  property! id : Int64

  @[AORMA::Column]
  @[ASRA::Expose]
  property! username : String

  # Cannot save roles to the DB. AORM cannot store an array of string.
  property roles : Array(String) = ["USER_ROLE"]

  @[AORMA::Column]
  @[ASRA::IgnoreOnSerialize]
  property! password : String

  @[AORMA::Column]
  @[ASRA::IgnoreOnSerialize]
  property! api_token : String

  @[AORMA::Column]
  property! created_at : Time

  @[AORMA::Column]
  property! updated_at : Time

  def initialize; end

  def user_identifier : String
    username
  end

  @[AORMA::PrePersist]
  def set_created_at : Nil
    @created_at = @updated_at = Time.utc
  end

  @[AORMA::PreUpdate]
  def set_updated_at : Nil
    @updated_at = Time.utc
  end
end
