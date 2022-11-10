class ClassSubProcessing::BaseClassBuilder
  def self.build(class_info)
    class_info_attributes = build_class_info(class_info)
    if BaseClass.where(name: class_info_attributes[:name]).empty?
      return BaseClass.create(class_info_attributes)
    else
      return BaseClass.where(name: class_info_attributes[:name]).first
    end
  end

  def self.build_class_info(class_info)
    @class_info = class_info
    class_info_attributes = {
      name: @class_info['name'],
      hit_dice: @class_info['hd'],
      proficiencies: @class_info['proficiency'],
      num_skills: @class_info['numSkills'],
      casting_ability: casting_ability,
      armor: armor,
      weapons: weapons,
      tools: tools,
      wealth: @class_info['wealth']
    }
    return class_info_attributes
  end

  def self.casting_ability
    @class_info['spellAbility'] unless @class_info ['spellAbility'].nil?
  end

  def self.armor
    @class_info['armor'] unless @class_info ['armor'].nil?
  end

  def self.weapons
    @class_info['weapons'] unless @class_info ['weapons'].nil?
  end

  def self.tools
    @class_info['weapons'] unless @class_info ['weapons'].nil?
  end
end
