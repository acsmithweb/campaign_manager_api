class ChatClientCache

  def self.retrieve_client(client_id)
    return nil if client_id.nil? || @cache.nil?
    @cache[client_id]
  end

  def self.update_client(client_id, client)
    @cache[client_id]
  end

  def self.client_cache(client)
    if @cache.nil?
      @cache = {}
    end
    @cache.merge!(client)
  end
end
