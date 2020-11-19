require 'test_helper'

class SpellTest < ActiveSupport::TestCase
  setup do
    spell_attributes =
    {
      name: 'sleep',
      desc: 'sleep description',
      higher_level: 'do the thing better at a higher level',
      range: '20ft',
      components: 'V,S,M',
      material: 'Keese Wings',
      ritual: false,
      duration: '1 minute',
      concentration: false,
      casting_time: '1 Action',
      level: '3',
      damage_at_slot_level: {
        "3": "8d6",
  			"4": "9d6",
  			"5": "10d6",
  			"6": "11d6",
  			"7": "12d6",
  			"8": "13d6",
  			"9": "14d6"
      },
      dc: {
        type: 'DEX',
        success: 'half'
      },
      area_of_effect: {
        type: 'Cube',
        size: '60ft'
      },
      school: 'evocation',
      classes: 'Sorcerer'
    }
    @valid_spell = Spell.new(spell_attributes)
  end

  test 'Spell should be valid' do
    assert @valid_spell.valid?
  end

  test 'Spell should not be valid when name is not present' do
    @valid_spell.name = nil
    refute @valid_spell.valid?
  end

  test 'Spell should not be valid when desc is not present' do
    @valid_spell.desc = nil
    refute @valid_spell.valid?
  end

  test 'spell should not be valid when range is not present' do
    @valid_spell.range = nil
    refute @valid_spell.valid?
  end

  test 'spell should not be valid when components is not present' do
    @valid_spell.components = nil
    refute @valid_spell.valid?
  end

  test 'spell should not be valid when duration is not present' do
    @valid_spell.duration = nil
    refute @valid_spell.valid?
  end

  test 'spell should not be valid when casting_time is not present' do
    @valid_spell.casting_time = nil
    refute @valid_spell.valid?
  end

  test 'spell should not be valid when level is not present' do
    @valid_spell.level = nil
    refute @valid_spell.valid?
  end

  test 'spell should not be valid when school is not present' do
    @valid_spell.school = nil
    refute @valid_spell.valid?
  end

  test 'spell should not be valid when classes is not present' do
    @valid_spell.classes = nil
    refute @valid_spell.valid?
  end
end
