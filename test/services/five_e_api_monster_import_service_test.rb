require 'test_helper'

class FiveEApiMonsterImportServiceTest < ActiveSupport::TestCase
  test 'execute should create monsters pulled from 5eapiadapter' do

    mock_all_monsters = Minitest::Mock.new

    monsters_from_api = [{"index":"rat","name":"Rat","size":"Tiny","type":"beast","subtype":"","alignment":"unaligned","armor_class":10,"hit_points":1,"hit_dice":"1d4","speed":{"walk":"20 ft."},"strength":2,"dexterity":11,"constitution":9,"intelligence":2,"wisdom":10,"charisma":4,"proficiencies":[],"damage_vulnerabilities":[],"damage_resistances":[],"damage_immunities":[],"condition_immunities":[],"senses":{"darkvision":"30 ft.","passive_perception":10},"languages":"","challenge_rating":0,"xp":10,"special_abilities":[{"name":"Keen Smell","desc":"The rat has advantage on Wisdom (Perception) checks that rely on smell."}],"actions":[{"name":"Bite","desc":"Melee Weapon Attack: +0 to hit, reach 5 ft., one target. Hit: 1 piercing damage.","attack_bonus":0,"damage":[{"damage_type":{"index":"piercing","name":"Piercing","url":"/api/damage-types/piercing"},"damage_dice":"1"}]}],"url":"/api/monsters/rat"}]

    decoded_monsters_from_api = [{"index"=>"rat","name"=>"Rat","size"=>"Tiny","type"=>"beast","subtype"=>"","alignment"=>"unaligned","armor_class"=>10,"hit_points"=>1,"hit_dice"=>"1d4","speed"=>{"walk"=>"20 ft."},"strength"=>2,"dexterity"=>11,"constitution"=>9,"intelligence"=>2,"wisdom"=>10,"charisma"=>4,"proficiencies"=>[],"damage_vulnerabilities"=>[],"damage_resistances"=>[],"damage_immunities"=>[],"condition_immunities"=>[],"senses"=>{"darkvision"=>"30 ft.","passive_perception"=>10},"languages"=>"","challenge_rating"=>0,"xp"=>10,"special_abilities"=>[{"name"=>"Keen Smell","desc"=>"The rat has advantage on Wisdom (Perception) checks that rely on smell."}],"actions"=>[{"name"=>"Bite","desc"=>"Melee Weapon Attack: +0 to hit, reach 5 ft., one target. Hit: 1 piercing damage.","attack_bonus"=>0,"damage"=>[{"damage_type"=>{"index"=>"piercing","name"=>"Piercing","url"=>"/api/damage-types/piercing"},"damage_dice"=>"1"}]}],"url"=>"/api/monsters/rat"}]

    created_monster = nil

    Adapters::FiveEApiAdapter.stub :get_details_for, monsters_from_api do
      ActiveSupport::JSON.stub :decode, decoded_monsters_from_api do
        FiveEApiMonsterImportService.new.execute
        assert_equal(StatBlock.find_by(name: 'Black Tentacles'), created_spell)
      end
    end
  end
end
