require 'rest-client'

class Adapters::FiveEApiAdapter
  URL = 'https://www.dnd5eapi.co/api/'

  def self.get_all_spells
    all_spell_names = Facades::FiveEApi.get_spells
    if all_spell_names.code == (200)
      all_spell_details = retrieve_all_spell_details(ActiveSupport::JSON.decode(all_spell_names.body)['results'])
      all_spell_details
    else
      raise RuntimeError.new "Failed to retrieve spells. Error Code:#{all_spell_names.code}"
    end
  end

  private

  def self.retrieve_all_spell_details(spell_names)
    detailed_spell_list = Array.new
    spell_names.each{|spell|
      detailed_spell_list << Facades::FiveEApi.get_spell(spell['url'], 'url').body
    }
    return detailed_spell_list
  end
end
