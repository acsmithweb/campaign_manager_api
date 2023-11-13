class Categorizer::CategoryOrchestrator

  def self.execute(creature)
    @creature = creature
    get_likely_categories
  end

  def self.get_likely_categories
    selected_categories = {}

    Category.all.each do |category|
      cat_score = category.calculate_tf_idf(@creature).count
      selected_categories[category.category_type.to_sym] = cat_score
    end

    return selected_categories
  end

  
end
