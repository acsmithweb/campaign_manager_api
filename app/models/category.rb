class Category < ApplicationRecord
  serialize :related_words, Hash

  attr_accessor :unique_entities, :tf_idf_score, :bm_25_score

  ENTITY_RECOGNITION_MODEL ||= Mitie::NER.new('/home/mariochase/Documents/MITIE/MITIE-models/english/ner_model.dat')

  def train(raw_object)
    flat_text = flatten_text(raw_object)
    object_breakdown = TextWordCounterService.execute(flat_text)
    @unique_entities = ENTITY_RECOGNITION_MODEL.doc(flat_text).entities.map{|e| e[:text].split(' ')}.flatten
    document_frequency(object_breakdown)
    calculate_tf_idf
    calculate_bm_25
  end

  def increment_document_count
    self.document_count += 1
    self.save
  end

  def calculate_tf_idf(unique_entity_weight = 1.25)
    @tf_idf_score ||= {}
    words = self.related_words
    total_words = words.values.map { |v| v[:term_frequency] }.sum
    calculate_avg_word_count

    words.each do |key, value|
      next if key.length < 3
      if self.related_words.to_h.key?(key) == true
        tf = Math.log(1 + (value[:term_frequency].to_f / total_words.to_f))
        idf = 1 + Math.log(self.document_count.to_f / (self.related_words[key][:document_frequency].to_f + 1))
        if self.related_words[key][:unique_entity?]
          @tf_idf_score[key] = (tf*idf) * unique_entity_weight
        else
          @tf_idf_score[key] = (tf*idf)
        end
      end
    end
    @tf_idf_score.to_h
  end

  def calculate_bm_25(k = 1, dl_weight = 0.15, unique_entity_weight = 1.25)
    @bm_25_score ||= {}
    words = self.related_words
    total_words = self.total_word_count

    words.each do |key, value|
      next if key.length < 3
      if self.related_words.to_h.key?(key) == true
        tf = value[:term_frequency].to_f / total_words.to_f
        idf = self.document_count.to_f / self.related_words[key][:document_frequency].to_f + 1
        score = (idf * ((k + 1) * tf))/(k*(1.0 - dl_weight + dl_weight*(total_words/48))+tf)
        if self.related_words[key][:unique_entity?]
          @bm_25_score[key] = score * unique_entity_weight
        else
          @bm_25_score[key] = score
        end
      end
    end
    @bm_25_score.to_h
  end

  def total_word_count
    self.related_words.sum { |key,hash| hash[:word_count]}
  end

  #compares the two tf_idf scores closer to 1 means more similar 0 is less similar
  def calculate_similarity(raw_object)
    array2 = raw_object.calculate_bm_25
    array1 = self.calculate_bm_25
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

  def calculate_avg_word_count
    corpus_length = 0
    RagCategory.all.each{|cat| corpus_length += cat.total_word_count}
    corpus_length / RagCategory.all.count
  end

  private

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
      if @unique_entities.map{|e| e.downcase}.include?(key)
        related_words_hash[key][:unique_entity?] = true
      else
        related_words_hash[key][:unique_entity?] = false
      end
    }
    self.related_words = related_words_hash
    self.save
  end

  def flatten_text
  end
end
