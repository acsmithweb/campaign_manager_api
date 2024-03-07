class ChatProfiles::BaseProfile
  attr_accessor :client
  
  ENCOUNTER_PROMPT = ""

  def initialize(api_key,context)
    @client = Facades::GeminiApiFacade.new(api_key)
    add_context(context)
    client.chat("#{ENCOUNTER_PROMPT} #{context}")
    client.recent_response
  end

  def chat(conversation)
    add_context(conversation)
    client.chat(conversation)
    client.recent_response
  end

  private

  def add_context(context)
    return
  end
end
