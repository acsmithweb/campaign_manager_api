class ImageToCreatureService

  def self.translate(image_name)
    file = File.join(Rails.root, image_name)
    image = MiniMagick::Image.open(image_name)
    processed_image = image.quantize("Gray").colorspace("Gray").density(2400).black_threshold("1%").adaptive_sharpen(3).write('test.png')
    tess_file = File.join(Rails.root, 'test.png')
    tess = RTesseract.new(tess_file, lang: 'eng').to_s.downcase.split("\n")
    return clean_results(tess)
  end

  def self.component_search(cleaned_tess)
    single_keywords = [
      ['tiny','small','medium','large','huge','gargantuan'],
      ['lawful','chaotic','neutral','good','evil'],
      ['speed'],
      ['senses'],
      ['skills'],
      ['languages'],
      ['challenge'],
      ['actions']
    ]

    unioned_keywords = [
      ['armor class'],
      ['hit points'],
      ['condition immunities'],
      ['damage resistances'],
      ['saving throws'],
      ['str dex con int wis cha'],
      ['legendary actions']
    ]

    cleaned_tess.each do |segment|
      unioned_keywords.each do |pair|
        puts segment if pair.any?{|word| segment.include?(word)}
      end
      single_keywords.each do |keyword|
        segment.split(' ').each do |word|
          keyword.each do |element|
            distance = JaroWinkler.distance(word, element, adj_table: true, weight: 0.15, threshold: 0.75)
            distance -= 0.25 if word.size != element.size
            if distance > 0.9
              puts segment
            end
          end
        end
      end
    end
  end

  def self.clean_results(tess_results)
    # Here we can integrate with chat GPT to correct any graphical issues that may occur
    dict = DungeonDictionary.new
    tess_results.each do |segment|
      segment.gsub!(/[[:punct:]&&[^+^]&&[^\/]]/,'')
      segment.split(' ').each do |word|
        word.gsub!(dict.corrected_word(word).downcase, word)
      end
    end
    return tess_results.reject{ |e| e.to_s.blank?}
  end
end
# image.colorspace("Gray").density(1200).sharpen(5).write("test.png")
# image.quantize("Gray").colorspace("Gray").density(1200).sharpen(3).white_threshold("75%").black_threshold("45%").write("test.png")
