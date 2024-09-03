class ChatClientController < ApplicationController
  before_action :initialize_client, only: [:chat]

  def chat
    render json: {client_id: @chat_id, chat_history: @client.chat_history, last_response: @client.last_response}
  end

  private

  def initialize_client
    if @client = ChatClientCache.retrieve_client(chat_params[:chat_id])
      @chat_id = chat_params[:chat_id]
      @client.chat(chat_params[:contents])
    else
      @chat_id = generate_chat_id
      @client = ChatProfiles::DmQuickAssist.new(chat_params[:api_key],chat_params[:contents])
      ChatClientCache.client_cache(Hash[@chat_id, @client])
    end
  end

  def chat_params
    params#.permit(:chat_id,:user_message,:contents,:context,:api_key,:chat_client)
  end

  def generate_chat_id
    SecureRandom.hex(8) unless chat_params[:chat_id]
  end
end
