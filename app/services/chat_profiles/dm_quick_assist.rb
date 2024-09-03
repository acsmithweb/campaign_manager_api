class ChatProfiles::DmQuickAssist < ChatProfiles::BaseProfile

  ENCOUNTER_PROMPT = "You are a DM reference tool that will accurately and concisely provide me information that I request related to the information I provide you."

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
        model = words[0]&.capitalize.constantize
      end
      context << "|markdown entry: #{model&.find_by_name(words[1].titleize)&.to_markdown}"
    else
      context
    end
  end
end
