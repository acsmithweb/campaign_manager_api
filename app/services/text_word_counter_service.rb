class TextWordCounterService
  STOP_WORDS = stopwords = [
    # Common English stopwords (customize as needed)
    "a", "an", "the", "in", "on", "at", "to", "by", "with", "and", "or", "of", "for",
    "about", "after", "all", "also", "an", "and", "are", "as", "at", "be", "because",
    "been", "but", "by", "can", "could", "did", "do", "does", "even", "for", "from",
    "had", "has", "have", "if", "in", "into", "is", "it", "its", "just", "more",
    "most", "no", "not", "now", "of", "on", "only", "or", "our", "out", "over",
    "so", "some", "such", "than", "that", "the", "their", "then", "there", "these",
    "they", "this", "those", "through", "to", "up", "very", "was", "we", "well",
    "were", "what", "when", "where", "which", "while", "who", "will", "with",
    "would", "you", "your", "its", "any", "has", "such", "when", "that", "over", "other",
    "until"
  ]

  COMPRESS_FEET = /(\d+)\s(ft)/
  COMPRESS_SPELL_LEVEL = /(1st|2nd|3rd|4th|5th|6th|7th|8th|9th)\s(level)/
  COMPRESS_SPELL_SLOT = /(\d+)\s(slots?)/
  COMPRESS_DC = /(dc)\s(\d+)/
  PUNCTUATION_REMOVAL = /[[:punct:]&&[^+^]&&[^\/]]/

  def self.execute(text)
    word_count(text.downcase)
  end

  def self.word_count(text)
    spellcheck = DungeonDictionary.new
    text_list = {}
    count = 0
    processed_strings = process_string(text.downcase)
    unless processed_strings.nil?
      processed_strings.split(' ').each{|word|
        next if word.length < 3
        corrected_word = spellcheck.corrected_word(word)
        count += 1
        if text_list[corrected_word].nil? == false
          text_list[corrected_word] += 1
        else
          text_list[corrected_word] = 1
        end
      }
    end
    text_list = text_list.sort_by {|key, value| value}.reverse.to_h
      text_list.update(text_list) {|key, value|
        {
          word_count: value.to_i,
          term_frequency: (value.to_f/count.to_f).to_f
        }
      }
  end

  def self.process_string(string)
    string.gsub!(PUNCTUATION_REMOVAL,' ')
    string.gsub!(COMPRESS_FEET,"\\1\\2")
    string.gsub!(COMPRESS_SPELL_SLOT,"\\1-\\2")
    string.gsub!(COMPRESS_SPELL_LEVEL,"\\1-\\2")
    string.gsub!(COMPRESS_DC,"\\1:\\2")
    STOP_WORDS.each{|stop_word|
      string.gsub!(/\b#{stop_word}\b/,' ')
    }
    return string.squeeze(' ')
  end
end
