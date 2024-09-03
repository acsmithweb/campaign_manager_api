class FiveEToolsSpellImportService
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
      Spell.create!(transform_json(spell_json)) unless Spell.find_by_name(spell_json["name"])
    end
  end

  def self.transform_json(spell_json)
    components = spell_components(spell_json)
    duration = spell_duration(spell_json["duration"])
    {
      name: spell_json["name"],
      level: spell_json["level"],
      school: spell_school(spell_json["school"]),
      casting_time: spell_casting_time(spell_json["time"]),
      concentration: duration[:concentration],
      range: spell_range(spell_json["range"]),
      components: components[:components],
      material: components[:materials],
      duration: duration[:time],
      desc: spell_description(spell_json["entries"]),
      effect_at_slot_level: spell_at_level(spell_json["entriesHigherLevel"]),
      damage_type: spell_json["damageInflict"]&.join(","),
      dc: spell_json["savingThrow"]&.join(","),
      attack_type: spell_attack(spell_json["spellAttack"]),
      damage_at_character_level: spell_scaling(spell_json["scalingLevelDice"]),
      ritual: spell_ritual(spell_json)
    }
  end

  def self.spell_ritual(spell_json)
    if spell_json.key?("meta")
      return spell_json["meta"]["ritual"]
    else
      return false
    end
  end

  def self.spell_components(components_json)
    components_string = []
    material = nil
    components_json["components"].each do |key, value|
      if key.match("m")
        if value.is_a?(Hash)
          material = value["text"]
        else
          material = value
        end
      end
      components_string << "#{key}" if value
    end
    return {components: components_string.join(","), materials: "#{material}"}
  end

  def self.spell_school(school)
    case school
    when 'C'
      return 'Conjuration'
    when 'T'
      return 'Transmutation'
    when 'N'
      return 'Necromancy'
    when 'D'
      return 'Divination'
    when 'A'
      return 'Abjuration'
    when 'I'
      return 'Illusion'
    when 'V'
      return 'Evocation'
    when 'E'
      return 'Enchantment'
    end
  end

  def self.spell_at_level(higher_level_json)
    higher_level = []
    return nil if higher_level_json.nil?
    higher_level_json.each do |entry|
      higher_level << entry["entries"].join(',')
    end
    higher_level.join(',').gsub(/\{|\}|@\w+\s|@h*/, "").strip
  end

  def self.spell_scaling(spell_json)
    scaling_table = []
    return if spell_json.nil?
    if spell_json.is_a?(Array)
      spell_json.each do |element|
        if element["scaling"].present?
          scaling_table << "#{element["label"]}\n"
          element["scaling"].each do |key, value|
            scaling_table << "level #{key}: #{value}"
          end
        elsif element["entries"].present?
          scaling_table << spell_json["entries"].join(',')
        end
      end
    else
      spell_json["scaling"].each do |key, value|
        scaling_table << "level #{key}: #{value}"
      end
    end
    scaling_table.join(',').gsub(/\{|\}|@\w+\s|@h*/, "").strip
  end

  def self.spell_attack(spell_json)
    return if spell_json.nil?
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

    if range_json["type"].present? && range_json["type"].match('special')
      range_string << range_json["type"]
    elsif range_json["distance"]["type"] == ('touch')
      range_string << "#{range_json["type"]} #{range_json["distance"]["type"]}"
    else
      range_string << "#{range_json["type"]} #{range_json["distance"]["amount"]} #{range_json["distance"]["type"]}"
    end
    range_string.join("\n")
  end

  def self.spell_duration(range_json)
    range_string = []
    concentrate = false
    range_json.each do |range|
      if range.key?("concentration")
        concentrate = range['concentration']
      end
      if range["type"].match('instant')
        range_string << "#{range["type"]}"
      elsif range["type"].match('special')
        range_string << range["type"]
      elsif range["type"].match('permanent')
        range_string << "#{range["type"]} \n #{range["ends"]}"
      else
        range_string << "#{range["type"]} \n #{range["duration"]["amount"]}#{range["duration"]["type"]}"
      end
    end
    {time: range_string.join("\n"), concentration: concentrate}
  end

  def self.spell_description(spell_entries)
    entries = []
    spell_entries.each do |element|
      if element.is_a?(Hash)
        if element["type"].match("list")
          entries << element["items"].join('\n').gsub(/\{|\}|@\w+\s|@h*/, "").strip
        elsif element["type"].match("quote")
          entries << element["entries"].join('\n').gsub(/\{|\}|@\w+\s|@h*/, "").strip
        end
      else
        entries << element.gsub(/\{|\}|@\w+\s|@h*/, "").strip
      end
    end
    entries.join("\n")
  end

  def self.effect_at_higher_level(spell_higher_levels)
    spell_higher_levels["entries"].gsub(/\{|\}|@\w+\s|@h*/, "").strip.join("\n")
  end
end
