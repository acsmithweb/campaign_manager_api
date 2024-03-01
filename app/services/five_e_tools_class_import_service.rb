class FiveEToolsClassImportService
  def execute()
  end

  def class_name(json_class)
    json_class["name"]
  end

  def build_trait(json_class)
    json_class["classFeature"].each do |trait|

    end
  end

  private

  def hit_dice(json_class)
    "#{json_class["hd"]["number"]}d#{json_class["hd"]["faces"]}"
  end

  def proficiencies(json_class)
    "Saving Throws #{json_class["proficiency"].join(',')}\n
    Skills: #{json_class["startingProficiencies"]["skills"]["choose"]["from"].join(',')}\n
    Number of Skills: #{json_class["startingProficiencies"]["skills"]["choose"]["count"]}"
  end

  def armor(json_class)
    "Starting Proficiencies: #{json_class["startingProficiencies"]["armor"].map{|element| parse_lookup(element) if element.match(/\{@(\w+)(.*)/)}}\n"
  end

  def weapons(json_class)
    json_class["startingProficiencies"]["weapons"].join(',')
  end

  def wealth(json_class)
    parse_lookup(json_class["startingEquipment"]["goldAlternative"])
  end

  def parse_lookup(input_string)
    input_string.match(/\{@(\w+)(.*)/)[2].strip.split('|').first
  end

  def trait_name(trait_info)
    trait_info["name"]
  end

  def trait_level(trait_info)
    trait_info["level"]
  end

  def trait_details(trait_info)
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
                trait_entry.push("#{sub_entry["name"]}\n")
                trait_entry.push("#{sub_entry["entries"].join(" ")}")
              when "table"
                trait_entry.push("#{sub_entry["caption"]}\n")
              end
            else
              trait_entry.push("#{sub_entry}")
            end
          end
        when "inset"
          trait_entry.push("#{sub_entry["name"]}\n")
          trait_entry.push("#{sub_entry["entries"].join(" ")}")
        when "abilityDc", "abilitiyAttackMod"
          trait_entry.push("#{entry["name"]}\n#{entry["attributes"].join(" ")}")
        when "options"
          entry["entries"].each do |sub_entry|
            trait_entry.push("#{sub_entry["optionalfeature"]}\n")
          end
        end
      end
    end
  end
end
