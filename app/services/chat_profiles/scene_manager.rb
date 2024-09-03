class ChatProfiles::SceneManager < ChatProfiles::BaseProfile

  ENCOUNTER_PROMPT = "The following is the contains information related to a quest in my dnd setting. You are not to act on behalf of any party members, players, or locations. You will only provide the locations and characters in a concise format that includes the atmosphere of the current scene as well as the current characters goals and current attitude so that other AI instances can act out those characters and locations."

  def add_context(context)
    record = Dir.glob("/shared_hdd/My Drive/Dnd Stuff/Campaigns/CampaignNotes/OrlaCampaign/**/*").select{|file| file.match(/#{Regexp.escape(context)}/i)}.first
    puts record
    file = URI.unescape(File.read(record))
    puts file
    context << "\n The following is the quest index context. #{file} please set the scene."
  end
end
