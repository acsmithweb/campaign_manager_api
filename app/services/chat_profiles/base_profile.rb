class ChatProfiles::BaseProfile
  attr_accessor :client

  ENCOUNTER_PROMPT = ""

  def initialize(api_key,context)
    @client = Facades::GeminiApiFacade.new(api_key)
    add_context(context)
    client.chat("#{context} #{ENCOUNTER_PROMPT}")
    client.recent_response
  end

  def last_response
    client.recent_response
  end

  def chat(conversation)
    add_context(conversation)
    client.chat(conversation)
    client.recent_response
  end

  def chat_history
    client.content
  end

  private

  def add_context(context)
    return context
  end
end
