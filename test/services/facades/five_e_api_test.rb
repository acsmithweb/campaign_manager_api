require 'test_helper'
require 'rest_client'

class FiveEApiTest < ActiveSupport::TestCase

  test 'get_spells should return the response when call is successfull' do
    mock_response = Minitest::Mock.new
    response_body = "{\"count\":319,\"results\":[{\"index\":\"acid-arrow\",\"name\":\"Acid Arrow\",\"url\":\"/api/spells/acid-arrow\"},{\"index\":\"acid-splash\",\"name\":\"Acid Splash\",\"url\":\"/api/spells/acid-splash\"}]}"
    output = [{"index"=>"acid-arrow", "name"=>"Acid Arrow", "url"=>"/api/spells/acid-arrow"}, {"index"=>"acid-splash", "name"=>"Acid Splash", "url"=>"/api/spells/acid-splash"}]

    mock_response.expect :code, 200
    mock_response.expect :body, response_body
    mock_response.expect :results, output

    RestClient.stub :get, mock_response do
      assert_equal(Facades::FiveEApi.get_spells, output)
    end
  end

  test 'get_monsters should return all monsters when call is successfull' do
    mock_response = Minitest::Mock.new
    response_body = "{\"count\":319,\"results\":[{\"index\":\"rat\",\"name\":\"Rat\",\"size\":\"Tiny\",\"type\":\"beast\",\"subtype\":\"\",\"alignment\":\"unaligned\",\"armor_class\":10,\"hit_points\":1,\"hit_dice\":\"1d4\",\"speed\":{\"walk\":\"20 ft.\"},\"strength\":2,\"dexterity\":11,\"constitution\":9,\"intelligence\":2,\"wisdom\":10,\"charisma\":4,\"proficiencies\":[],\"damage_vulnerabilities\":[],\"damage_resistances\":[],\"damage_immunities\":[],\"condition_immunities\":[],\"senses\":{\"darkvision\":\"30 ft.\",\"passive_perception\":10},\"languages\":\"\",\"challenge_rating\":0,\"xp\":10,\"special_abilities\":[{\"name\":\"Keen Smell\",\"desc\":\"The rat has advantage on Wisdom (Perception) checks that rely on smell.\"}],\"actions\":[{\"name\":\"Bite\",\"desc\":\"Melee Weapon Attack: +0 to hit, reach 5 ft., one target. Hit: 1 piercing damage.\",\"attack_bonus\":0,\"damage\":[{\"damage_type\":{\"index\":\"piercing\",\"name\":\"Piercing\",\"url\":\"/api/damage-types/piercing\"},\"damage_dice\":\"1\"}]}],\"url\":\"/api/monsters/rat\"}]}"
    output = [{"index"=>"rat","name"=>"Rat","size"=>"Tiny","type"=>"beast","subtype"=>"","alignment"=>"unaligned","armor_class"=>10,"hit_points"=>1,"hit_dice"=>"1d4","speed"=>{"walk"=>"20 ft."},"strength"=>2,"dexterity"=>11,"constitution"=>9,"intelligence"=>2,"wisdom"=>10,"charisma"=>4,"proficiencies"=>[],"damage_vulnerabilities"=>[],"damage_resistances"=>[],"damage_immunities"=>[],"condition_immunities"=>[],"senses"=>{"darkvision"=>"30 ft.","passive_perception"=>10},"languages"=>"","challenge_rating"=>0,"xp"=>10,"special_abilities"=>[{"name"=>"Keen Smell","desc"=>"The rat has advantage on Wisdom (Perception) checks that rely on smell."}],"actions"=>[{"name"=>"Bite","desc"=>"Melee Weapon Attack: +0 to hit, reach 5 ft., one target. Hit: 1 piercing damage.","attack_bonus"=>0,"damage"=>[{"damage_type"=>{"index"=>"piercing","name"=>"Piercing","url"=>"/api/damage-types/piercing"},"damage_dice"=>"1"}]}],"url"=>"/api/monsters/rat"}]

    mock_response.expect :code, 200
    mock_response.expect :body, response_body
    mock_response.expect :results, output

    RestClient.stub :get, mock_response do
      assert_equal(Facades::FiveEApi.get_monsters, output)
    end
  end

  test 'get_spell should return the response when call is successfull and name type is used' do
    mock_response = Minitest::Mock.new
    response_body = "{\"index\":\"acid-arrow\",\"name\":\"Acid Arrow\",\"desc\":[\"A shimmering green arrow streaks toward a target within range and bursts in a spray of acid. Make a ranged spell attack against the target. On a hit, the target takes 4d4 acid damage immediately and 2d4 acid damage at the end of its next turn. On a miss, the arrow splashes the target with acid for half as much of the initial damage and no damage at the end of its next turn.\"],\"higher_level\":[\"When you cast this spell using a spell slot of 3rd level or higher, the damage (both initial and later) increases by 1d4 for each slot level above 2nd.\"],\"range\":\"90 feet\",\"components\":[\"V\",\"S\",\"M\"],\"material\":\"Powdered rhubarb leaf and an adder's stomach.\",\"ritual\":false,\"duration\":\"Instantaneous\",\"concentration\":false,\"casting_time\":\"1 action\",\"level\":2,\"attack_type\":\"ranged\",\"damage\":{\"damage_type\":{\"index\":\"acid\",\"name\":\"Acid\",\"url\":\"/api/damage-types/acid\"},\"damage_at_slot_level\":{\"2\":\"4d4\",\"3\":\"5d4\",\"4\":\"6d4\",\"5\":\"7d4\",\"6\":\"8d4\",\"7\":\"9d4\",\"8\":\"10d4\",\"9\":\"11d4\"}},\"school\":{\"index\":\"evocation\",\"name\":\"Evocation\",\"url\":\"/api/magic-schools/evocation\"},\"classes\":[{\"index\":\"wizard\",\"name\":\"Wizard\",\"url\":\"/api/classes/wizard\"}],\"subclasses\":[{\"index\":\"lore\",\"name\":\"Lore\",\"url\":\"/api/subclasses/lore\"},{\"index\":\"land\",\"name\":\"Land\",\"url\":\"/api/subclasses/land\"}],\"url\":\"/api/spells/acid-arrow\"}"

    mock_response.expect :code, 200
    mock_response.expect :body, response_body

    RestClient.stub :get, mock_response do
      assert_equal(Facades::FiveEApi.get_spell('aCid aRRow','nAme'), response_body)
    end
  end

  test 'get_spell should return the response when call is successfull and url type is used' do
    mock_response = Minitest::Mock.new
    response_body = "{\"index\":\"acid-arrow\",\"name\":\"Acid Arrow\",\"desc\":[\"A shimmering green arrow streaks toward a target within range and bursts in a spray of acid. Make a ranged spell attack against the target. On a hit, the target takes 4d4 acid damage immediately and 2d4 acid damage at the end of its next turn. On a miss, the arrow splashes the target with acid for half as much of the initial damage and no damage at the end of its next turn.\"],\"higher_level\":[\"When you cast this spell using a spell slot of 3rd level or higher, the damage (both initial and later) increases by 1d4 for each slot level above 2nd.\"],\"range\":\"90 feet\",\"components\":[\"V\",\"S\",\"M\"],\"material\":\"Powdered rhubarb leaf and an adder's stomach.\",\"ritual\":false,\"duration\":\"Instantaneous\",\"concentration\":false,\"casting_time\":\"1 action\",\"level\":2,\"attack_type\":\"ranged\",\"damage\":{\"damage_type\":{\"index\":\"acid\",\"name\":\"Acid\",\"url\":\"/api/damage-types/acid\"},\"damage_at_slot_level\":{\"2\":\"4d4\",\"3\":\"5d4\",\"4\":\"6d4\",\"5\":\"7d4\",\"6\":\"8d4\",\"7\":\"9d4\",\"8\":\"10d4\",\"9\":\"11d4\"}},\"school\":{\"index\":\"evocation\",\"name\":\"Evocation\",\"url\":\"/api/magic-schools/evocation\"},\"classes\":[{\"index\":\"wizard\",\"name\":\"Wizard\",\"url\":\"/api/classes/wizard\"}],\"subclasses\":[{\"index\":\"lore\",\"name\":\"Lore\",\"url\":\"/api/subclasses/lore\"},{\"index\":\"land\",\"name\":\"Land\",\"url\":\"/api/subclasses/land\"}],\"url\":\"/api/spells/acid-arrow\"}"

    mock_response.expect :body, response_body
    mock_response.expect :code, 200

    RestClient.stub :get, mock_response do
      assert_equal(Facades::FiveEApi.get_spell('/api/spells/acid-arrow','uRl'), response_body)
    end
  end

  test 'get_spell should return the response when call is successfull and index type is used' do
    mock_response = Minitest::Mock.new
    response_body = "{\"index\":\"acid-arrow\",\"name\":\"Acid Arrow\",\"desc\":[\"A shimmering green arrow streaks toward a target within range and bursts in a spray of acid. Make a ranged spell attack against the target. On a hit, the target takes 4d4 acid damage immediately and 2d4 acid damage at the end of its next turn. On a miss, the arrow splashes the target with acid for half as much of the initial damage and no damage at the end of its next turn.\"],\"higher_level\":[\"When you cast this spell using a spell slot of 3rd level or higher, the damage (both initial and later) increases by 1d4 for each slot level above 2nd.\"],\"range\":\"90 feet\",\"components\":[\"V\",\"S\",\"M\"],\"material\":\"Powdered rhubarb leaf and an adder's stomach.\",\"ritual\":false,\"duration\":\"Instantaneous\",\"concentration\":false,\"casting_time\":\"1 action\",\"level\":2,\"attack_type\":\"ranged\",\"damage\":{\"damage_type\":{\"index\":\"acid\",\"name\":\"Acid\",\"url\":\"/api/damage-types/acid\"},\"damage_at_slot_level\":{\"2\":\"4d4\",\"3\":\"5d4\",\"4\":\"6d4\",\"5\":\"7d4\",\"6\":\"8d4\",\"7\":\"9d4\",\"8\":\"10d4\",\"9\":\"11d4\"}},\"school\":{\"index\":\"evocation\",\"name\":\"Evocation\",\"url\":\"/api/magic-schools/evocation\"},\"classes\":[{\"index\":\"wizard\",\"name\":\"Wizard\",\"url\":\"/api/classes/wizard\"}],\"subclasses\":[{\"index\":\"lore\",\"name\":\"Lore\",\"url\":\"/api/subclasses/lore\"},{\"index\":\"land\",\"name\":\"Land\",\"url\":\"/api/subclasses/land\"}],\"url\":\"/api/spells/acid-arrow\"}"

    mock_response.expect :body, response_body
    mock_response.expect :code, 200

    RestClient.stub :get, mock_response do
      assert_equal(Facades::FiveEApi.get_spell('acid-arrow','InDex'), response_body)
    end
  end

  test 'get_monster should return given creatures index, name and url' do
    mock_response = Minitest::Mock.new
    response_body = "{\"index\":\"rat\",\"name\":\"Rat\",\"size\":\"Tiny\",\"type\":\"beast\",\"subtype\":\"\",\"alignment\":\"unaligned\",\"armor_class\":10,\"hit_points\":1,\"hit_dice\":\"1d4\",\"speed\":{\"walk\":\"20 ft.\"},\"strength\":2,\"dexterity\":11,\"constitution\":9,\"intelligence\":2,\"wisdom\":10,\"charisma\":4,\"proficiencies\":[],\"damage_vulnerabilities\":[],\"damage_resistances\":[],\"damage_immunities\":[],\"condition_immunities\":[],\"senses\":{\"darkvision\":\"30 ft.\",\"passive_perception\":10},\"languages\":\"\",\"challenge_rating\":0,\"xp\":10,\"special_abilities\":[{\"name\":\"Keen Smell\",\"desc\":\"The rat has advantage on Wisdom (Perception) checks that rely on smell.\"}],\"actions\":[{\"name\":\"Bite\",\"desc\":\"Melee Weapon Attack: +0 to hit, reach 5 ft., one target. Hit: 1 piercing damage.\",\"attack_bonus\":0,\"damage\":[{\"damage_type\":{\"index\":\"piercing\",\"name\":\"Piercing\",\"url\":\"/api/damage-types/piercing\"},\"damage_dice\":\"1\"}]}],\"url\":\"/api/monsters/rat\"}"


    mock_response.expect :body, response_body
    mock_response.expect :code, 200

    RestClient.stub :get, mock_response do
      assert_equal(Facades::FiveEApi.get_monster('adult-black-dragon','InDex'), response_body)
    end
  end

  test 'get_spell should not return the response when incorrect value_type is used' do
    mock = Minitest::Mock.new
    mock_response = Minitest::Mock.new

    mock.expect :get, mock_response, ['https://www.dnd5eapi.co/api/spells/fireball']

    RestClient.stub :get, mock_response do
      err = assert_raises RuntimeError do
        Facades::FiveEApi.get_spell('acid-arrow', 'not index')
      end
      assert_equal('Incorrect value type entered', err.message)
    end
  end

  test 'get_spell should raise an error when an invalid spell is called' do
    mock_response = Minitest::Mock.new

    mock_response.expect :code, 404

    RestClient.stub :get, mock_response do
      err = assert_raises RuntimeError do
        Facades::FiveEApi.get_spell('cheese', 'index')
      end
      assert_equal('404 record not found', err.message)
    end
  end

  test 'get_spell should raise an error when an unhandled response code returns 500' do
    mock_response = Minitest::Mock.new

    mock_response.expect :code, 500

    RestClient.stub :get, mock_response do
      err = assert_raises RuntimeError do
        Facades::FiveEApi.get_spell('cheese', 'index')
      end
      assert_equal('Unhandled Error 500', err.message)
    end
  end
end
