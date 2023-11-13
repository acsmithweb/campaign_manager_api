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
        test_hash.store(key, tf)
      end
    }
    test_hash.to_h
  end

  def calculate_similarity(stat_block)
    array1 = stat_block.calculate_tf_idf
    array2 = self.create_vector
    dot_product = 0
    magnitude1 = 0
    magnitude2 = 0

    array1.each do |pair1|
      term1, value1 = pair1
      pair2 = array2.find { |pair| pair[0] == term1 }

      if pair2
        term2, value2 = pair2

        dot_product += (value1 * value2)

        magnitude1 += (value1**2)
        magnitude2 += (value2**2)
      end
    end

    cosine_similarity = dot_product / (Math.sqrt(magnitude1) * Math.sqrt(magnitude2))
  end

  private

  def create_vector
    tfidf_vector = []
    self.focused_words.each do |term, score|
      tfidf_vector << [term, score[:term_frequency]]
    end
    return tfidf_vector
  end

  def focused_words
    related_words.collect{|word| word if word[0].length > 3 && word[1][:word_count] < 6 && word[1][:document_frequency] > 4}.compact
  end

  def inverse_document_frequency(key)
    document_frequency = self.related_words[key][:document_frequency].to_f
    total_documents = self.document_count.to_f
    if document_frequency == 0
      return Math.log(total_documents + 1)
    else
      return Math.log(total_documents / document_frequency)
    end
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
    actions = [
      stat_block.actions,
      stat_block&.abilities,
      stat_block&.legendary_actions,
      stat_block&.skills,
      stat_block&.saving_throws,
      stat_block&.senses,
      stat_block&.condition_immunities,
      stat_block&.damage_immunities,
      stat_block&.vulnerability,
      stat_block&.spells].map(&:to_s).join(' ').squeeze(' ')
    return (actions)
  end
end
