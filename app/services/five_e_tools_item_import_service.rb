class FiveEToolsItemImportService
  URL = './external-files/5e_tools_master_data/'

  def self.read(file_path)
    file = File.read("#{URL}/items-base.json")
    source_json = JSON.parse(file)
    return nil if source_json["baseitem"].nil?
    source_json["baseitem"].each do |item_json|
      puts item_json["name"]
      Item.create!(transform_json(item_json)) unless Item.find_by_name(item_json["name"])
    end

    file = File.read("#{URL}/items.json")
    source_json = JSON.parse(file)
    return nil if source_json["item"].nil?
    source_json["item"].each do |item_json|
      Item.create!(transform_json(item_json)) unless Item.find_by_name(item_json["name"])
    end
  end

  def self.transform_json(item_json)
    puts item_json
    {
      name: item_json["name"],
      details: "",
      item_type: item_type(item_json["type"]),
      magic: item_magic(item_json),
      ac: item_ac(item_json),
      weight: item_json["weight"],
      value: item_value(item_json),
      damage: item_damage(item_json),
      property: item_properties(item_json),
      dmg_type: item_dmg_type(item_json),
      desc: item_desc(item_json),
      stealth: item_stealth(item_json),
      rolls: ""
    }
  end

  def self.item_magic(item_json)
    return item_json.key?("wondrous")
  end

  def self.item_desc(item_json)
    join_description = []
    if item_json.is_a?(Array)
      join_description << item_json.join("\n")
    elsif item_json.is_a?(Hash)
      if item_json.key?("entries")
        item_json["entries"].each do |entry|
          if entry.is_a?(String)
            join_description << entry
          elsif entry["type"].match?("list")
            join_description << entry["items"].join("\n")
          elsif entry["type"].match?("table")
            join_description << "#{entry["colLabels"]&.join("|")}"
            entry["rows"].each do |element|
              join_description << element.join(":")
            end
          elsif entry["type"].match?("entries")
            join_description << item_desc(entry["entries"])
          elsif item_json.key?("items")
            join_description << item_json["items"].join("\n")
          else
            join_description << entry
          end
        end
      end
    elsif item_json.is_a?(String)
      join_description << item_json
    end
    return join_description.join("\n").gsub(/\{|\}|@\w+\s|@h*/, "").strip
  end

  def self.item_stealth(item_json)
    return !item_json.key?("stealth")
  end

  def self.item_dmg_type(item_json)
    damage_string = []
    if item_json.key?("dmgType")
      case item_json["dmgType"]
      when 'P'
        damage_string << 'Piercing'
      when 'B'
        damage_string << 'Bludgeoning'
      when 'S'
        damage_string << 'Slashing'
      when 'N'
        damage_string << 'Necrotic'
      when 'R'
        damage_string << 'Radiant'
      end
    end
    damage_string.join(',')
  end

  def self.item_properties(item_json)
    item_props = []
    if item_json.key?("property")
        item_json["property"].each do |prop|
        case prop
        when 'A'
          item_props << "Ammunition (#{item_json["range"]})"
        when 'AF'
          item_props << "Ammunition (#{item_json["range"]})"
        when 'V'
          item_props << 'Versatile'
        when 'F'
          item_props << 'Finesse'
        when 'R'
          item_props << 'Reach'
        when 'T'
          item_props << "Thrown (#{item_json["range"]})"
        when 'H'
          item_props << 'Heavy'
        when '2H'
          item_props << 'Two-Handed'
        when 'L'
          item_props << 'Light'
        when 'LD'
          item_props << 'Loading'
        when 'RLD'
          item_props << "Reloading (#{item_json["reload"]})"
        when 'S'
          item_props << 'Special'
        end
      end
    end
    return item_props.join(",")
  end

  def self.item_damage(item_json)
    damage_string = []
    if item_json.key?("dmg1")
      damage_string << item_json["dmg1"]
    end

    if item_json.key?("dmg2")
      damage_string << item_json["dmg2"]
    end

    return damage_string.join("|")
  end

  def self.item_value(item_json)
   if item_json.key?("value")
     return item_json["value"]
   else
     return nil
   end
  end

  def self.item_ac(item_json)
   if item_json.key?("ac")
     return item_json["ac"]
   else
     return nil
   end
  end

  def self.item_type(type)
    case type
    when 'A'
      return 'Ammunition'
    when 'R'
      return 'Ranged'
    when 'M'
      return 'Melee'
    when 'LA'
      return 'Light Armor'
    when 'MA'
      return 'Medium Armor'
    when 'HA'
      return 'Heavy Armor'
    when 'INS'
      return 'Instrument'
    when 'SCF'
      return 'Spellcasting Focus'
    end
  end
end
