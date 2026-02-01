class RagCategory < Category
  DOCUMENT_SOURCE = "/shared_hdd/My Drive/Dnd Stuff/Campaigns/CampaignNotes/OrlaCampaign"

  attr_accessor :source_text

  def retrieve_source_text
    contents = self.retrieve_file
    parsed_source = contents.split(/\n#+\s/).reject { |c| c.empty? }.map{|c| strip_file_links(c)}
    @source_text ||= parsed_source.map{|c|
      strip_markdown(c) if c.downcase.match("#{self.category_name.downcase.split(/\s#+\s/).compact.last}\n")
    }.compact.last
  end

  def last_header
    self.category_name.downcase.split(/#+/).map{|d| d.strip}.last
  end

  private

  def retrieve_file
    find_file = "/#{self.document_name}.md"
    record = Dir.glob("#{DOCUMENT_SOURCE}/**/*").select{|file| file.match(/#{Regexp.escape(find_file)}/i)}.last
    return URI.unescape(File.read(record))
  end

  def flatten_text(raw_object)
    strip_file_links(strip_markdown("#{self.category_name}" + " #{raw_object[:text]}")).squish
  end

  def strip_markdown(text)
    text = text.gsub(/
    \s*(#+)
    |\s*```
    |\s*\[.*?\]\(.*?\)
    |`.*?`
    |\*\*(.*?)\*\*
    |\*(.*?)\*
    |_+(.*?)_
    |~~(.*?)~~
    /, ' ').gsub("_",' ').gsub(/---/,"\n").gsub(/\n+/," \n ")
  end

  def strip_file_links(text)
    text.gsub(/\s*\(.*?\)\s*/, ' ').gsub(/\[(.*?)\]/, '\1')
  end
end
