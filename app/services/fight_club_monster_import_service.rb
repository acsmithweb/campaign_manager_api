class FightClubMonsterImportService
  def execute()
    import_monsters
  end

  def import_monsters
    monsters = Adapters::FightClubFiveEAdapter.retrieve_resource_collection('stat_blocks')
    monsters.each{|monster|
      monster_attributes = build_monster(monster)
      new_monster = StatBlock.create!(monster_attributes)
    }
  end

  private

  def build_monster(monster)
    @monster = monster
    monster_attributes = {
      name: name,
      armor_class: armor_class,
      size: size,
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
      alignment: alignment,
      slots: slots,
      spells: spells,
      environment: environment
    }
  end

  def name
    @monster['name']
  end

  def armor_class
    @monster['ac'].split(' ')[0]
  end

  def hit_points
    @monster['hp'].split(' ')[0]
  end

  def hit_dice
    @monster['hp'].split(' ')[1]
  end

  def size
    @monster['size']
  end

  def speed
    @monster['speed']
  end

  def str
    @monster['str']
  end

  def dex
    @monster['dex']
  end

  def con
    @monster['con']
  end

  def int
    @monster['int']
  end

  def wis
    @monster['wis']
  end

  def cha
    @monster['cha']
  end

  def saving_throws
    @monster['save']
  end

  def experience_points
    0
  end

  def skills
    skill_string = ''
    @monster['skill'] +
    skill_string += @monster['skill'] unless @monster['skill'].nil?
    skill_string += " passive perception: " + @monster['passive'] unless @monster['passive'].nil?
    skill_string
  end

  def languages
    @monster['languages']
  end

  def challenge_rating
    return 0 if @monster['cr'].nil?
    fraction_check = @monster['cr'].split('/')
    if fraction_check[1].present?
      cr = fraction_check[0].to_f / fraction_check[1].to_f
    else
      cr = @monster['cr'].to_i
    end
    cr
  end

  def damage_resistance
    @monster['resist'] unless @monster['resist']
  end

  def damage_immunities
    @monster['immune'] unless @monster['immune']
  end

  def condition_immunities
    @monster['conditionImmune'] unless @monster['conditionImmune']
  end

  def vulnerability
    @monster['vulnerable'] unless @monster['vulnerable']
  end

  def senses
    @monster['senses'] unless @monster['senses']
  end

  def abilities
    ability_string = ''
    unless @monster['trait'].nil?
      if @monster['trait'].kind_of?(Array)
        @monster['trait'].each{|trait|
          ability_string += trait['name'].to_s + ': ' unless trait['name'].nil?
          ability_string += condense_array(trait['text']) unless trait['text'].nil?
        }
      else
        ability_string += @monster['trait']['name'].to_s + ': '
        ability_string += condense_array(@monster['trait']['text']) unless @monster['trait']['text'].nil?
      end
    end
    unless @monster['reaction'].nil?
      if @monster['reaction'].kind_of?(Array)
        @monster['reaction'].each{|trait|
          ability_string += trait['name'].to_s + ': ' unless trait['name'].nil?
          ability_string += condense_array(trait['text']) unless @monster['reaction'].nil?
        }
      else
        ability_string += @monster['reaction']['name'].to_s + ': ' unless @monster['name'].nil?
        ability_string += condense_array(@monster['reaction']['text']) unless @monster['reaction']['text'].nil?
      end
    end
    ability_string
  end

  def actions
    action_string = ''
    unless @monster['action'].nil?
      if @monster['action'].kind_of?(Array)
        @monster['action'].each{|trait|
          action_string += trait['name'].to_s + ': ' unless trait['name'].nil?
          action_string += condense_array(trait['text']) unless trait['text'].nil?
          action_string += condense_array(trait['attack']) unless trait['attack'].nil?
          action_string += condense_array(trait['description']) unless trait['description'].nil?
        }
      else
        action_string += @monster['action']['name'].to_s + ': ' unless @monster['action']['name'].nil?
        action_string += condense_array(@monster['action']['text']) unless @monster['action']['text'].nil?
        action_string += condense_array(@monster['action']['attack']) unless @monster['action']['attack'].nil?
        action_string += condense_array(@monster['action']['description']) unless @monster['action']['description'].nil?
      end
    end
    action_string
  end

  def legendary_actions
    action_string = ''
    unless @monster['legendary'].nil?
      if @monster['legendary'].kind_of?(Array)
        @monster['legendary'].each{|trait|
          action_string += trait['name'].to_s + ': ' unless trait['name'].nil?
          action_string += condense_array(trait['text']) unless trait['text'].nil?
        }
      else
        action_string += condense_array(@monster['legendary']['name']) + ': ' unless @monster['legendary']['name'].nil?
        action_string += condense_array(@monster['legendary']['description']) unless @monster['legendary']['description'].nil?
        action_string += condense_array(@monster['legendary']['text']) unless @monster['legendary']['text'].nil?
      end
    end
    action_string
  end

  def alignment
    @monster['alignment'] unless @monster['alignment'].nil?
  end

  def creature_type
    @monster['type'] unless @monster['type'].nil?
  end

  def slots
    @monster['slots'] unless @monster['slots'].nil?
  end

  def spells
    @monster['spells'] unless @monster['spells'].nil?
  end

  def environment
    @monster['environment'] unless @monster['environment'].nil?
  end

  def description
    @monster['description'] unless @monster['description'].nil?
  end

  private

  def condense_array(test_value)
    condensed_value = test_value.kind_of?(Array) ? test_value.join("\n").to_s : test_value.to_s + "\n"
  end
end
