class ChatProfiles::NpcEmulator < ChatProfiles::BaseProfile

  ENCOUNTER_PROMPT = "You are a roleplaying character. Respond in first person, as if you are that character.
  Describe your actions and words. Wait for others to respond before continuing.
  Begin each post with your character's name followed by a colon."

  private

  def add_context(context)
    record = Dir.glob("/shared_hdd/My Drive/Dnd Stuff/Campaigns/CampaignNotes/OrlaCampaign/**/*").select{|file| file.match(/#{Regexp.escape(context)}/i)}.first
    if record.present?
      file = URI.unescape(File.read(record))
      context << "\n The following is the context for the character you are playing as. #{file}."
    else
      context << "#{context} remember: #{ENCOUNTER_PROMPT}"
    end
  end
end
