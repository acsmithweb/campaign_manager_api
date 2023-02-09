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

  def skills_to_json
    skill_array = []
    self.skills.split(', ').each{|skill|
	puts skill
      if skill.match(/passive/)
		passive_split = skill.split('passive perception: ')
		split_skill = skill.split(' +')
		skill_array << [split_skill[0].downcase.strip, split_skill[1].strip]
        skill_array << ['passive_perception', passive_split.last]
      else
		split_skill = skill.split(' +')
        skill_array << [split_skill[0].downcase.strip, split_skill[1].strip]
      end
	 puts skill_array
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
        actions_array << {name: split_action[0], desc: [split_action[1],split_action[2]].join(':'), attack_bonus: action_stats[1], damage_dice: action_stats[2]&.split('+')[0], damage_bonus: action_stats[2]&.split('+')[1]}
      else
        actions_array << {name: split_action[0], desc: split_action[1], attack_bonus: 0}
      end
    }
    return actions_array
  end

  def parsed_legend_actions
    actions_array = []
    all_actions = self.legendary_actions.split("\n")
    all_actions.each_with_index{|action, index|
      next if action&.match(/\|/).present?
      split_action = action.split(':')
      if all_actions[index + 1]&.match(/\|/).present?
        action_stats = all_actions[index + 1].split(/\|/)
        actions_array << {name: split_action[0], desc: [split_action[1],split_action[2]].join(':'), attack_bonus: action_stats[1], damage_dice: action_stats[2]&.split('+')[0], damage_bonus: action_stats[2]&.split('+')[1]}
      else
        actions_array << {name: split_action[0], desc: split_action[1], attack_bonus: 0}
      end
    }
    return actions_array
  end
end
