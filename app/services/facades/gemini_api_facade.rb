require 'rest-client'

class Facades::GeminiApiFacade
  attr_accessor :content

  URL = "https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key="

  def initialize(api_key)
    @api_key = api_key
    @content = {
      "contents":[]
    }
    @token_url = "#{URL}#{api_key}"
  end

  def chat(conversation)
    buffer = @content
    buffer[:contents].push(format_post('user',conversation))
    begin
      result = ActiveSupport::JSON.decode(RestClient.post(@token_url, buffer.to_json, {content_type: :json, accept: :json}))
      response = result['candidates'].first['content']
      @content[:contents] = buffer[:contents].push(format_post(response['role'],response['parts'].first['text']))
    rescue => e
      puts e
    end
    recent_response
  end

  def clear_last_response
    content[:contents].pop
  end

  def display_conversation
    content[:contents].each{|element| puts '-------------'; puts element[:parts].first[:text]}
  end

  def recent_response
    content[:contents].last[:parts].first[:text]
  end

  private

  def format_post(role, text)
    {
      "role":role,
      "parts": [{"text": text}]
    }
  end
end
