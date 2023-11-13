class StatBlock < ApplicationRecord
  include PgSearch::Model

  has_many :workbook_records, :as => :records
  has_many :workbooks, through: :workbook_records

  pg_search_scope :search,
    against: [:name, :actions, :abilities, :skills, :size, :creature_type, :legendary_actions, :languages],
    using: {
      tsearch: {
        prefix: true
      }
    }

  pg_search_scope :vectorizer,
    against: [:name, :actions, :abilities, :skills, :size, :creature_type, :legendary_actions, :languages],
    using: {
      tsearch: {
        tsvector_column: "tsv"
      }
    }

#"Select plainto_tsquery('english', '" + string.gsub(/[^a-z0-9\s]/i, '') + "');"

  validates :name, presence: true
  validates :armor_class, presence: true, numericality: true
  validates :hit_points, presence: true, numericality: true
  validates :str, presence: true, numericality: true
  validates :dex, presence: true, numericality: true
  validates :con, presence: true, numericality: true
  validates :int, presence: true, numericality: true
  validates :wis, presence: true, numericality: true
  validates :cha, presence: true, numericality: true
  validates :challenge_rating, presence: true, numericality: true
  validates :experience_points, presence: true, numericality: true

  def to_obsidian_json
    {
      name: self.name,
      size: self.size_to_string,
      type: self.creature_type,
      alignment: self.alignment,
      ac: self.armor_class,
      hp: self.hit_points,
      hit_dice: self.hit_dice,
      speed: self.speed,
      stats: [self.str, self.dex, self.con, self.int, self.wis, self.cha],
      saves: self.stat_to_json(self.saving_throws),
      skillsaves: self.skills_to_json(self.skills),
      damage_vulnerabilities: self.vulnerability,
      damage_resistances: self.damage_resistance,
      damage_immunities: self.damage_immunities,
      condition_immunities: self.condition_immunities,
      senses: self.senses,
      language: self.languages,
      cr: self.challenge_rating,
      traits: self.parsed_traits,
      actions: self.parsed_actions,
      legendary_actions: self.parsed_legend_actions
    }.to_json
  end

  def size_to_string
    case self.size
    when 'T'
      return 'Tiny'
    when 'S'
      return 'Small'
    when 'M'
      return 'Medium'
    when 'L'
      return 'Large'
    when 'H'
      return 'Huge'
    when 'G'
      return 'Gargantuan'
    end
  end

  def modifier(stat)
    (self.send(stat.downcase.to_sym) - 10)/2
  end

  def attack_breakdowns
    attacks = []
    attacks_hash = []
    prof = 0
    stat_modifier = 0

    self.actions.split(',').each do |action_string|
      attacks << action_string if action_string.downcase.match('attack: +')
    end
    regex = Regexp.new('Attack: ([+-]?(?=\\.\\d|\\d)(?:\\d+)?(?:\\.?\\d*))(?:[Ee]([+-]?\\d+))? to hit', Regexp::IGNORECASE)
    attacks.each do |attack|
      if attack.downcase.match('weapon attack: +')
        if self.modifier('str') > self.modifier('dex')
          stat_modifier = self.modifier('str')
        else
          stat_modifier = self.modifier('dex')
        end
        if attack.downcase.match('melee') && regex.match(attack)
          to_hit = regex.match(attack)[1]
          prof = to_hit.to_i - stat_modifier
          attacks_hash << {to_hit: to_hit, prof: prof}
        end
        if attack.downcase.match('ranged')
          to_hit = 'spellcasting modifier' if regex.match(attack).nil?
          to_hit = regex.match(attack)[1] unless regex.match(attack).nil?
          prof = to_hit.to_i - stat_modifier
          attacks_hash << {to_hit: to_hit, prof: prof}
        end
      elsif attack.downcase.match('spell attack: +')
        if self.modifier('wis') > self.modifier('cha') && self.modifier('wis') > self.modifier('int')
          stat_modifier = self.modifier('wis')
        elsif self.modifier('cha') > self.modifier('wis') && self.modifier('cha') > self.modifier('int')
          stat_modifier = self.modifier('cha')
        elsif self.modifier('int') > self.modifier('wis') && self.modifier('int') > self.modifier('cha')
          stat_modifier = self.modifier('int')
        else
          stat_modifier = 0
        end
        to_hit = 'spellcasting modifier' if regex.match(attack).nil?
        to_hit = regex.match(attack)[1] unless regex.match(attack).nil?
        prof = to_hit.to_i - stat_modifier
        attacks_hash << {to_hit: to_hit, prof: prof}
      end
    end
    attacks_hash.uniq
  end

  def stat_to_json(string)
    return nil if string.nil?
    parse_string = string.gsub('+','').gsub('-','').
    gsub('Con','constitution:').
    gsub('Str','strength:').
    gsub('Dex','dexterity:').
    gsub('Int','intelligence:').
    gsub('Wis','wisdom:').
    gsub('Cha','charisma:')

    stat_hash = []
    parse_string.split(',').each{|element|
      split_element = element.split(':')
      stat_hash << {split_element[0].strip => split_element[1].strip}
    }

    return stat_hash
  end

  def stats_for_cr
    stats = {}
    dc = nil
    self.parsed_actions.each do |action|
      next if action[:dc].nil?
      dc = action[:dc][:dc_number] if action[:dc][:dc_number].present?
    end
    stats = self.attack_breakdowns.last
    stats&.merge!({dc: dc.to_i})
    stats&.merge!({ac: self.armor_class})
    stats&.merge!({hp: self.hit_points})
    stats
  end

  def skills_to_json
    skill_array = []
    self.skills.split(', ').each{|skill|
      if skill.match(/passive/)
		passive_split = skill.split('passive perception: ')
		split_skill = skill.split(' +')
		skill_array << [split_skill[0].downcase.strip, split_skill[1].strip]
        skill_array << ['passive_perception', passive_split.last]
      else
		split_skill = skill.split(' +')
        skill_array << [split_skill[0].downcase.strip, split_skill[1].strip]
      end
    }
  end

  def parsed_traits
    traits_array = []
    self.abilities.split("\n").each{|ability|
      split_ability = ability.split(':')
      traits_array << {name: split_ability[0], desc: split_ability[1], attack_bonus: 0}
    }
    return traits_array
  end

  def parsed_actions
    actions_array = []
    all_actions = self.actions.split("\n")
    all_actions.each_with_index{|action, index|
      next if action&.match(/\|/).present?
      split_action = action.split(':')
      if all_actions[index + 1]&.match(/\|/).present?
        action_stats = all_actions[index + 1].split(/\|/)
        actions_array << {name: split_action[0], desc: [split_action[1],split_action[2]]&.join(':'), attack_bonus: action_stats&.second, damage_dice: action_stats&.third&.split('+')&.first, damage_bonus: action_stats&.third&.split('+')&.second, dc: self.parse_dc_info(action)}
      else
        actions_array << {name: split_action[0], desc: split_action[1], attack_bonus: 0, dc: parse_dc_info(action)}
      end
    }
    return actions_array
  end

  def parse_dc_info(string)
    regex = Regexp.new('(DC\s\d\d\s*\S+)', Regexp::IGNORECASE)
    return nil if regex.match(string).nil?
    {dc_number: regex.match(string)[1].split(' ')[1], dc_save: regex.match(string)[1].split(' ')[2]}
  end

  def damage_per_round
    damage = []
    self.actions&.split(/\n/).each do |line|
      line.match(/\d+ \(.*?\)/)&.to_a&.each do |action|
        damage << action&.split(' (')&.first.to_i
      end
    end
    damage.sum.to_i
  end

  def get_multiattack_count
    number_of_attacks = nil
    test_matches = [
      /makes\s+(\w+)\s+(?:\w+\s+)*attack/i,
      /attacks\s+(\w+)\s+with/i,
      /makes\s+(\w+)\b\s*attack/,
    ]

    word_to_integer_hash = {
      one:  1,
      two:  2,
      twice:2,
      three:3,
      four: 4,
      five: 5,
      six:  6,
      seven:7,
      eight:8,
      nine: 9,
      ten: 10
    }

   str = self.actions
   test_matches.each { |regex|
    number_of_attacks = str.match(regex)
    break if number_of_attacks.present? && number_of_attacks[1].match(/one|two|twice|three|four|five|six|seven|eight|nine|ten/)
   }

    if number_of_attacks.present?
      if number_of_attacks[1].match(/one|two|twice|three|four|five|six|seven|eight|nine|ten/)
        details = self.actions.scan(/(\w+)\s+with its\s+(\w+)/i)
        details = self.actions.scan(/makes\s+(.*?)\s+attacks/i) if details.empty?
        details = self.actions.scan(/makes\s+(\w+)\s+attacks\s+with its\s+(\w+)/i) if details.empty?
        return {
          multiattack_number: word_to_integer_hash[number_of_attacks[1].to_sym],
          attacks_available: details.flatten.map{|element|
            element.split(' ').flatten
          }
        }
      elsif !number_of_attacks[1].match(/one|two|twice|three|four|five|six|seven|eight|nine|ten/)
        return 'Special Condition'
      end
    end
  end

  def parsed_legend_actions
    actions_array = []
    all_actions = self.legendary_actions.split("\n")
    all_actions.each_with_index{|action, index|
      next if action&.match(/\|/).present?
      split_action = action.split(':')
      if all_actions[index + 1]&.match(/\|/).present?
        action_stats = all_actions[index + 1].split(/\|/)
        actions_array << {name: split_action[0], desc: [split_action[1],split_action[2]].join(':'), attack_bonus: action_stats[1], damage_dice: action_stats[2]&.split('+')[0], damage_bonus: action_stats[2]&.split('+')[1], dc: parse_dc_info(action)}
      else
        actions_array << {name: split_action[0], desc: split_action[1], attack_bonus: 0, dc: parse_dc_info(action)}
      end
    }
    return actions_array
  end

  def calculate_tf_idf
    vector_array = []
    TextWordCounterService.execute(self.stat_block_actions).each {|key, value|
      tf = (value[:term_frequency].to_f * Math.log(1/value[:term_frequency].to_f)).to_f
      vector_array << [key, tf]
    }
    vector_array
  end

  def stat_block_actions
    actions = [
      self.actions,
      self&.abilities,
      self&.legendary_actions,
      self&.skills,
      self&.saving_throws,
      self&.senses,
      self&.condition_immunities,
      self&.damage_immunities,
      self&.vulnerability,
      self&.spells].map(&:to_s).join(' ').squeeze(' ')
    return (actions)
  end
end
