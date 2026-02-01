class PromptContainer
  attr_accessor :vector_array, :container_prompt, :words, :avg_word_count, :bm_25_score

  attr_accessor :unique_entities

  ENTITY_RECOGNITION_MODEL ||= Mitie::NER.new('/home/mariochase/Documents/MITIE/MITIE-models/english/ner_model.dat')

  def initialize(prompt)
    @container_prompt = prompt
    @vector_array = []
    @unique_entities = ENTITY_RECOGNITION_MODEL.doc(prompt).entities.map{|e| e[:text].split(' ')}.flatten
    calculate_tf_idf
    calculate_bm_25
  end

  def calculate_tf_idf
    return @vector_array unless @vector_array.empty?
    TextWordCounterService.execute(@container_prompt).each {|key, value|
      score = (value[:term_frequency].to_f * (1 + Math.log(1/value[:term_frequency].to_f))).to_f
      if @unique_entities.include?(key)
        score *= unique_entity_weight
      end
      @vector_array << [key, score]
    }
  end

  def calculate_bm_25(k = 1.0, dl_weight = 0.5, unique_entity_weight = 2.0)
    test_hash = {}
    @words = TextWordCounterService.execute(@container_prompt)
    total_words = @words.values.map { |v| v[:term_frequency] }.sum

    @words.each do |key, value|
      next if key.length < 3
      if self.words.to_h.key?(key) == true
        tf = value[:term_frequency].to_f / total_words.to_f
        idf = 1.0 / 1.0
        score = (idf * ((k+1.0) * tf))/(k*(1.0 - dl_weight + dl_weight*(total_words/48))+tf)
        if @unique_entities.include?(key)
          score *= unique_entity_weight
        end
        test_hash[key] = score
      end
    end
    @bm_25_score = test_hash.to_h
  end

  def total_word_count
    @words.sum { |key,hash| hash[:word_count]}
  end

  def retrieve_relevant_categories(tolerance_threshold=0.75)
    score_array = []
    RagCategory.all.map {|cat|
      score = cat.calculate_similarity(self)
      score_array << {name: cat.category_name, score: score} unless score.to_f.nan?
    }
    normalized_array = normalize_scores(score_array)
    if normalized_array.all? {|e| e[:normalized_score] == normalized_array.first[:normalized_score]}
      return normalized_array
    else
      return normalized_array.reject{|e| e if e[:normalized_score] > tolerance_threshold}
    end
  end

  def retrieve_relevant_text
    retrieve_relevant_categories.map{|e| RagCategory.where(category_name: e[:name]).first}.map{|e| e.retrieve_source_text}.join("\n")
  end

  def normalize_scores(scores)
    return nil if scores.empty?

    min_score = scores.min_by { |score| score[:score] }[:score]
    max_score = scores.max_by { |score| score[:score] }[:score]

    return scores.map{|element| {name: element[:name], normalized_score: element[:score]}} if min_score == max_score

    scores.map do |score|
      normalized_score = (score[:score] - min_score) / (max_score - min_score)
      { name: score[:name], normalized_score: normalized_score }
    end.sort_by { |score| -score[:normalized_score] }
  end
end
