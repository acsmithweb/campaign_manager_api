class FightClubSpellImportService
  def execute()
    import_spells
  end

  def import_spells
    spells = Adapters::FightClubFiveEAdapter.retrieve_resource_collection('spells')
    spells.each{|spell|
      if spell['level'].nil?
        updated_spell = Spell.find_by_name(spell['name'])
        updated_spell.update_attributes(classes: updated_spell.classes + ', ' + spell['classes'])
      else
        spell_attributes = build_spell(spell)
        new_spell = Spell.create!(spell_attributes)
      end
    }
  end

  private

  def build_spell(spell)
    @spell = spell
    spell_attributes = {
      name: name,
      desc: desc,
      range: range,
      components: components,
      material: material,
      ritual: ritual,
      duration: duration,
      concentration: concentration,
      casting_time: casting_time,
      level: level,
      school: school,
      classes: classes
    }
    return spell_attributes
  end

  def name
    @spell['name']
  end

  def desc
    @spell['text']
  end

  def range
    @spell['range']
  end

  def components
    @spell['components']&.split(' (')[0] unless @spell['components'].nil?
  end

  def material
    @spell['components']&.split(' (')[1]&.gsub(')','') unless @spell['components'].nil?
  end

  def ritual
    @spell['ritual']&.match('YES').present?
  end

  def duration
    if @spell['duration']&.match('Concentration').present?
      return @spell['duration']&.split(', ')[1]
    else
      return @spell['duration']
    end
  end

  def concentration
    @spell['duration']&.match('Concentration').present?
  end

  def casting_time
    @spell['time']
  end

  def level
    @spell['level']
  end

  def school
    @spell['school']
  end

  def classes
    @spell['classes']
  end
end
