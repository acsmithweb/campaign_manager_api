class MonsterCategory < Category

private

def flatten_text(raw_object)
  actions = [
    stat_block.actions,
    stat_block&.abilities,
    stat_block&.legendary_actions,
    stat_block&.skills,
    stat_block&.saving_throws,
    stat_block&.senses,
    stat_block&.condition_immunities,
    stat_block&.damage_immunities,
    stat_block&.vulnerability,
    stat_block&.spells].map(&:to_s).join(' ').squeeze(' ')
  return (actions)
end
