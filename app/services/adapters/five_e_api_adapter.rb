require 'rest-client'

class Adapters::FiveEApiAdapter
  URL = 'https://www.dnd5eapi.co/api/'

  def self.get_all_spells
    retrieve_all_spell_details(Facades::FiveEApi.get_spells)
  end

  private

  def self.retrieve_all_spell_details(spell_names)
    detailed_spell_list = Array.new
    spell_names.each{|spell|
      detailed_spell_list << Facades::FiveEApi.get_spell(spell['url'], 'url')
    }
    return detailed_spell_list
  end
end
