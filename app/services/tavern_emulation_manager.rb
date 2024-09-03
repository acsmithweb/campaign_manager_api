class TavernEmulationManager
  attr_accessor :questline_manager

  def initiate_chapter(campaign_name, chapter_name)
    chapter_files = Dir.glob("/shared_hdd/My Drive/Dnd Stuff/Campaigns/CampaignNotes/OrlaCampaign/Campaigns/#{campaign_name}/Campaign Chapters/**/*").map{|file| file.gsub("/shared_hdd/My Drive/Dnd Stuff/Campaigns/CampaignNotes/OrlaCampaign/Campaigns/#{campaign_name}/Campaign Chapters/",'') if file.match("#{chapter_name}.md")}.compact
    index_file = chapter_files.select{|file| file if file.match("#{chapter_name}.md")}.first
    @questline_manager = ChatProfiles::SceneManager.new('api_key', index_file)
  end

  def questline_manager
    @questline_manager
  end

  def initiate_profiles(location)
    location_files = Dir.glob("/shared_hdd/My Drive/Dnd Stuff/Campaigns/CampaignNotes/OrlaCampaign/Settings Info/**/*").map{|file| file.gsub('/shared_hdd/My Drive/Dnd Stuff/Campaigns/CampaignNotes/OrlaCampaign','').split('/Cledo/').last if file.match(location) && file.match('.md')}.compact

  end
end
