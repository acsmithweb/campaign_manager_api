require 'test_helper'

class FiveEApiMonsterImportServiceTest < ActiveSupport::TestCase
  test 'execute should create monsters pulled from 5eapiadapter' do

    mock_all_monsters = Minitest::Mock.new

    monsters_from_api = [{"index":"rat","name":"Rat","size":"Tiny","type":"beast","subtype":"","alignment":"unaligned","armor_class":10,"hit_points":1,"hit_dice":"1d4","speed":{"walk":"20 ft."},"strength":2,"dexterity":11,"constitution":9,"intelligence":2,"wisdom":10,"charisma":4,"proficiencies":[],"damage_vulnerabilities":[],"damage_resistances":[],"damage_immunities":[],"condition_immunities":[],"senses":{"darkvision":"30 ft.","passive_perception":10},"languages":"","challenge_rating":0,"xp":10,"special_abilities":[{"name":"Keen Smell","desc":"The rat has advantage on Wisdom (Perception) checks that rely on smell."}],"actions":[{"name":"Bite","desc":"Melee Weapon Attack: +0 to hit, reach 5 ft., one target. Hit: 1 piercing damage.","attack_bonus":0,"damage":[{"damage_type":{"index":"piercing","name":"Piercing","url":"/api/damage-types/piercing"},"damage_dice":"1"}]}],"url":"/api/monsters/rat"}]

    decoded_monsters_from_api = {"index"=>"rat","name"=>"Rat","size"=>"Tiny","type"=>"beast","subtype"=>"","alignment"=>"unaligned","armor_class"=>10,"hit_points"=>1,"hit_dice"=>"1d4","speed"=>{"walk"=>"20 ft."},"strength"=>2,"dexterity"=>11,"constitution"=>9,"intelligence"=>2,"wisdom"=>10,"charisma"=>4,"proficiencies"=>[],"damage_vulnerabilities"=>[],"damage_resistances"=>[],"damage_immunities"=>[],"condition_immunities"=>[],"senses"=>{"darkvision"=>"30 ft.","passive_perception"=>10},"languages"=>"","challenge_rating"=>0,"xp"=>10,"special_abilities"=>[{"name"=>"Keen Smell","desc"=>"The rat has advantage on Wisdom (Perception) checks that rely on smell."}],"actions"=>[{"name"=>"Bite","desc"=>"Melee Weapon Attack: +0 to hit, reach 5 ft., one target. Hit: 1 piercing damage.","attack_bonus"=>0,"damage"=>[{"damage_type"=>{"index"=>"piercing","name"=>"Piercing","url"=>"/api/damage-types/piercing"},"damage_dice"=>"1"}]}],"url"=>"/api/monsters/rat"}

    created_monster = StatBlock.new({"id"=>3, "name"=>"Rat", "size"=>nil, "armor_class"=>10, "hit_points"=>1, "hit_dice"=>"1d4", "speed"=>"walk: 20 ft. \n", "str"=>2, "dex"=>11, "con"=>9, "int"=>2, "wis"=>10, "cha"=>4, "saving_throws"=>"", "skills"=>"", "damage_resistance"=>"", "condition_immunities"=>"", "damage_immunities"=>"", "vulnerability"=>"", "senses"=>"darkvision: 30 ft. \npassive_perception: 10 \n", "languages"=>"", "challenge_rating"=>0, "experience_points"=>10, "abilities"=>"Keen Smell: The rat has advantage on Wisdom (Perception) checks that rely on smell.\n", "actions"=>"Bite: Melee Weapon Attack: +0 to hit, reach 5 ft., one target. Hit: 1 piercing damage.\n", "legendary_actions"=>"", "creature_type"=>"beast", "alignment"=>"unaligned"})

    Adapters::FiveEApiAdapter.stub :get_details_for, monsters_from_api do
      ActiveSupport::JSON.stub :decode, decoded_monsters_from_api do
        FiveEApiMonsterImportService.new.execute
        assert_equal(StatBlock.find_by(name: 'Rat'), created_monster)
      end
    end
  end
end
