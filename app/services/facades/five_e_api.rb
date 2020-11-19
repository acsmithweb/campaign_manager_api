require 'rest-client'

class Facades::FiveEApi
  URL = 'https://www.dnd5eapi.co'

  def self.get_spells
    call_response = use_get_call('/api/spells')
    handle_code(call_response.code)
    ActiveSupport::JSON.decode(call_response.body)['results']
  end

  def self.get_spell(spell_name_value, value_type)
    call_string = nil
    case value_type.downcase
    when "name"
      call_string = '/api/spells/' + spell_name_to_index(spell_name_value)
    when "url"
      call_string = spell_name_value
    when "index"
      call_string = '/api/spells/' + spell_name_value
    else
      raise RuntimeError.new 'Incorrect value type entered'
    end
    call_response = use_get_call(call_string)
    handle_code(call_response.code)
    call_response.body
  end

  private

  def self.spell_name_to_index(spell_name)
    spell_name.gsub(' ','-').downcase
  end

  def self.use_get_call(url_append)
    RestClient.get(URL + url_append)
  end

  def self.handle_code(code)
    case code
    when 200
      '200'
    when 404
      raise RuntimeError.new '404 record not found'
    else
      raise RuntimeError.new "Unhandled Error #{code}"
    end
  end
end
