class ChatProfiles::ContextProvider < ChatProfiles::BaseProfile

  ENCOUNTER_PROMPT = "I will feed you dialogue that originates from NPCs and Players and it's your job to identify which files are relevant for the conversation at hand. here is the list of files. I want you to only respond with file names that are appropriate for the context.
The following file paths are all related to my dnd fantasy setting that I want you to use for context. Related Files: {List of relevant files}"

  private

  def add_context(context)
    context << "\n The following is the quest index context. #{file} please set the scene for quest 1."
  end
end
