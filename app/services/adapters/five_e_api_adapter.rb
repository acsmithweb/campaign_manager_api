require 'rest-client'

class Adapters::FiveEApiAdapter
  URL = 'https://www.dnd5eapi.co/api/'

  def self.get_details_for(resource_type)
    retrieve_all_resource_details(Facades::FiveEApi.get_resources(resource_type),resource_type)
  end

  private

  def self.retrieve_all_resource_details(resource_names, resource_type)
    detailed_resource_list = Array.new
    resource_names.each{|resource|
      detailed_resource_list << Facades::FiveEApi.get_resource(resource_type, resource['url'], 'url')
    }
    return detailed_resource_list
  end
end
