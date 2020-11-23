require 'test_helper'

class StatBlocksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @stat_block = stat_blocks(:one)
  end

  test "should get index" do
    get stat_blocks_url, as: :json

    expected =
    [
      {
        "id"=>1,
        "name"=>"TestCritter",
        "size"=>"medium",
        "armor_class"=>10,
        "hit_points"=>10,
        "hit_dice"=>"3d6",
        "speed"=>"land: 30ft",
        "str"=>10,
        "dex"=>10,
        "con"=>10,
        "int"=>10,
        "wis"=>10,
        "cha"=>10,
        "saving_throws"=>"Wis(+2)",
        "skills"=>"Cool Skillz",
        "damage_resistance"=>"Bludgeoning",
        "condition_immunities"=>"Exhaustion",
        "damage_immunities"=>nil,
        "vulnerability"=>nil,
        "senses"=>"Darkvision(10ft)",
        "languages"=>"Common",
        "challenge_rating"=>1,
        "experience_points"=>100,
        "abilities"=>"Cool Abilities",
        "actions"=>"Cool Actions",
        "legendary_actions"=>"Legendary Actions",
        "creature_type"=>"Beast",
        "alignment"=>"Chaotic Neutral",
        "created_at"=>"2020-01-25T15:56:17.623Z",
        "updated_at"=>"2020-01-25T15:56:17.623Z"
      },
      {
        "id"=>2,
        "name"=>"MyString",
        "armor_class"=>1,
        "hit_points"=>1,
        "size"=>"medium",
        "hit_dice"=>"3d6",
        "speed"=>"MyText",
        "str"=>1,
        "dex"=>1,
        "con"=>1,
        "int"=>1,
        "wis"=>1,
        "cha"=>1,
        "saving_throws"=>"MyText",
        "skills"=>"MyText",
        "damage_resistance"=>"MyText",
        "condition_immunities"=>"MyText",
        "damage_immunities"=>nil,
        "vulnerability"=>nil,
        "senses"=>"MyText",
        "languages"=>"MyText",
        "challenge_rating"=>1,
        "experience_points"=>1,
        "abilities"=>"MyText",
        "actions"=>"MyText",
        "legendary_actions"=>"MyText",
        "creature_type"=>"MyString",
        "alignment"=>"MyString",
        "created_at"=>"2020-01-25T15:56:17.623Z",
        "updated_at"=>"2020-01-25T15:56:17.623Z"
      }
    ]
    actual = JSON.parse(@response.body)

    assert_equal(expected, actual)
    assert_response :success
  end

  test "should create stat_block" do
    assert_difference('StatBlock.count') do
      post stat_blocks_url, params: { stat_block: { abilities: @stat_block.abilities, actions: @stat_block.actions, alignment: @stat_block.alignment, armor_class: @stat_block.armor_class, cha: @stat_block.cha, challenge_rating: @stat_block.challenge_rating, con: @stat_block.con, condition_immunities: @stat_block.condition_immunities, creature_type: @stat_block.creature_type, damage_resistance: @stat_block.damage_resistance, dex: @stat_block.dex, experience_points: @stat_block.experience_points, hit_points: @stat_block.hit_points, int: @stat_block.int, languages: @stat_block.languages, legendary_actions: @stat_block.legendary_actions, name: @stat_block.name, saving_throws: @stat_block.saving_throws, senses: @stat_block.senses, skills: @stat_block.skills, speed: @stat_block.speed, str: @stat_block.str, wis: @stat_block.wis } }, as: :json
    end

    assert(StatBlock.where(id: @stat_block.id).exists?)
    assert_response 201
  end

  test "should show stat_block" do
    get stat_block_url(@stat_block), as: :json
    assert_response :success
  end

  test "should update stat_block" do
    patch stat_block_url(@stat_block), params: { stat_block: { abilities: @stat_block.abilities, actions: @stat_block.actions, alignment: @stat_block.alignment, armor_class: @stat_block.armor_class, cha: @stat_block.cha, challenge_rating: @stat_block.challenge_rating, con: @stat_block.con, condition_immunities: @stat_block.condition_immunities, creature_type: @stat_block.creature_type, damage_resistance: @stat_block.damage_resistance, dex: @stat_block.dex, experience_points: @stat_block.experience_points, hit_points: @stat_block.hit_points, int: @stat_block.int, languages: @stat_block.languages, legendary_actions: @stat_block.legendary_actions, name: @stat_block.name, saving_throws: @stat_block.saving_throws, senses: @stat_block.senses, skills: @stat_block.skills, speed: @stat_block.speed, str: @stat_block.str, wis: @stat_block.wis } }, as: :json
    assert_response 200
  end

  test "should destroy stat_block" do
    assert_difference('StatBlock.count', -1) do
      delete stat_block_url(@stat_block), as: :json
    end

    refute(StatBlock.where(id: @stat_block.id).exists?)
    assert_response 204
  end
end
