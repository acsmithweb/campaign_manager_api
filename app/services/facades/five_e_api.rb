require 'rest-client'

class Facades::FiveEApi
  URL = 'https://www.dnd5eapi.co'

  def self.get_resources(resource_type)
    case resource_type.downcase
    when 'spells'
      get_spells
    when 'monsters'
      get_monsters
    end
  end

  def self.get_resource(resource_type, resource_value, value_type)
    case resource_type.downcase
    when 'spells'
      get_spell(resource_value, value_type)
    when 'monsters'
      get_monster(resource_value, value_type)
    end
  end

  def self.get_spells
    ActiveSupport::JSON.decode(use_get_call('/api/spells').body)['results']
  end

  def self.get_monsters
    ActiveSupport::JSON.decode(use_get_call('/api/monsters').body)['results']
  end

  def self.get_spell(spell_name_value, value_type)
    call_for_resource('spells', spell_name_value, value_type)
  end

  def self.get_monster(monster_name_value, value_type)
    call_for_resource('monsters', monster_name_value, value_type)
  end

  private

  def self.call_for_resource_names(resource_type)
    use_get_call('/api/' + resource_type)
  end

  def self.call_for_resource(resource_type, resource_value, value_type)
    call_string = nil
    case value_type.downcase
    when "name"
      call_string = "/api/" + resource_type + '/' + name_to_index(resource_value)
    when "url"
      call_string = resource_value
    when "index"
      call_string = "/api/" + resource_type + '/' + resource_value
    else
      raise RuntimeError.new 'Incorrect value type entered'
    end
    call_response = use_get_call(call_string)
    handle_code(call_response.code)
    call_response.body
  end

  def self.name_to_index(name)
    name.gsub(' ','-').downcase
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
