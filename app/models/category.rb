class Category < ApplicationRecord
  serialize :related_words, Hash

  def train(stat_block)
    stat_block_breakdown = TextWordCounterService.execute(stat_block_actions(stat_block))
    document_frequency(stat_block_breakdown)
  end

  def increment_document_count
    self.document_count += 1
    self.save
  end

  def calculate_tf_idf(stat_block)
    test_hash = {}
    TextWordCounterService.execute(stat_block_actions(stat_block)).each {|key, value|
      next if key.length < 3
      if self.focused_words.to_h.key?(key) == true
        tf = (value[:term_frequency].to_f * (inverse_document_frequency(key)).to_f).to_f
        test_hash.store(key, tf) if (tf < 0.02 && tf > 0.005)
      end
    }
    test_hash.to_h
  end

  private

  def focused_words
    related_words.collect{|word| word if (word[1][:document_frequency] > document_count/2) && word[0].length > 3 && word[1][:word_count] > 1}.compact
  end

  def inverse_document_frequency(key)
    Math.log((1 + self.document_count.to_f) / (1 + self.related_words[key][:document_frequency].to_f)) + 1
  end

  def document_frequency(breakdown)
    related_words_hash = self.related_words
    increment_document_count
    breakdown.each {|key, value|
      if related_words_hash.key?(key) == false
        related_words_hash.store(key, value)
        related_words_hash[key][:document_frequency] = 1
      else
        related_words_hash[key][:document_frequency] += 1
      end
    }
    self.related_words = related_words_hash
    self.save
  end

  def stat_block_actions(stat_block)
    return (stat_block.actions.to_s + ' ' + stat_block.abilities.to_s + ' ' + stat_block.legendary_actions.to_s)
  end
end
