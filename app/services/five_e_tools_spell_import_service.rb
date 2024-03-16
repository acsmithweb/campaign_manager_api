class FiveEToolsImportBestiaryService
  URL = './external-files/5e_tools_master_data/'

  def self.read_from_folder(resource_folder)
    Dir.glob("#{URL}/#{resource_folder}/*.json").each do |file_path|
      next if file_path.match('foundry') or file_path.match('sources')
      json_object = read(file_path)
    end
  end

  def self.read(file_path)
    file = File.read(file_path)
    source_json = JSON.parse(file)
    return nil if source_json["spell"].nil?
    source_json["spell"].each do |spell_json|
      Spell.create!(transform_json(spell_json)) unless StatBlock.find_by_name(spell_json["name"])
    end
  end

  def transform_json(spell_json)
    components = spell_json["components"]
    {
      name: spell_json["name"],
      level: spell_json["level"],
      school: spell_json["school"],
      casting_time: spell_casting_time(spell_json["time"]),
      range: spell_range(spell_json["range"]),
      components: components["components"],
      material: components["materials"],
      duration: spell_duration(spell_json["duration"]),
      desc: spell_description(spell_json["entries"]),
      higher_level: spell_at_level(spell_json["entriesHigherLevel"]),
      damage_type: spell_json["damageInflict"].join(","),
      dc: spell_json["savingThrow"].join(","),
      attack_type: spell_attack(spell_json["spellAttack"])
    }
  end

  def self.spell_attack(spell_json)
    element = spell_json.first
    case element
    when 'M'
      "Melee"
    when 'R'
      "Ranged"
    end
  end

  def self.spell_casting_time(casting_time_json)
    casting_string = []
    casting_time_json.each do |casting_time|
      casting_string << "#{casting_time["number"]} #{casting_time["unit"]}"
    end
    casting_string.join("\n")
  end

  def self.spell_range(range_json)
    range_string = []
    range_json.each do |range|
      range_string << "#{range["type"]} \n #{range["distance"]["amount"]}#{range["distance"]["type"]}"
    end
    range_string.join("\n")
  end

  def self.spell_components(components_json)
    components_string = []
    material = nil
    components.each do |key, value|
      if key.match("m")
        material = value
      end
      components_string << "#{key}" if value
    end
    {components: components_string.join(","), materials: material}
  end

  def self.spell_duration(range_json)
    range_string = []
    range_json.each do |range|
      if range["type"].match('instant')
        range_string << "#{range["type"]}"
      else
        range_string << "#{range["type"]} \n #{range["duration"]["amount"]}#{range["duration"]["type"]}"
      end
    end
    range_string.join("\n")
  end

  def self.spell_description(spell_entries)
    spell_entries.join("\n")
  end

  def self.effect_at_higher_level(spell_higher_levels)
    spell_higher_levels["entries"].join("\n")
  end
end
