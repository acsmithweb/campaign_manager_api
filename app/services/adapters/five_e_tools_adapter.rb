class Adapters::FiveEToolsAdapter
  URL = './external-files/5e_tools_master_data/'

  def self.read_from_folder(resource_folder)
    Dir.glob("#{URL}/#{resource_folder}/*.json").each do |file_path|
      json_object = read(file_path)
    end
  end

  def self.read(file_path)
    file = File.read(file_path)
    source_json = JSON.parse(file)
  end
end
