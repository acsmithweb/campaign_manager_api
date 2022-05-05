class DungeonDictionary
  def initialize
    @spellchecker ||= load_dictionary
  end

  def corrected_word(word)
    @spellchecker.check?(word) ? word : correct_word(word)
  end

  def correct_word(word)
    suggestion = @spellchecker.suggest(word)[0] unless suggestion.nil?
    if suggestion.present?
      return suggestion
    elsif suggestion.nil?
      return word
    end
  end

  def dict
    @spellchecker
  end

  def load_dictionary
    dictionary = FFI::Hunspell.dict('en_US')
    dictionary.add('darkvision')
    dictionary.add('immunities')
    dictionary.add('undead')
    dictionary.add('polymorph')
    dictionary.add('shapechanger')
    dictionary.add('transformative')
    dictionary.add('subtype')
    dictionary.add('cantrip')
    dictionary.add('cr')
    dictionary.add('dex')
    dictionary.add('wis')
    dictionary.add('cha')
    dictionary.add('str')
    dictionary.add('xp')
    dictionary.add('dc')
    dictionary.add('ft')
    dictionary.add('0ft')
    dictionary.add('5ft')
    dictionary.add('10ft')
    dictionary.add('15ft')
    dictionary.add('20ft')
    dictionary.add('30ft')
    dictionary.add('40ft')
    dictionary.add('50ft')
    dictionary.add('60ft')
    dictionary.add('100ft')
    dictionary.add('120ft')
    dictionary.add('+')
    dictionary.add('+1')
    dictionary.add('+2')
    dictionary.add('+3')
    dictionary.add('+4')
    dictionary.add('+5')
    dictionary.add('+6')
    dictionary.add('+7')
    dictionary.remove('fi')
    return dictionary
  end
end
