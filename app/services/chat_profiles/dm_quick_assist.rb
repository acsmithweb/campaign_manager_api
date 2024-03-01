class ChatProfiles::DmQuickAssist
  attr_accessor :client

  ENCOUNTER_PROMPT = "You are a DM reference tool that will accurately and concisely provide me information that I request related to the information I provide you please strip out anything in square brackets in your re."

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
    match_data = context.match(/\[(.*?)\]/)

    if match_data
      content_within_brackets = match_data[1]
      words = content_within_brackets.split(":")
      case words[0].downcase
      when 'creature'
        model = StatBlock
      when 'item','spell'
        model = words[0]&.constantize
      end
      context << model&.find_by_name(words[1].titleize)&.to_markdown
    else
      context
    end
  end
end
