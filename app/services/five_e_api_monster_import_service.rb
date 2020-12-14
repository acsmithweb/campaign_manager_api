class FiveEApiMonsterImportService

  def execute()
    import_monsters
  end

  def import_monsters
    monsters = Adapters::FiveEApiAdapter.get_details_for('monsters')
    monsters.each{|monster|
      monster_attributes = monster_details(ActiveSupport::JSON.decode(monster))
      new_monster = StatBlock.create(monster_attributes)
    }
  end

  private

  def monster_details(monster)
    @monster = monster
    monster_attributes = {
      name: name,
      armor_class: armor_class,
      hit_points: hit_points,
      hit_dice: hit_dice,
      speed: speed,
      str: str,
      dex: dex,
      con: con,
      int: int,
      wis: wis,
      cha: cha,
      saving_throws: saving_throws,
      skills: skills,
      damage_resistance: damage_resistance,
      condition_immunities: condition_immunities,
      damage_immunities: damage_immunities,
      vulnerability: vulnerability,
      senses: senses,
      languages: languages,
      challenge_rating: challenge_rating,
      experience_points: experience_points,
      abilities: abilities,
      actions: actions,
      legendary_actions: legendary_actions,
      creature_type: creature_type,
      alignment: alignment
    }
  end

  def name
    @monster['name']
  end

  def armor_class
    @monster['armor_class']
  end

  def hit_points
    @monster['hit_points']
  end

  def hit_dice
    @monster['hit_dice']
  end

  def speed
    speed = ''
    @monster['speed'].each{|movement_type, movement_speed| speed += "#{movement_type}: #{movement_speed} \n" }
    speed
  end

  def str
    @monster['strength']
  end

  def dex
    @monster['dexterity']
  end

  def con
    @monster['constitution']
  end

  def int
    @monster['intelligence']
  end

  def wis
    @monster['wisdom']
  end

  def cha
    @monster['charisma']
  end

  def saving_throws
    saving_throws_string = ''
    if @monster['proficiencies'].empty? == false
      @monster['proficiencies'].each{|saving_throw|
        if saving_throw['proficiency']['name'].include? "Saving Throw:"
          saving_throws_string += saving_throw['proficiency']['name'].to_s.gsub('Saving Throw:','') + ' +' + saving_throw['value'].to_s + "\n"
        end
      }
    end
    saving_throws_string
  end

  def skills
    skills_string = ''
    if @monster['proficiencies'].empty? == false
      @monster['proficiencies'].each{|skill|
        if skill['proficiency']['name'].include? "Skill:"
          skills_string += skill['proficiency']['name'].to_s.gsub('Skill:', '') + ' +' + skill['value'].to_s + "\n"
        end
      }
    end
    skills_string
  end

  def damage_resistance
    damage_resistances_string = ''
    unless @monster['damage_resistances'].empty?
      @monster['damage_resistances'].each{|resistance| damage_resistances_string << "#{resistance} \n"}
    else
      nil
    end
    damage_resistances_string
  end

  def condition_immunities
    condition_immunities_string = ''
    unless @monster['condition_immunities'].empty?
      @monster['condition_immunities'].each{|immunities| condition_immunities_string << "#{immunities['name']} \n"}
    else
      nil
    end
    condition_immunities_string
  end

  def damage_immunities
    damage_immunities_string = ''
    unless @monster['damage_immunities'].empty?
      @monster['damage_immunities'].each{|immunities| damage_immunities_string << "#{immunities} \n"}
    else
      nil
    end
    damage_immunities_string
  end

  def vulnerability
    vulnerability_string = ''
    unless @monster['damage_vulnerabilities'].empty?
      @monster['damage_vulnerabilities'].each{|damage_vulnerability| vulnerability_string << "#{damage_vulnerability} \n"}
    else
      nil
    end
    vulnerability_string
  end

  def senses
    senses = ''
    @monster['senses'].each{|sense_type, sense_range| senses += "#{sense_type}: #{sense_range} \n" }
    senses
  end

  def languages
    @monster['languages']
  end

  def challenge_rating
    @monster['challenge_rating']
  end

  def experience_points
    @monster['xp']
  end

  def abilities
    special_abilities = ''
    if @monster['special_abilities'].nil? == false
      @monster['special_abilities'].each{|ability|
        special_abilities += ability['name'].to_s + ": " + ability['desc'].to_s + "\n"
      }
    end
    special_abilities
  end

  def actions
    actions = ''
    if @monster['actions'].nil? == false
      @monster['actions'].each{|action|
        actions += action['name'].to_s + ": " + action['desc'].to_s + "\n"
      }
    end
    actions
  end

  def legendary_actions
    legendary_actions = ''
    if @monster['legendary_actions'].nil? == false
      @monster['legendary_actions'].each{|legendary_action|
        legendary_actions += legendary_action['name'].to_s + ": " + legendary_action['desc'].to_s + "\n"
      }
    end
    legendary_actions
  end

  def creature_type
    @monster['type'].to_s + @monster['subtype'].to_s
  end

  def alignment
    @monster['alignment']
  end
end
