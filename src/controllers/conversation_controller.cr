@[ADI::Register]
@[ARTA::Route("/api/conversations")]
class Vox::ConversationController < ATH::Controller
  def initialize(
    @em : AORM::EntityManagerInterface,
    @token_storage : ASEC::Authentication::Token::Storage::Interface,
  ); end

  @[ARTA::Get("", name: "app_conversations_index")]
  def conversations : Array(Vox::Entities::Conversation)
    @em.repository(Vox::Entities::Conversation).find_all
  end

  @[ARTA::Post("/create", name: "app_conversations_create")]
  def create(@[ATHA::MapRequestBody] conversation_dto : ConversationDTO) : ATH::View(Hash(Symbol, String | Int32))
    conversation = Vox::Entities::Conversation.new

    if users = conversation_dto.users
      users.each do |username|
        user = @em.repository(Vox::Entities::User).find_one_by(username: username)
        conversation.users << user unless user.nil?
      end
    end

    @em.persist(conversation)
    @em.flush

    self.view({
      :code    => 201,
      :message => "Conversation successfully created",
    }, :created)
  end

  @[ARTA::Delete("/delete/{id}", name: "app_conversations_delete")]
  def delete(id : Int32) : ATH::View(Hash(Symbol, String | Int32))
    conversation = @em.repository(Vox::Entities::Conversation).find(id)

    unless conversation
      raise AHK::Exception::NotFound.new "Conversation not found"
    end

    @em.remove conversation
    @em.flush

    self.view({
      :code    => 200,
      :message => "Conversation successfully deleted",
    }, :ok)
  end

  @[ARTA::Get("/{id}", name: "app_conversations_show")]
  def show(id : Int32) : Array(Vox::Entities::Message)
    conversation = @em.repository(Vox::Entities::Conversation).find(id)

    unless conversation
      raise AHK::Exception::NotFound.new "Conversation not found"
    end

    conversation.messages.to_a
  end

  @[ARTA::Post("/{id}/send", name: "app_conversations_send")]
  def send(id : Int32, @[ATHA::MapQueryParameter] msg : String) : ATH::View(Hash(Symbol, String | Int32))
    conversation = @em.repository(Vox::Entities::Conversation).find(id)
    current_user = @token_storage.token.try(&.user).as(Vox::Entities::User)

    unless conversation
      raise AHK::Exception::NotFound.new "Conversation not found"
    end

    message = Vox::Entities::Message.new
    message.message = msg
    message.conversation = conversation
    message.user = current_user

    @em.persist(message)
    @em.flush

    self.view({
      :code    => 201,
      :message => "Message sent",
    }, :created)
  end
end
