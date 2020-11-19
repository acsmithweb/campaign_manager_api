require 'test_helper'
require 'rest_client'

class Adapters::FiveEApiAdapterTest < ActiveSupport::TestCase
  test 'get_all_spells should return the body response when call is successfull' do
    mock = Minitest::Mock.new
    mock_total_spells_response = Minitest::Mock.new
    mock_single_spell_response = Minitest::Mock.new


    spell_result_name = [{"index"=>"word-of-recall", "name"=>"Word of Recall", "url"=>"/api/spells/word-of-recall"}]

    spell_name = {"index"=>"word-of-recall", "name"=>"Word of Recall", "url"=>"/api/spells/word-of-recall"}

    test_spell_result = [{"index"=>"word-of-recall", "name"=>"Word of Recall", "desc"=>["You and up to five willing creatures within 5 feet of you instantly teleport to a previously designated sanctuary. You and any creatures that teleport with you appear in the nearest unoccupied space to the spot you designated when you prepared your sanctuary (see below). If you cast this spell without first preparing a sanctuary, the spell has no effect.", "You must designate a sanctuary by casting this spell within a location, such as a temple, dedicated to or strongly linked to your deity. If you attempt to cast the spell in this manner in an area that isn't dedicated to your deity, the spell has no effect."], "range"=>"5 feet", "components"=>["V"], "ritual"=>false, "duration"=>"Instantaneous", "concentration"=>false, "casting_time"=>"1 action", "level"=>6, "area_of_effect"=>{"type"=>"sphere", "size"=>5}, "school"=>{"index"=>"conjuration", "name"=>"Conjuration", "url"=>"/api/magic-schools/conjuration"}, "classes"=>[{"index"=>"cleric", "name"=>"Cleric", "url"=>"/api/classes/cleric"}], "subclasses"=>[], "url"=>"/api/spells/word-of-recall"}]

    mock.expect :get, spell_name

    Facades::FiveEApi.stub :get_spells, spell_result_name do
      Facades::FiveEApi.stub :get_spell, test_spell_result do
        assert_equal(Adapters::FiveEApiAdapter.get_all_spells, [test_spell_result])
      end
    end
  end
end
