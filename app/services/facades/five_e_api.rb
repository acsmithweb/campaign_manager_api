require 'rest-client'

class Facades::FiveEApi
  URL = 'https://www.dnd5eapi.co'

  def self.get_spells
    use_get_call('/api/spells')
  end

  def self.get_spell(spell_name_value, value_type)
    case value_type.downcase
    when "name"
      use_get_call('/api/spells/' + spell_name_to_index(spell_name_value))
    when "url"
      use_get_call(spell_name_value)
    when "index"
      use_get_call('/api/spells/' + spell_name_value)
    else
      raise RuntimeError.new 'Incorrect value type entered'
    end
  end

  private

  def self.spell_name_to_index(spell_name)
    spell_name.gsub(' ','-').downcase
  end

  def self.use_get_call(url_append)
    RestClient.get(URL + url_append)
  end
end
