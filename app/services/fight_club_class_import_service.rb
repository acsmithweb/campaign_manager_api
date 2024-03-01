class FightClubClassImportService
  def execute()
    import_classes
  end

  def import_classes
    classes = Adapters::FightClubFiveEAdapter.retrieve_resource_collection('classes')
    classes.each{|class_info|
      @base_class = ClassSubProcessing::BaseClassBuilder.build(class_info)
      build_trait(class_info)
    }
  end

  private

  def build_trait(class_info)
    class_info['autolevel'].each{|trait_info|
      @trait_info = trait_info
      next if @trait_info[0] == 'level'
      if @trait_info&.key?('feature') && @trait_info['feature'].kind_of?(Array)
        @trait_info['feature'].each{|feature|
          trait_options(feature)
        }
      else
        trait_options(@trait_info['feature'])
      end
    }
  end

  def trait_options(feature)
    if !@trait_info.key?('slots')
      if !@trait_info['feature'].kind_of?(Array) && @trait_info['feature']['name'].present? && !feature['name'].kind_of?(Array)
        if (@trait_info['feature']['name'].match('Starting') || @trait_info['feature']['name'].match('Multiclass'))
          trait_parent_type = 'base_class'
          name = @trait_info['feature']['name']
          parent_id = @base_class.id
        elsif feature['name'].split(':').count < 2
          trait_parent_type = 'base_class'
          name = feature['name']
          parent_id = @base_class.id
        else
          trait_parent_type = 'sub_class'
          name = feature['name'].split(':').last
          sub_class_name = feature['name'].split(':').first
          sub_class = SubClass.find_or_create_by(name: sub_class_name, base_class_id: @base_class.id)
          parent_id = sub_class.id
        end
      elsif @trait_info['feature'].kind_of?(Array)
        if feature['optional'].present? && @trait_info['feature'].first['name'] == feature['name'] && Trait.where(name: feature['name'].split(':')[0]).first.present?
          trait_parent_type = 'trait'
          name = feature['name']
          parent_id = Trait.where(name: name.split(':')[0]).first.id
        elsif feature['optional'].present? && feature['name'].match(@trait_info['feature'].first['name'])
          trait_parent_type = 'trait'
          name = feature['name'].split(':').last
          parent_id = Trait.where(name: feature['name'].split(':')[0]).first.id
        else
          name = feature['name']
          trait_parent_type = 'base_class'
          parent_id = @base_class.id
        end
      elsif feature['name'].kind_of?(Array)
        trait_parent_type = 'sub_class'
        sub_class_name = feature['name'].first.split(':').first
        sub_class = SubClass.find_or_create_by(name: sub_class_name, base_class_id: @base_class.id)
        name = feature['name'].last.split(':')[1]
        parent_id = sub_class.id
      else
        trait_parent_type = 'base_class'
        name = @trait_info['feature']['name'].nil? ? feature['name'] : @trait_info['feature']['name']
        parent_id = @base_class.id
      end
    end
    trait_info_attributes = {
      name: name.strip,
      details: trait_details(feature),
      optional: optional(feature),
      class_level: @trait_info['level'],
      parent_type: trait_parent_type,
      parent_id: parent_id,
      score_improvement: @trait_info['scoreImprovement'].present?,
      spell_slot: spell_slots(feature)
    }
    Trait.create(trait_info_attributes)
  end

  def check_base_class_feature(feature)
    @trait_info['feature']['name'].match('Starting') || @trait_info['feature']['name'].match('Multiclass')
  end

  def optional(feature)
    begin
      @trait_info['feature']['optional']&.present?
    rescue
      return nil if feature.nil? || !feature.key?('optional')
      feature['optional']&.present?
    end
  end

  def trait_details(feature)
    begin
      @trait_info['feature']['text'].kind_of?(Array) ? @trait_info['feature']['text'].join("\n") : @trait_info['feature']['text']
    rescue
      return nil if feature.nil? || !feature.key?('text')
      feature['text'].kind_of?(Array) ? feature['text'].join("\n") : feature['text']
    end
  end

  def spell_slots(feature)
    begin
      @trait_info['feature']['slots'] if @trait_info['feature']['slots']&.present?
    rescue
      return nil if feature.nil? || !feature.key?('slots')
      feature['slots'] if feature['slots']&.present?
    end
  end
end
