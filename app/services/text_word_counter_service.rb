class TextWordCounterService
  STOP_WORDS = ['with','has','class','weapon','target','hit','or', 'a','it','points',"can't",'is','the','to','its','of','and','is','can','if','must','each','that','in','for','makes','as','an','on','by','at','this','form','foot','be','use','magically','from','choice','up','which','also','way','her','used','into','she','are','away','out','to']
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
    process_string(text.downcase).split(' ').each{
    |word|
      corrected_word = spellcheck.corrected_word(word)
      count += 1
      if text_list[corrected_word].nil? == false
        text_list[corrected_word] += 1
      else
        text_list[corrected_word] = 1
      end
    }
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
    return string.strip!
  end
end
