class TextWordCounterService
  STOP_WORDS = ['has','hit','or', 'a','it','points',"can't",'is','the','to','its','of','and','is','can','if','must','each','that','in','for','makes','as','an','on','by','at','this','form','foot','be','use','magically','from','choice','up','which','also','way','her','used','into','she','are','away','out','to']
  COMPRESS_FEET = /(\d+)\s(ft)/
  COMPRESS_SPELL_LEVEL = /(1st|2nd|3rd|4th|5th|6th|7th|8th|9th)\s(level)/
  COMPRESS_SPELL_SLOT = /(\d+)\s(slots?)/
  COMPRESS_DC = /(dc)\s(\d+)/
  PUNCTUATION_REMOVAL = /[[:punct:]&&[^+^]&&[^\/]]/

  def execute(text)
    word_count(text.downcase)
  end

  def word_count(text)
    text_list = {}
    count = 0
    process_string(text.downcase).split(' ').each{
    |word|
      count += 1
      if text_list[word].nil? == false
        text_list[word] += 1
      else
        text_list[word] = 1
      end
    }
    text_list = text_list.sort_by {|key, value| value}.reverse
      text_list.each do |key, value|
      puts key + ' : ' + calculate_weight(value,count).to_s
    end
  end

  def process_string(string)
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

  def calculate_weight(value,count)
    (value.to_f/count.to_f)
  end
end
