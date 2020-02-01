require 'test_helper'


class StatBlockTest < ActiveSupport::TestCase
  setup do
    stat_block_attributes =
    {
      id: 3,
      name: 'GiantSpider',
      armor_class: 13,
      hit_points: 10,
      speed: 'land: 30ft',
      str: 10,
      dex: 10,
      con: 10,
      int: 10,
      wis: 10,
      cha: 10,
      saving_throws: 'Wis(+2)',
      skills: 'Skillz',
      damage_resistance:'Bludgeoning',
      condition_immunities:'Exhaustion',
      senses:'Darkvision(10ft)',
      languages:'Common',
      challenge_rating:1,
      experience_points:100,
      abilities:'Cool Abilities',
      actions:'Cool Actions',
      legendary_actions:'Legendary Actions',
      creature_type:'Beast',
      alignment:'Chaotic Neutral',
      created_at:'2020-01-25T15:56:17.623Z',
      updated_at:'2020-01-25T15:56:17.623Z'
    }
    @valid_stat_block = StatBlock.new(stat_block_attributes)
  end

  test 'StatBlock should be valid' do
    assert @valid_stat_block.valid?
  end

  test 'StatBlock should not be valid when name has more than 32 characters' do
    @valid_stat_block.name = 'a' * 34
    refute @valid_stat_block.valid?
  end

  test 'StatBlock should not be valid when name is not present' do
    @valid_stat_block.name = nil
    refute @valid_stat_block.valid?
  end

  test 'StatBlock should not be valid when armor class is not numeric' do
    @valid_stat_block.armor_class = 'a'
    refute @valid_stat_block.valid?
  end

  test 'StatBlock should not be valid when armor class is not present' do
    @valid_stat_block.armor_class = nil
    refute @valid_stat_block.valid?
  end

  test 'StatBlock should not be valid when hit points is not numeric' do
    @valid_stat_block.hit_points = 'a'
    refute @valid_stat_block.valid?
  end

  test 'StatBlock should not be valid when hit points is not present' do
    @valid_stat_block.hit_points = nil
    refute @valid_stat_block.valid?
  end

  test 'StatBlock should not be valid when str is not numeric' do
    @valid_stat_block.str = 'a'
    refute @valid_stat_block.valid?
  end

  test 'StatBlock should not be valid when str is not present' do
    @valid_stat_block.str = nil
    refute @valid_stat_block.valid?
  end

  test 'StatBlock should not be valid when dex is not numeric' do
    @valid_stat_block.dex = 'a'
    refute @valid_stat_block.valid?
  end

  test 'StatBlock should not be valid when dex is not present' do
    @valid_stat_block.dex = nil
    refute @valid_stat_block.valid?
  end

  test 'StatBlock should not be valid when con is not numeric' do
    @valid_stat_block.con = 'a'
    refute @valid_stat_block.valid?
  end

  test 'StatBlock should not be valid when con is not present' do
    @valid_stat_block.con = nil
    refute @valid_stat_block.valid?
  end

  test 'StatBlock should not be valid when int is not numeric' do
    @valid_stat_block.int = 'a'
    refute @valid_stat_block.valid?
  end

  test 'StatBlock should not be valid when int is not present' do
    @valid_stat_block.int = nil
    refute @valid_stat_block.valid?
  end

  test 'StatBlock should not be valid when wis is not numeric' do
    @valid_stat_block.wis = 'a'
    refute @valid_stat_block.valid?
  end

  test 'StatBlock should not be valid when wis is not present' do
    @valid_stat_block.wis = nil
    refute @valid_stat_block.valid?
  end

  test 'StatBlock should not be valid when cha is not numeric' do
    @valid_stat_block.cha = 'a'
    refute @valid_stat_block.valid?
  end

  test 'StatBlock should not be valid when cha is not present' do
    @valid_stat_block.cha = nil
    refute @valid_stat_block.valid?
  end

  test 'StatBlock should not be valid when challenge rating is not numeric' do
    @valid_stat_block.challenge_rating = 'a'
    refute @valid_stat_block.valid?
  end

  test 'StatBlock should not be valid when challenge rating is not present' do
    @valid_stat_block.challenge_rating = nil
    refute @valid_stat_block.valid?
  end

  test 'StatBlock should not be valid when experience_points is not present' do
    @valid_stat_block.experience_points = nil
    refute @valid_stat_block.valid?
  end

  test 'StatBlock should not be valid when creature_type is not present' do
    @valid_stat_block.creature_type = nil
    refute @valid_stat_block.valid?
  end
end
