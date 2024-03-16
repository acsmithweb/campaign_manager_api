class FiveEToolsImportBestiaryService
  URL = './external-files/5e_tools_master_data/'

  def self.read_from_folder(resource_folder)
    Dir.glob("#{URL}/#{resource_folder}/*.json").each do |file_path|
      json_object = read(file_path)
    end
  end

  def self.read(file_path)
    file = File.read(file_path)
    source_json = JSON.parse(file)
    return nil if source_json["monster"].nil?
    source_json["monster"].each do |monster_json|
      next if monster_json["_copy"].present? || monster_json["effects"].present?
      StatBlock.create!(transform_json(monster_json)) unless StatBlock.find_by_name(monster_json["name"])
    end
  end

  def self.transform_json(source_json)
    # Parse the source JSON
    source_data = source_json

    # Transform the data
    transformed_data = {
      "name" => source_data["name"],
      "size" => check_present(source_data["size"]&.first),
      "armor_class" => format_ac(source_data["ac"]).to_i,
      "hit_points" => check_present(source_data["hp"],'average').to_i,
      "hit_dice" => check_present(source_data["hp"],'formula'),
      "speed" => format_movement(source_data['speed']),
      "str" => check_present(source_data["str"]).to_i,
      "dex" => check_present(source_data["dex"]).to_i,
      "con" => check_present(source_data["con"]).to_i,
      "int" => check_present(source_data["int"]).to_i,
      "wis" => check_present(source_data["wis"]).to_i,
      "cha" => check_present(source_data["cha"]).to_i,
      "saving_throws" => saving_throws(source_data['save']),
      "skills" => skill_strings(source_data['skill']),
      "damage_resistance" => format_resistance(source_data["resist"]),
      "condition_immunities" => join_array(source_data["conditionImmune"]),
      "damage_immunities" => join_array(source_data["immune"]),
      "vulnerability" => join_array(source_data["vulnerable"]),
      "senses" => join_array(source_data["senses"]),
      "languages" => join_array(source_data["languages"]),
      "challenge_rating" => check_present(source_data["cr"]).to_i,
      "experience_points" => 0,
      "abilities" => format_abilities(source_data),
      "actions" => format_traits(source_data["action"]),
      "legendary_actions" => format_traits(source_data["legendary"]),
      "creature_type" => source_data["type"]["type"],
      "alignment" => join_array(source_data["alignment"]),
      "created_at" => Time.now.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
      "updated_at" => Time.now.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
      "environment" => join_array(source_data["environment"]), # You might want to generate this dynamically
      "description" => nil,
      "slots" => slots(source_data["spellcasting"]),
      "spells" => spells(source_data["spellcasting"])
    }

    # Return the transformed data as JSON
    transformed_data
  end

  def self.format_abilities(source_data)
    abilities = []
    if source_data["trait"].present?
     abilities << format_traits(source_data["trait"])
    end

    if source_data.key?("spellcasting")
      abilities << "Spellcasting: #{format_spellcasting(source_data["spellcasting"])}"
    end

    if source_data.key?("reaction")
      abilities << "Reactions: #{format_traits(source_data["reaction"])}" unless source_data["reaction"].empty?
    end
    abilities.join("\n")
  end

  def self.slots(value)
    return if value.nil? || value.first["spells"]&.keys.nil?
    slot_count = []
    value.first["spells"].keys.each do |key|
      slot_count << value.first["spells"][key]["slots"]
    end
    join_array(slot_count.compact)
  end

  def self.spells(value)
    return if value.nil? || value.first["spells"]&.keys.nil?
    spells_known = []
    value.first["spells"].keys.each do |key|
      spells_known << "#{key.to_s} level spell: #{join_array(value.first["spells"][key]["spells"].compact).gsub(/\{|\}|@\w+\s|@h*/, "").strip} \n"
    end
    join_array(spells_known)
  end

  def self.format_movement(value)
    return nil unless check_present(value)
    movement_string = []
    value.each do |key, value|
      movement_string << "#{key} #{value} ft."
    end
    return movement_string.join(', ')
  end

  def self.format_ac(value)
    return 0 unless check_present(value)
    if value.first.is_a?(Hash)
      value.first['ac']
    else
      value.first
    end
  end

  def self.format_spellcasting(value)
    spellcasting_info = []
    if value.is_a?(Array)
      value.each do |element|
        if element.is_a?(String)
          spellcasting_info << "#{element.gsub(/\{|\}|@\w+\s|@h*/, "").strip}"
        else
          spellcasting_info << format_spellcasting(element)
        end
      end
    elsif value.is_a?(Hash)
      value.map do |key, element|
        next if ["displayAs","ability","type","name","footerEntries"].include?(key)
        if key == "headerEntries"
          spellcasting_info << "#{element&.join(" ").gsub(/\{|\}|@\w+\s|@h*/, "").strip}"
        elsif element.is_a?(String)
          spellcasting_info << "#{key}:\n #{element.gsub(/\{|\}|@\w+\s|@h*/, "").strip}"
        else
          spellcasting_info << "#{key}:\n #{format_spellcasting(element)} "
        end
      end
    end
    spellcasting_info.join("\n ")
  end

  def self.format_traits(value)
    return nil unless check_present(value)
    if value.is_a?(Array)
      value.map do |a|
        "#{a['name']}: #{a['entries'].join("\n").gsub(/\{|\}|@\w+\s|@h*/, "").strip}"
      end.join("\n")
    else
      value.gsub(/\{|\}|@\w+\s|@h\s*/, "").strip
    end
  end

  def self.format_resistance(value)
    return nil unless check_present(value)
    resistances = []
    if value.is_a?(Array)
      value.each {|resist|
        if resist.is_a?(Hash) && resist['resist'].present?
          resistances << resist['resist'].join(',')
        else
          resistances << resist
        end
      }
      resistances.join(',')
    elsif value.is_a?(Hash)
      resistances << value['resist']
      if value['resist']['resist'].present?
        resistances << value['resist']['resist'].join(',')
      end
      join_array(resistances)
    else
      nil
    end
  end

  def self.join_array(value, join = true)
    unless value.nil?
      if join
        value.join(', ')
      else
        value
      end
    else
      nil
    end
  end

  def self.skill_strings(value)
    skill_string = []
    unless value.nil?
      value.each do |key, element|
        next if element.nil?
        skill_string << "#{key.capitalize} #{element}"
      end
      return join_array(skill_string.compact)
    else
      nil
    end
  end

  def self.saving_throws(value)
    saves_string = []
    unless value.nil?
      value.each do |key, element|
        next if element.nil?
        saves_string << "#{key.capitalize} #{element}"
      end
      return join_array(saves_string.compact)
    else
      nil
    end
  end

  def self.check_present(value,key=nil)
    return nil if value.nil?
    if value.kind_of?(Array)
      if value&.first&.present?
        value&.first
      elsif value.empty?
        nil
      end
    elsif value.present? && key.present?
      value[key]
    elsif value.kind_of?(Hash)
      value.first.last
    else
      value
    end
  end
end
