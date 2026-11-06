@[AORMA::Entity]
@[AORMA::Table(name: "conversations")]
@[ASRA::ExclusionPolicy(:all)]
@[ASRA::AccessorOrder(
  :custom, order: %w[id number_of_users number_of_messages created_at updated_at]
)]
class Vox::Entities::Conversation < AORM::Entity
  include ASR::Serializable

  @[AORMA::Column]
  @[AORMA::ID]
  @[AORMA::GeneratedValue]
  @[ASRA::Expose]
  property! id : Int64

  @[AORMA::ManyToMany]
  @[AORMA::JoinTable(name: "users_conversations")]
  @[AORMA::JoinColumn(name: "conversation_id", referenced_column_name: "id")]
  @[AORMA::InverseJoinColumn(name: "user_id", referenced_column_name: "id")]
  property users : AORM::Collection(Vox::Entities::User) = AORM::ArrayCollection(Vox::Entities::User).new

  @[AORMA::OneToMany(mapped_by: "conversation")]
  property messages : AORM::Collection(Vox::Entities::Message) = AORM::ArrayCollection(Vox::Entities::Message).new

  @[AORMA::Column]
  @[ASRA::Expose]
  property! created_at : Time

  @[AORMA::Column]
  @[ASRA::Expose]
  property! updated_at : Time

  def initialize; end

  def add_user(user : Vox::Entities::User) : Nil
    @users << user
    user.conversations << self
  end

  @[AORMA::PrePersist]
  def set_created_at : Nil
    @created_at = @updated_at = Time.utc
  end

  @[AORMA::PreUpdate]
  def set_updated_at : Nil
    @updated_at = Time.utc
  end

  @[ASRA::VirtualProperty]
  def number_of_users : Int32
    @users.size
  end

  @[ASRA::VirtualProperty]
  def number_of_messages : Int32
    @messages.size
  end
end
