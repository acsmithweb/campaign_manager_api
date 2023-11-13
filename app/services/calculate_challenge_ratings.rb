class CalculateChallengeRatings
  def self.execute(stat_block)
    @stat_block = stat_block
    @cr_hash_values = stat_block.stats_for_cr
    def_cr = calculate_defense_cr
    atk_cr = calculate_offense_cr
    {atk_cr: atk_cr, def_cr: def_cr, avg_cr: ((def_cr + atk_cr)/2).round}
  end

  def self.calculate_defense_cr
    ac_cr = [0]
    hp_cr = []
    unless @stat_block.armor_class < 12
      self.stats_table.select{|key, hash| ac_cr << key.to_s.to_f if hash[:ac] == @stat_block.armor_class}
    end
    self.stats_table.select{|key, hash| hp_cr << key.to_s.to_f if (hash[:hp][0] < @stat_block.hit_points && hash[:hp][1] > @stat_block.hit_points)}
    diff = (hp_cr.first.to_f - ac_cr.last.to_f).abs.round
    adj_cr = (diff/2).round
    if hp_cr.last.to_f < ac_cr.last.to_f
      return (hp_cr.first.to_f + adj_cr.to_f).abs
    else
      return (hp_cr.first.to_f - adj_cr.to_f).abs
    end
  end

  def self.calculate_offense_cr
    atk_bonus_cr = []
    dpr_cr = []
    self.stats_table.select{|key, hash| dpr_cr << key.to_s.to_f if hash[:damage] > @stat_block.damage_per_round}
    save_dc = []
    @stat_block.parsed_actions.each{|attack|
      if attack[:attack_bonus].present?
        atk_bonus_num = attack[:attack_bonus].to_i
        self.stats_table.select{|key, hash| atk_bonus_cr << key.to_s.to_f if hash[:attack_bonus] == atk_bonus_num}
      end
      if attack[:dc].present?
        dc_number = attack[:dc][:dc_number].to_i
        self.stats_table.select{|key, hash| save_dc << key.to_s.to_f if hash[:dc] == dc_number}
      end
    }
    if atk_bonus_cr.present? && save_dc.present?
      avg_attack_cr = (atk_bonus_cr.uniq.sort.last.to_f + save_dc.uniq.sort.last.to_f)/2
    else
      avg_attack_cr = (atk_bonus_cr.uniq.sort.last.to_f + save_dc.uniq.sort.last.to_f)
    end
    diff = (dpr_cr.first.to_f - avg_attack_cr.to_f).abs.round
    adj_cr = (diff/2).round
    if (dpr_cr.first.to_f < avg_attack_cr.to_f)
      return (dpr_cr.first.to_f + adj_cr.to_f).abs
    else
      return (dpr_cr.first.to_f - adj_cr.to_f).abs
    end
  end

  def self.get_stat_cr(stat)
    stat_key = stat.to_sym
  end

  def self.stats_table
    {
      '0':    {prof: 2, ac: 12, hp: [0,6], attack_bonus: 3, damage: 1, dc: 13},
      '.125': {prof: 2, ac: 13, hp: [7,35], attack_bonus: 3, damage: 3, dc: 13},
      '.25':  {prof: 2, ac: 13, hp: [36,49], attack_bonus: 3, damage: 5, dc: 13},
      '.5':   {prof: 2, ac: 13, hp: [50,70], attack_bonus: 3, damage: 8, dc: 13},
      '1':    {prof: 2, ac: 13, hp: [71,85], attack_bonus: 3, damage: 14, dc: 13},
      '2':    {prof: 2, ac: 13, hp: [86,100], attack_bonus: 3, damage: 20, dc: 13},
      '3':    {prof: 2, ac: 13, hp: [101,115], attack_bonus: 4, damage: 26, dc: 13},
      '4':    {prof: 2, ac: 14, hp: [116,130], attack_bonus: 5, damage: 32, dc: 14},
      '5':    {prof: 3, ac: 15, hp: [131,145], attack_bonus: 6, damage: 38, dc: 15},
      '6':    {prof: 3, ac: 15, hp: [146,160], attack_bonus: 6, damage: 44, dc: 15},
      '7':    {prof: 3, ac: 15, hp: [161,175], attack_bonus: 6, damage: 50, dc: 15},
      '8':    {prof: 3, ac: 16, hp: [176,190], attack_bonus: 7, damage: 56, dc: 16},
      '9':    {prof: 4, ac: 16, hp: [191,205], attack_bonus: 7, damage: 62, dc: 16},
      '10':   {prof: 4, ac: 17, hp: [206,220], attack_bonus: 7, damage: 68, dc: 16},
      '11':   {prof: 4, ac: 17, hp: [221,235], attack_bonus: 8, damage: 74, dc: 17},
      '12':   {prof: 4, ac: 17, hp: [236,250], attack_bonus: 8, damage: 80, dc: 17},
      '13':   {prof: 5, ac: 18, hp: [251,265], attack_bonus: 8, damage: 86, dc: 18},
      '14':   {prof: 5, ac: 18, hp: [266,280], attack_bonus: 8, damage: 92, dc: 18},
      '15':   {prof: 5, ac: 18, hp: [281,295], attack_bonus: 8, damage: 98, dc: 18},
      '16':   {prof: 5, ac: 18, hp: [296,310], attack_bonus: 9, damage: 104, dc: 18},
      '17':   {prof: 6, ac: 19, hp: [311,325], attack_bonus: 10, damage: 110, dc: 19},
      '18':   {prof: 6, ac: 19, hp: [326,340], attack_bonus: 10, damage: 116, dc: 19},
      '19':   {prof: 6, ac: 19, hp: [341,355], attack_bonus: 10, damage: 122, dc: 19},
      '20':   {prof: 6, ac: 19, hp: [356,400], attack_bonus: 10, damage: 140, dc: 19},
      '21':   {prof: 7, ac: 19, hp: [401,445], attack_bonus: 11, damage: 158, dc: 20},
      '22':   {prof: 7, ac: 19, hp: [446,490], attack_bonus: 11, damage: 176, dc: 20},
      '23':   {prof: 7, ac: 19, hp: [491,535], attack_bonus: 11, damage: 194, dc: 20},
      '24':   {prof: 7, ac: 19, hp: [536,580], attack_bonus: 12, damage: 212, dc: 21},
      '25':   {prof: 7, ac: 19, hp: [581,625], attack_bonus: 12, damage: 230, dc: 21},
      '26':   {prof: 8, ac: 19, hp: [626,670], attack_bonus: 12, damage: 248, dc: 21},
      '27':   {prof: 8, ac: 19, hp: [671,715], attack_bonus: 13, damage: 266, dc: 22},
      '28':   {prof: 8, ac: 19, hp: [716,760], attack_bonus: 13, damage: 284, dc: 22},
      '29':   {prof: 9, ac: 19, hp: [806,805], attack_bonus: 13, damage: 302, dc: 22},
      '30':   {prof: 9, ac: 19, hp: [806,850], attack_bonus: 14, damage: 320, dc: 23},
    }
  end
end
