class Adapters::FightClubFiveEAdapter
  URL = './external-files/Collections/Complete'

  def self.retrieve_resource_collection(resource_type)
    collection_file = File.open(URL+resource_type.titleize.delete(' ')+'.xml')
    resource_hash = Hash.from_xml(collection_file)
    compendium = []
    resource_hash['collection']['doc'].each{|file|
      compendium << retrieve_resource_hash(file['href'].gsub('..',''))
    }
    return compendium.flatten
  end

  private

  def self.retrieve_resource_hash(file_path)
    collection_file = File.open('./external-files'+file_path)
    resource_hash = Hash.from_xml(collection_file)
    content_type = resource_hash['compendium'].keys[2]
    return resource_hash['compendium'][content_type]
  end
end
