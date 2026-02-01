class ChatProfiles::WorldBuilding < ChatProfiles::BaseProfile

  ENCOUNTER_PROMPT = "I would like to ask you questions about my homebrew dnd setting.
  I do not want you to generate any new information unless requested, and only form answers by referencing what is available in the context that provided.
  Context will not be displayed to the user. Context relevant to the discussion at hand may be provided and will be inserted between two square brackets
  formatted as follows [Context Body]."

  private

  def add_context(context)
    prompt_container = PromptContainer.new(context)
    prompt_context = prompt_container.retrieve_relevant_text
    context << "[#{prompt_context}] \n #{context}"
  end
end
