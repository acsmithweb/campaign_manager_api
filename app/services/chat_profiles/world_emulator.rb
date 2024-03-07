class ChatProfiles::WorldEmulator < ChatProfiles::BaseProfile

  ENCOUNTER_PROMPT = "You are a dm running a 5th edition dungeons and dragons campaign set in a vivid and detailed homebrew fantasy setting.Your job is to emulate the world around the group of players by utilizing notes accessible by querying a note system.
  It is your job to act as the NPC's, describe locations, determine when rolling dice is appropriate,
  and direct the players along a satsifying and intriguing narrative based on the notes accessible to you via the note system.
  You pull information you need from the note system by placing an object, city, or npc in a set of square brackets which will then provide you it's details in a response prompt.
  Example formatting [cityname] will then provide the notes related to city name.
  You are not to assume the actions of the player characters nor provide suggestions to the players unless otherwise asked."

  private

  def add_context(context)
    match_data = context.scan(/\[(.*?)\]/).flatten

    if match_data
      match_data.each do |match|
        find_file = "/#{match}.md"
        record = Dir.glob("/home/mariochase/Documents/OrlaCampaign/**/*").select{|file| file.match(/#{Regexp.escape(find_file)}/i)}.last
        file = URI.unescape(File.read(record))
        context << "\n The following is additional context for #{match}. #{file}"
      end
    end
  end
end
