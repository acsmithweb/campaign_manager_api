class DocumentCategoryTrainer
  attr_accessor :file_name, :contents
  DOCUMENT_SOURCE = "/shared_hdd/My Drive/Dnd Stuff/Campaigns/CampaignNotes/OrlaCampaign"

  def self.execute(file_name)
    @file_name = file_name
    @contents = self.retrieve_file
    doc_contents = self.build_hierarchy
    self.create_and_train_documents(doc_contents)
  end

  def self.create_and_train_documents(doc_contents)
    doc_contents.each do |element|
      current_cat = RagCategory.create(document_name: @file_name, category_name: element[:section_headers]) unless element[:text].empty?
      if !element[:text].empty?
        if !element[:children].empty?
          self.create_and_train_documents(element[:children])
        end
        current_cat.train(element)
      else
        next
      end
    end
  end

  def self.build_hierarchy
    hierarchy = []
    stack = []
    header_num = 1
    section_headers = ""
    parent_header = "#{@file_name}"

    headers = @contents.scan(/^#.+/).reject(&:empty?)
    text = @contents.gsub(/\n---\n/,'').split(/^#.+/)

    headers.each do |header|
      level = header[/^#+/]&.length
      header_content = text[header_num]
      next if level.nil? || level == 0
      header_num += 1

      while stack.any? && stack.last[:level] >= level
        stack.pop
      end

      section_headers = ""
      parent_header = "#{@file_name}" if level == 1
      parent_header = stack.last[:section_headers] if (stack.any? && stack.last[:level] < level)

      section_headers += "#{parent_header} #{header[/^#+ (.*)$/].strip}"

      current = { section_headers: section_headers, text: header_content, level: level, children: [] }
      if stack.any?
        stack.last[:children] << current
      else
        hierarchy << current
      end

      stack << current
    end
    hierarchy
  end

  private

  def self.retrieve_file
    find_file = "/#{@file_name}.md"
    record = Dir.glob("#{DOCUMENT_SOURCE}/**/*").select{|file| file.match(/#{Regexp.escape(find_file)}/i)}.last
    return URI.unescape(File.read(record))
  end
end
