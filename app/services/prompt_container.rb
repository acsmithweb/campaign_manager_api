class PromptContainer
  attr_accessor :vector_array, :container_prompt

  def initialize(prompt)
    @container_prompt = prompt
    @vector_array = []
    calculate_tf_idf
  end

  def calculate_tf_idf
    return @vector_array unless @vector_array.empty?
    TextWordCounterService.execute(@container_prompt).each {|key, value|
      tf = (value[:term_frequency].to_f * (1 + Math.log(1/value[:term_frequency].to_f))).to_f
      @vector_array << [key, tf]
    }
  end
end
