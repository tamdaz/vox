@[AORMA::Entity]
@[AORMA::Table(name: "messages")]
@[ASRA::ExclusionPolicy(:all)]
@[ASRA::AccessorOrder(
  :custom, order: %w[id message sent_at user]
)]
class Vox::Entities::Message < AORM::Entity
  include ASR::Serializable

  @[AORMA::Column]
  @[AORMA::ID]
  @[AORMA::GeneratedValue]
  @[ASRA::Expose]
  property! id : Int64

  @[AORMA::Column]
  @[ASRA::Expose]
  property! message : String

  @[AORMA::Column]
  @[ASRA::Expose]
  property! sent_at : Time

  @[AORMA::ManyToOne(inversed_by: "messages")]
  property conversation : Vox::Entities::Conversation? = nil

  @[AORMA::OneToOne]
  @[AORMA::JoinColumn(name: "user_id", referenced_column_name: "id")]
  @[ASRA::Expose]
  property user : Vox::Entities::User? = nil

  def initialize; end

  @[AORMA::PrePersist]
  def set_sent_at : Nil
    @sent_at = Time.utc
  end
end
