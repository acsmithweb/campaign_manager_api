class BaseClass < ApplicationRecord
  include PgSearch::Model

  def class_traits
    # probably just do some joins
    main_features = Trait.where(parent_type: 'base_class', parent_id: self.id)
    feature_details = {}
    main_features.each { |feature|
      feature_details[feature.name.to_sym] = [] unless feature_details[feature.name.to_sym].present?
      feature_details[feature.name.to_sym] << feature
      feature_traits = Trait.where(parent_type: 'trait', parent_id: feature.id).order(:class_level).to_a.flatten
      feature_details[feature.name.to_sym] << feature_traits unless feature_traits.empty?
    }
    feature_details.each{|key, value| puts value.map(&:id)}
  end

  def associated_sub_classes
    SubClass.where(base_class_id: self.id)
  end
end
