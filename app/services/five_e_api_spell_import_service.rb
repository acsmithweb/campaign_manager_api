
class FiveEApiSpellImportService

  def execute()
    import_spells
  end

  def import_spells
    spells = Adapters::FiveEApiAdapter.get_details_for('spells')
    spells.each{|spell|
      spell_attributes = spell_details(ActiveSupport::JSON.decode(spell))
      new_spell = Spell.create(spell_attributes)
    }
  end

  private

  def spell_details(spell)
    @spell = spell
    spell_attributes = {
      name: name,
      desc: desc,
      higher_level: higher_level,
      range: range,
      components: components,
      material: material,
      ritual: ritual,
      duration: duration,
      concentration: concentration,
      casting_time: casting_time,
      level: level,
      attack_type: attack_type,
      damage_at_slot_level: damage_at_slot_level,
      school: school,
      classes: classes,
      dc: dc,
      area_of_effect: area_of_effect,
      heal_at_slot_level: heal_at_slot_level,
      dc_success: dc_success,
      damage_type: damage_type,
      damage_at_character_level: damage_at_character_level
    }
    return spell_attributes
  end

  def name
    @spell['name']
  end

  def desc
    @spell['desc']
  end

  def higher_level
    @spell['higher_level']
  end

  def range
    @spell['range']
  end

  def components
    @spell['components']
  end

  def material
    @spell['material']
  end

  def ritual
    @spell['ritual']
  end

  def duration
    @spell['duration']
  end

  def concentration
    @spell['concentration']
  end

  def casting_time
    @spell['casting_time']
  end

  def level
    @spell['level']
  end

  def attack_type
    @spell['attack_type']
  end

  def damage_at_slot_level
    @spell['damage']['damage_at_slot_level'] unless @spell['damage'].nil?
  end

  def school
    @spell['school']['name']
  end

  def classes
    class_array = Array.new
    @spell['classes'].each{|character_class| class_array.push(character_class['name'])}
    @spell['subclasses'].each{|subclass| class_array.push(subclass['name'])}
    class_array
  end

  def dc
    if @spell['dc'].nil? == false
      @spell['dc']['dc_type']['name'] + ',' + @spell['dc']['dc_success']
    else
      nil
    end
  end

  def dc_success
    if @spell['dc'].nil? == false
      @spell['dc']['dc_success']
    else
      nil
    end
  end

  def area_of_effect
    @spell['area_of_effect']
  end

  def heal_at_slot_level
    @spell['heal_at_slot_level'] unless @spell['heal_at_slot_level'].nil?
  end

  def damage_type
    if @spell['damage'].nil? == false
      @spell['damage']['damage_type']['name'] unless @spell['damage']['damage_type'].nil?
    end
    nil
  end

  def damage_at_character_level
    @spell['damage']['damage_at_character_level'] unless @spell['damage'].nil?
  end
end
