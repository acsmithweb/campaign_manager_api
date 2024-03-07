class ChatProfiles::CombatEncounter < ChatProfiles::BaseProfile

  ENCOUNTER_PROMPT = "I need you to act on behalf of the monsters and what is appropriate based on their skill sets, environment, and the context leading up to the turn in question.
Any time an attack or ability is used any dice rolls that would be made will be placed in square brackets with the number of dice, the size of the dice, and any additional modifiers e.g: [2d12 + 4]. also provide the DC save of the appropriate ability or spell when applicable e.g [DC 14 Dex]. Unless stated otherwise the creature may take a single action, bonus action, and move up to it's move speed. make sure that you act as the creature would given the circumstances and its stats. Any time the creature moves tell me who it moves towards and how many feet it moves if it decides to move.
I will provide a description of the environment as well as the creatures that you will be representing in this encounter. Do not assume a creature has taken damage from a player character unless I say otherwise. I will provide the creatures information in order of initiative. All creatures involved are allied with one another and will not attack one another unless specified.
I will provide the necessary context such as who attacked it and how much damage that character inflicted on it. I will also ask for relevant modifiers for when a particular saving throw is required and expect the relevant creatures save. In the event of multiple creatures we will assign each creature a number based on it's initiative order and we can use that to reference."

  private

  def add_context(context)
    creatures = context.scan(/\[(.*?)\]/).flatten
    creatures.each do |creature|
      context << StatBlock.find_by_name(creature.capitalize)&.to_markdown.to_s
    end
  end
end
