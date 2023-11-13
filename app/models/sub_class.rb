class SubClass < ApplicationRecord
  include PgSearch::Model

  def sub_class_traits
    main_features = Trait.where(parent_type: 'sub_class', parent_id: self.id)
    feature_details = {}
    main_features.each { |feature|
      feature_details[feature.name.to_sym] = [] unless feature_details[feature.name.to_sym].present?
      feature_details[feature.name.to_sym] << {description: feature.details}
      feature_traits = Trait.where(parent_type: 'trait', parent_id: feature.id).to_a.flatten
      feature_details[feature.name.to_sym] << {traits: feature_traits} unless feature_traits.empty?
    }
    feature_details
  end
end
