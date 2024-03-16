class ChatProfiles::WorldBuilding < ChatProfiles::BaseProfile

  ENCOUNTER_PROMPT = "I would like to ask you questions about my homebrew dnd setting. I do not want you to generate any new information unless requested, and only reference what is available in the markdown content
that i provide. If you are need additional context you can request the details using the following format [filename.md] and followup response will provide the relevant file details for you to use for your answer simply reply with 'info_request: [filename.md]'.
Please request any relevant information you may need before answering the question Once all relevant information is given I will then follow with answer question: ."

  private

  def add_context(context)
    match_data = context.scan(/\[(.*?)\]/).flatten

    if match_data
      match_data.each do |match|
        find_file = "/#{match}.md"
        record = Dir.glob("/home/mariochase/Documents/OrlaCampaign/**/*").select{|file| file.match(/#{Regexp.escape(find_file)}/i)}.last
        file = URI.unescape(File.read(record))
        context << "The following is additional context for #{match}. #{file}"
      end
    end
  end
end
