class FiveEToolsClassImportService
  URL = './external-files/5e_tools_master_data/'

  def self.read_from_folder(resource_folder)
    Dir.glob("#{URL}/#{resource_folder}/*.json").each do |file_path|
      next if file_path.match('foundry') or file_path.match('sidekick')
      json_object = read(file_path)
    end
  end

  def self.read(file_path)
    file = File.read(file_path)
    source_json = JSON.parse(file)
    return nil if source_json["class"].nil?
    source_json["class"].each do |class_json|
      next if class_json["isSidekick"]
      BaseClass.create!(transform_json(class_json)) unless BaseClass.find_by_name(class_json["name"])
    end

    source_json["classFeature"].each do |base_trait_json|
      Trait.create!(transform_trait_json(base_trait_json))
    end

    source_json["subclass"].each do |sub_class_json|
      puts sub_class_json["shortName"]
      SubClass.create!(subclass_details(sub_class_json)) unless SubClass.find_by_name(sub_class_json["shortName"])
    end

    source_json["subclassFeature"].each do |base_trait_json|
      Trait.create!(transform_trait_json(base_trait_json)) unless Trait.find_by_name(base_trait_json["name"])
    end
  end

  def self.subclass_details(subclass_json)
    {
      "name": subclass_json["shortName"],
      "parent_id": BaseClass.find_by_name(subclass_json["className"]).id
    }
  end

  def self.transform_json(class_json)
    transformed_data = {
      "name" => class_json["name"],
      "hit_dice" => hit_dice(class_json),
      "proficiencies" => proficiencies(class_json),
      "num_skills" => number_of_skills(class_json),
      "armor" => armor(class_json),
      "weapons" => weapons(class_json),
      "tools" => tools(class_json),
      "wealth" => wealth(class_json)
    }
  end

  def self.build_trait(json_class)
    json_class.each do |trait|
      puts transform_trait_json(trait)
    end
  end

  def self.transform_trait_json(trait_json)
    parent_hash = parent_class(trait_json)
    {
      name: trait_name(trait_json),
      details: trait_details(trait_json),
      optional: optional_trait(trait_json),
      class_level: trait_level(trait_json),
      parent_type: parent_hash[:class_name],
      parent_id: parent_hash[:parent_id]
    }
  end

  private

  def self.tools(json_class)
    tools = []
    return nil if json_class["startingProficiencies"].nil? || json_class["startingProficiencies"]["tools"].nil?
    json_class["startingProficiencies"]["tools"].each do |element|
      if element.is_a?(Hash)
        tools << parse_lookup(element["proficiency"]) if element["proficiency"].match(/\{@(\w+)(.*)/)
      else
        tools << parse_lookup(element) if element.match(/\{@(\w+)(.*)/)
      end
    end
    tools.join(",")
  end

  def self.hit_dice(json_class)
    return nil if json_class["hd"].nil?
    "#{json_class["hd"]["number"]}d#{json_class["hd"]["faces"]}"
  end

  def self.number_of_skills(json_class)
    return nil if json_class["startingProficiencies"].nil?
    if json_class["startingProficiencies"]["skills"]&.first.keys.include?("any")
      json_class["startingProficiencies"]["skills"].first["any"]
    else
      json_class["startingProficiencies"]["skills"]&.first["choose"]["count"]
    end
  end

  def self.proficiencies(json_class)
    return nil if json_class["startingProficiencies"].nil?
    proficiencies_string = []
    proficiencies_string << "Saving Throws: #{json_class["proficiency"]&.join(',')}"
    if json_class["startingProficiencies"]["skills"]&.first.keys.include?("any")
      proficiencies_string << "Skills: any #{json_class["startingProficiencies"]["skills"].first["any"]}"
    else
      proficiencies_string << "Skills: #{json_class["startingProficiencies"]["skills"]&.first["choose"]["from"]&.join(',')}"
      proficiencies_string << "Number of Skills: #{json_class["startingProficiencies"]["skills"]&.first["choose"]["count"]}"
    end
    proficiencies_string.join("\n")
  end

  def self.armor(json_class)
    armors = []
    return nil if json_class["startingProficiencies"].nil? || json_class["startingProficiencies"]["armor"].nil?
    json_class["startingProficiencies"]["armor"].each do |element|
      if element.is_a?(Hash)
        armors << parse_lookup(element["proficiency"])
      else
        armors << parse_lookup(element) if element.match(/\{@(\w+)(.*)/)
      end
    end
    "Starting Proficiencies: #{armors.join(',')}\n"
  end

  def self.weapons(json_class)
    weapons = []
    return nil if json_class["startingProficiencies"].nil? || json_class["startingProficiencies"]["weapons"].nil?
    json_class["startingProficiencies"]["weapons"].each do |element|
      if element.is_a?(Hash)
        weapons << parse_lookup(element["proficiency"]) if element["proficiency"].match(/\{@(\w+)(.*)/)
      else
        weapons << parse_lookup(element) if element.match(/\{@(\w+)(.*)/)
      end
    end
    weapons.join(",")
  end

  def self.wealth(json_class)
    return nil if json_class["startingEquipment"].nil?
    parse_lookup(json_class["startingEquipment"]["goldAlternative"])
  end

  def self.parse_lookup(input_string)
    match = input_string&.match(/\{@(\w+)(.*)/)
    if match.nil?
      input_string
    elsif match
      match[2].split('|').first.strip
    end
  end

  def self.trait_name(trait_info)
    trait_info["name"]
  end

  def self.trait_level(trait_info)
    trait_info["level"]
  end

  def self.optional_trait(trait_info)
    return nil if trait_info["isClassFeatureVariant"]
    trait_info["isClassFeatureVariant"]
  end

  def self.parent_class(trait_info)
    parent = nil
    if trait_info.has_key?("subclassShortName")
      parent = SubClass.find_by_name(trait_info["subclassShortName"])
    else
      parent = BaseClass.find_by_name(trait_info["className"])
    end
    puts parent.inspect
    parent = {
      class_name: parent.class.name,
      class_id: parent.id
    }
  end

  def self.score_improvement(trait_info)
    return true if trait_info["name"].match("Ability Score Improvement")
  end

  def self.trait_details(trait_info)
    trait_entry = []
    trait_info["entries"].each do |entry|
      trait_entry.push(entry) if entry.is_a?(String)
      if entry.is_a?(Hash)
        case entry["type"]
        when "list"
          trait_entry.push(entry["items"].join("\n\t"))
        when "entries"
          trait_entry.push("#{entry["name"]}\n")
          entry["entries"].each do |sub_entry|
            if sub_entry.is_a?(Hash)
              case sub_entry["type"]
              when "inset"
                trait_entry.push("#{sub_entry["name"].strip}\n")
                trait_entry.push("#{sub_entry["entries"].join(" ")}")
              when "table"
                trait_entry.push("#{sub_entry["caption"]}\n")
              end
            else
              trait_entry.push("#{sub_entry}")
            end
          end
        when "inset"
          entry["entries"].each do |sub_entry|
            trait_entry.push("#{sub_entry["name"]}\n")
            if sub_entry["entries"].is_a?(Array)
              trait_entry.push(sub_entry["entries"].join(" "))
            else
              trait_entry.push(sub_entry["entries"])
            end
          end
        when "abilityDc", "abilitiyAttackMod"
          trait_entry.push("#{entry["name"]}\n#{entry["attributes"].join(" ")}")
        when "options"
          entry["entries"].each do |sub_entry|
            trait_entry.push("#{sub_entry["optionalfeature"]}\n")
          end
        end
      end
    end
    trait_entry.join(" ")
  end
end
