class StatBlockTrainingService

  BASE_STAT_ARRAY = ['str','dex','con','int','wis','cha']

  COMBAT_ROLE_DICTIONARY = {
    'scuffler':   {primary_stats: ['str'], lowest_stat: ['dex','con'], type: 'physical', range: 'melee', ac: 'low', hp: 'low', skew: 'attack'},
    'striker':    {primary_stats: ['str'], lowest_stat: ['dex','con'], type: 'physical', range: 'ranged', ac: 'low', hp: 'low', skew: 'attack'},
    'sneak':      {primary_stats: ['dex'], lowest_stat: ['str','con'], type: 'physical', range: 'melee', ac: 'high', hp: 'low', skew: 'defense'},
    'sniper':     {primary_stats: ['dex'], lowest_stat: ['str','con'], type: 'physical', range: 'ranged', ac: 'high', hp: 'low', skew: 'defense'},
    'stalwart':   {primary_stats: ['con'], lowest_stat: ['str','dex'], type: 'physical', range: 'melee', ac: 'low', hp: 'high', skew: 'defense'},
    'suppressor': {primary_stats: ['con'], lowest_stat: ['str','dex'], type: 'physical', range: 'ranged', ac: 'low', hp: 'high', skew: 'defense'},
    'shocktroop': {primary_stats: ['str','dex'], lowest_stat: ['con'], type: 'physical', range: 'melee', ac: 'low', hp: 'high', skew: 'attack'},
    'slinger':    {primary_stats: ['str','dex'], lowest_stat: ['con'], type: 'physical', range: 'ranged', ac: 'high', hp: 'low', skew: 'attack'},
    'slugger':    {primary_stats: ['str','con'], lowest_stat: ['dex'], type: 'physical', range: 'melee', ac: 'high', hp: 'low', skew: 'attack'},
    'shatterer':  {primary_stats: ['str','con'], lowest_stat: ['dex'], type: 'physical', range: 'ranged', ac: 'low', hp: 'high', skew: 'attack'},
    'scrapper':   {primary_stats: ['dex','con'], lowest_stat: ['str'], type: 'physical', range: 'melee', ac: 'high', hp: 'high', skew: 'balanced'},
    'skirmisher': {primary_stats: ['dex','con'], lowest_stat: ['str'], type: 'physical', range: 'ranged', ac: 'high', hp: 'high', skew: 'balanced'},
    'slayer':     {primary_stats: ['str','dex','con'], lowest_stat: [], type: 'physical', range: 'melee', ac: 'high', hp: 'high', skew: 'balanced'},
    'siegemaster':{primary_stats: ['str','dex','con'], lowest_stat: [], type: 'physical', range: 'ranged', ac: 'high', hp: 'high', skew: 'balanced'}
  }

  def self.generate_training_data()
    test = []
    COMBAT_ROLE_DICTIONARY.each do |key, value|
      role_query = []
      role_query << primary_stats_scope(value[:primary_stats])
      role_query << similarity_scope(value[:primary_stats]) if value[:primary_stats].count > 1
      role_query << low_stat_scope(value[:lowest_stat])
      role_query = role_query.reject{|element| element.blank?}
      results = StatBlock.search("#{value[:keyword]} weapon attack")
      results = results.where(role_query.compact.join(' AND '))
      cr_skew_results = cr_bias(value[:skew], results)
      test << {role: key, results: results, count: results.count}
    end
    test
  end

  def self.low_stat_scope(stats)
    compare_stats = BASE_STAT_ARRAY - stats

    minimum_field_query = stats.map do |field|
      "#{field} > least(#{compare_stats.join(', ')})"
    end.compact.join(" OR ")
  end

  def self.primary_stats_scope(stats)
    compare_stats = BASE_STAT_ARRAY - stats

    max_field_query = stats.map do |field|
      "#{field} > greatest(#{compare_stats.join(', ')})"
    end.compact.join(" OR ")
  end

  def self.similarity_scope(stats)
    pairs = stats.product(stats).reject { |primary, field| primary == field }.uniq { |pair| pair.sort }

    query_string = pairs.map do |primary, field|
      "abs(#{primary} - #{field}) <= 2"
    end.compact.join(' AND ')
  end

  def self.cr_bias(string, records)
    result = []
    records.each do |stat_block|
      cr_skew = CalculateChallengeRatings.execute(stat_block)
      case string
      when 'attack'
        result << stat_block if (cr_skew[:atk_cr] - cr_skew[:def_cr]) > 4
      when 'defense'
        result << stat_block if (cr_skew[:def_cr] - cr_skew[:atk_cr]) > 4
      when 'balanced'
        result << stat_block if (cr_skew[:def_cr] - cr_skew[:atk_cr]).abs < 4
      end
    end
    result
  end
end
