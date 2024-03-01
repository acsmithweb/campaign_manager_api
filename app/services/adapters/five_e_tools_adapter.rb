class Adapters::FiveEToolsAdapter
  URL = './external-files/5e_tools_master_data/'

  def self.read_from_folder(resource_folder)
    puts Dir.glob("#{URL}/#{resource_folder}/*.json").count
    Dir.glob("#{URL}/#{resource_folder}/*.json").each do |file_path|
      json_object = read(file_path)
    end
  end

  def self.read(file_path)
    file = File.read(file_path)
    source_json = JSON.parse(file)
    puts '-----------------------------------------'
    return nil if source_json["monster"].nil?
    source_json["monster"].each do |monster_json|
      next if monster_json["_copy"].present? || monster_json["effects"].present?

      puts '========================================='
      puts monster_json['name']
      puts StatBlock.new(transform_json(monster_json)).abilities
    end
  end

  def self.transform_json(source_json)
    # Parse the source JSON
    source_data = source_json

    # Transform the data
    puts source_data
    transformed_data = {
      "name" => source_data["name"],
      "size" => check_present(source_data["size"]&.first),
      "armor_class" => format_ac(source_data["ac"]),
      "hit_points" => check_present(source_data["hp"]["average"]),
      "hit_dice" => check_present(source_data["hp"]["formula"]),
      "speed" => format_movement(source_data['speed']),
      "str" => source_data["str"],
      "dex" => source_data["dex"],
      "con" => source_data["con"],
      "int" => source_data["int"],
      "wis" => source_data["wis"],
      "cha" => source_data["cha"],
      "saving_throws" => saving_throws(source_data['save']),
      "skills" => skill_strings(source_data['skill']),
      "damage_resistance" => format_resistance(source_data["resist"]),
      "condition_immunities" => join_array(source_data["conditionImmune"]),
      "damage_immunities" => join_array(source_data["immune"]),
      "vulnerability" => join_array(source_data["vulnerable"]),
      "senses" => join_array(source_data["senses"]),
      "languages" => join_array(source_data["languages"]),
      "challenge_rating" => check_present(source_data["cr"].to_s),
      "experience_points" => 0,
      "abilities" => "#{format_abilities(source_data['trait'])}, Spellcasting #{format_spellcasting(source_data['spellcasting'])}, Reactions: #{format_abilities(source_data['reaction'])}",
      "actions" => format_abilities(source_data["action"]),
      "legendary_actions" => format_abilities(source_data["legendary"]),
      "creature_type" => source_data["type"]["type"],
      "alignment" => join_array(source_data["alignment"]),
      "created_at" => Time.now.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
      "updated_at" => Time.now.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
      "environment" => join_array(source_data["environment"]), # You might want to generate this dynamically
      "description" => nil,
      "slots" => nil,
      "spells" => nil
    }

    # Return the transformed data as JSON
    transformed_data
  end

  def self.format_movement(value)
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
    return "" unless check_present(value)
    spellcasting_info = []
    if value.is_a?(Array)
      spellcasting_info << value.map{ |key, value|
        "#{key}: #{value}"
      }.join("\n")
    else
      value
    end
  end

  def self.format_abilities(value)
    return "" unless check_present(value)
    puts value.inspect
    if value.is_a?(Array)
      value.map{ |a| "#{a['name']} #{a['entries'].join("\n")}" }.join("\n")
    else
      value
    end
  end

  def self.format_resistance(value)
    return "" unless check_present(value)
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
      resistances.join(', ')
    else
      value
    end
  end

  def self.join_array(value, join = true)
    unless value.nil?
      if join
        value.join(',')
      else
        value
      end
    else
      []
    end
  end

  def self.skill_strings(value)
    skill_string = []
    unless value.nil?
      value.each do |key, value|
        skill_string << "#{key.capitalize} #{value},"
      end
      return skill_string.join(' ,')
    else
      skill_string
    end
  end

  def self.saving_throws(value)
    saves_string = []
    unless value.nil?
      value.each do |key, value|
        saves_string << "#{key.capitalize} #{value},"
      end
      return saves_string.join(' ,')
    else
      saves_string
    end
  end

  def self.check_present(value)
    return nil if value.nil?
    if value.kind_of?(Array)
      if value&.first&.present?
        value&.first
      elsif value.empty?
        nil
      end
    elsif value.present?
      value
    end
  end
end
